#!/bin/bash

# Variables
NAMESPACE="monitoring-testing-october20"
HELM_RELEASE="thanos"
INGRESS_PATH="minikube"  # Location of ingress YAML files and values.yaml
VALUES_FILE="$INGRESS_PATH/values.yaml"  # Path to the values.yaml file

# Hostnames for different components
QUERY_HOSTNAME="thanos-query.refactored-space-bassoon-6447q4747g5h56rq.github.dev"
RULER_HOSTNAME="thanos-ruler.refactored-space-bassoon-6447q4747g5h56rq.github.dev"
FRONTEND_HOSTNAME="thanos-frontend.refactored-space-bassoon-6447q4747g5h56rq.github.dev"

# Ports to check
REQUIRED_PORTS=(9090 9091 9095 10901)

# Function to clean up existing resources
cleanup_resources() {
    echo "Cleaning up existing Thanos resources..."

    # Delete existing ingress resources
    kubectl delete -f "$INGRESS_PATH/thanos-query-ingress.yaml" --ignore-not-found
    kubectl delete -f "$INGRESS_PATH/thanos-ruler-ingress.yaml" --ignore-not-found
    kubectl delete -f "$INGRESS_PATH/thanos-frontend-ingress.yaml" --ignore-not-found

    # Delete the Helm release
    helm uninstall "$HELM_RELEASE" -n "$NAMESPACE" --wait

    # Delete the namespace if it exists
    kubectl delete namespace "$NAMESPACE" --ignore-not-found --wait

    echo "Cleanup complete. Environment is ready for a fresh deployment."
}

# Function to check if required ports are in use
check_ports() {
    echo "Checking for port conflicts..."
    for PORT in "${REQUIRED_PORTS[@]}"; do
        if lsof -i :"$PORT" > /dev/null 2>&1; then
            echo "Error: Port $PORT is already in use. Please free it up and try again."
            exit 1
        fi
    done
    echo "All required ports are available."
}

# Ensure Minikube, Kubectl, and Helm are installed
check_dependencies() {
    if ! command -v minikube &> /dev/null; then
        echo "Error: Minikube is not installed. Please install it and try again."
        exit 1
    fi

    if ! command -v kubectl &> /dev/null; then
        echo "Error: Kubectl is not installed. Please install it and try again."
        exit 1
    fi

    if ! command -v helm &> /dev/null; then
        echo "Error: Helm is not installed. Please install it and try again."
        exit 1
    fi
}

# Start Minikube if not running
start_minikube() {
    if ! minikube status &> /dev/null; then
        echo "Starting Minikube..."
        minikube start --driver=docker
        if [ $? -ne 0 ]; then
            echo "Error: Failed to start Minikube."
            exit 1
        fi
    else
        echo "Minikube is already running."
    fi
}

# Enable Minikube Ingress addon
enable_ingress() {
    echo "Enabling Minikube Ingress addon..."
    minikube addons enable ingress
}

# Create the namespace if it doesn't exist
create_namespace() {
    if kubectl get namespace "$NAMESPACE" &> /dev/null; then
        echo "Namespace '$NAMESPACE' already exists."
    else
        echo "Creating namespace '$NAMESPACE'..."
        kubectl create namespace "$NAMESPACE"
        if [ $? -ne 0 ]; then
            echo "Error: Failed to create namespace."
            exit 1
        fi
    fi
}

# Deploy Thanos using Helm
deploy_thanos() {
    echo "Deploying Thanos in namespace '$NAMESPACE'..."
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update

    helm install "$HELM_RELEASE" bitnami/thanos \
        --namespace "$NAMESPACE" \
        -f "$VALUES_FILE" --wait

    if [ $? -ne 0 ]; then
        echo "Error: Failed to deploy Thanos."
        exit 1
    fi
}

# Apply Ingress YAML files from the specified folder
apply_ingress() {
    echo "Applying Ingress resources from $INGRESS_PATH..."
    kubectl apply -f "$INGRESS_PATH/thanos-query-ingress.yaml"
    kubectl apply -f "$INGRESS_PATH/thanos-ruler-ingress.yaml"
    kubectl apply -f "$INGRESS_PATH/thanos-frontend-ingress.yaml"
}

# Update /etc/hosts with unique hostnames
# update_hosts() {
#     echo "Updating /etc/hosts to map hostnames to localhost..."
#     echo "127.0.0.1 $QUERY_HOSTNAME" | sudo tee -a /etc/hosts
#     echo "127.0.0.1 $RULER_HOSTNAME" | sudo tee -a /etc/hosts
#     echo "127.0.0.1 $FRONTEND_HOSTNAME" | sudo tee -a /etc/hosts
# }

# Main Function
main() {
    cleanup_resources
    check_ports
    check_dependencies
    start_minikube
    enable_ingress
    create_namespace
    deploy_thanos
    apply_ingress


    echo "Thanos environment with proxy setup is complete."
    echo "Access Thanos Query at http://$QUERY_HOSTNAME"
    echo "Access Thanos Ruler at http://$RULER_HOSTNAME"
    echo "Access Thanos Frontend at http://$FRONTEND_HOSTNAME"
}

# Run the script
main

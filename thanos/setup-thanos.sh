#!/bin/bash

# Ensure Minikube is installed
if ! command -v minikube &> /dev/null
then
    echo "Minikube could not be found. Please install Minikube first."
    exit
fi

# Start Minikube
echo "Starting Minikube..."
minikube start

# Deploy Thanos
echo "Deploying Thanos..."
kubectl apply -f frontend/frontend-deployment.yaml
kubectl apply -f frontend/frontend-service.yaml
kubectl apply -f receiver/receiver-deployment.yaml
kubectl apply -f receiver/receiver-service.yaml

# Perform health check until pod is ready
echo "Performing health check until Thanos frontend pod is ready..."
while [[ $(kubectl get pods -l app=thanos-frontend -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
    echo "Waiting for pod to be ready..."
    sleep 5
done

# Forward ports
echo "Forwarding ports..."
kubectl port-forward svc/thanos-frontend-service 9091:9091

# Access Thanos
echo "Accessing Thanos service..."
minikube service thanos-frontend-service --url

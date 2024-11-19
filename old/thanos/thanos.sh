#!/bin/bash

# Delete the existing namespace and Helm release if they exist

if helm ls --namespace monitoring-testing-october24 | grep -q 'thanos-release'; then
  helm uninstall thanos-release --namespace monitoring-testing-october24
fi

kubectl delete namespace monitoring-testing-october24 --ignore-not-found

# Kill existing port-forward processes
pkill -f "kubectl port-forward" || true

# Start Minikube if not already running
minikube status || minikube start

# Create a namespace for Thanos if it doesn't exist
kubectl get namespace monitoring-testing-october24 || kubectl create namespace monitoring-testing-october24

# Add the Bitnami repository if not already added
helm repo list | grep -q 'bitnami' || helm repo add bitnami oci://registry-1.docker.io/bitnamicharts

# Update Helm repositories
helm repo update

# Install the Helm release
helm install thanos-release bitnami/thanos --namespace monitoring-testing-october24 --values /workspaces/thanos/thanos/app/values.yaml

# Remove the application of local YAML files
# kubectl apply -f /workspaces/thanos/thanos/app/service.yaml --namespace monitoring-testing-october24
# kubectl apply -f /workspaces/thanos/thanos/app/deployment.yaml --namespace monitoring-testing-october24
# kubectl apply -f /workspaces/thanos/thanos/app/pvc.yaml --namespace monitoring-testing-october24

# Create a symbolic link if it doesn't already exist
# [ -L /etc/nginx/conf.d/thanos.conf ] || sudo ln -s /workspaces/thanos/thanos/app/thanos.conf /etc/nginx/conf.d/thanos.conf

# Restart nginx to apply the new configuration
# sudo systemctl restart nginx

# Check the status of the pods
kubectl get pods -n monitoring-testing-october24

# Check the status of the pods and wait until they are ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=thanos -n monitoring-testing-october24 --timeout=300s

# Wait for services to be created
for svc in thanos-query-frontend thanos-receiver thanos-readwrite; do
  kubectl wait --for=condition=available --timeout=300s svc/$svc -n monitoring-testing-october24 || echo "Service $svc not found"
done

# Forward ports (example: forwarding port 9090 of the Thanos Frontend pod to localhost:9090)
sleep 10
kubectl get svc -n monitoring-testing-october24 thanos-query-frontend && kubectl port-forward -n monitoring-testing-october24 svc/thanos-query-frontend 9090:9090 &
kubectl get svc -n monitoring-testing-october24 thanos-receiver && kubectl port-forward -n monitoring-testing-october24 svc/thanos-receiver 10903:10901 &
kubectl get svc -n monitoring-testing-october24 thanos-readwrite && kubectl port-forward -n monitoring-testing-october24 svc/thanos-readwrite 9091:9091 &

# Check the status of the services
kubectl get service -n monitoring-testing-october24

# ...existing code...
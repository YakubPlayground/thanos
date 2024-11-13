#!/bin/bash

# Start Minikube
minikube start

# Create a namespace for Thanos if it doesn't exist
kubectl get namespace monitoring-testing-october24 || kubectl create namespace monitoring-testing-october24

# Add the Bitnami repository
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update Helm repositories
helm repo update

# Install the Thanos Helm chart
helm install thanos-release bitnami/thanos --namespace monitoring-testing-october24

# Check the status of the pods
kubectl get pods -n monitoring-testing-october24

# Forward ports (example: forwarding port 9090 of the Thanos Query pod to localhost:9090)
kubectl port-forward -n monitoring-testing-october24 svc/thanos-release-query 9090:9090 &
kubectl port-forward -n monitoring-testing-october24 svc/thanos-release-storegateway 10901:10901 &

# Check the status of the services
kubectl get service -n monitoring-testing-october24
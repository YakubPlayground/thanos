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

# Access Thanos
echo "Accessing Thanos service..."
minikube service thanos-frontend-service
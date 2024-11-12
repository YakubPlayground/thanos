#!/bin/bash

# Start Minikube
minikube start

# Create a namespace for Thanos
kubectl create namespace monitoring-testing-october24

# Apply the Thanos app manifests
kubectl apply -f app/ -n monitoring-testing-october24

# Check the status of the pods
kubectl get pods -n monitoring-testing-october24
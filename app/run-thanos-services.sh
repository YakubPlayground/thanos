#!/bin/bash

# Start Minikube
minikube start

# Add the Bitnami Helm repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Create the namespace
kubectl create namespace monitoring-testing-october20

# Deploy Thanos using Helm
helm install thanos-release oci://registry-1.docker.io/bitnamicharts/thanos -f /workspaces/thanos/app/values.yaml --namespace monitoring-testing-october20 --create-namespace

# Forward the ports
kubectl port-forward svc/thanos-frontend  9092:9092 -n monitoring-testing-october20 &
# kubectl port-forward svc/thanos-release-query-frontend 9092:9092 -n monitoring-testing-october20 &
# kubectl port-forward svc/thanos-release-receive 9091:9091 -n monitoring-testing-october20 &
# kubectl port-forward svc/thanos-release-storegateway 9090:9090 -n monitoring-testing-october20 &
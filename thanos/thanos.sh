#!/bin/bash

# Start Minikube if not already running
minikube status || minikube start

# Create a namespace for Thanos if it doesn't exist
kubectl get namespace monitoring-testing-october24 || kubectl create namespace monitoring-testing-october24

# Add the Bitnami repository if not already added
helm repo list | grep -q 'bitnami' || helm repo add bitnami https://charts.bitnami.com/bitnami

# Update Helm repositories
helm repo update

# Install or upgrade the Thanos Helm chart with the external prefix and additional components
helm upgrade --install thanos-release bitnami/thanos --namespace monitoring-testing-october24 \
  --values /workspaces/thanos/thanos/app/values.yaml

# Create a symbolic link if it doesn't already exist
[ -L /etc/nginx/conf.d/thanos.conf ] || sudo ln -s /workspaces/thanos/thanos/app/thanos.conf /etc/nginx/conf.d/thanos.conf

# Restart nginx to apply the new configuration
sudo systemctl restart nginx

# Check the status of the pods
kubectl get pods -n monitoring-testing-october24

# Check the status of the pods and wait until they are ready
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=thanos -n monitoring-testing-october24 --timeout=300s

# Forward ports (example: forwarding port 9090 of the Thanos Query pod to localhost:9090)
kubectl port-forward -n monitoring-testing-october24 svc/thanos-release-query 9090:9090 &
kubectl port-forward -n monitoring-testing-october24 svc/thanos-release-storegateway 10902:10901 &
kubectl port-forward -n monitoring-testing-october24 svc/thanos-release-receiver 10903:10901 &
kubectl port-forward -n monitoring-testing-october24 svc/thanos-release-frontend 9091:9091 &
kubectl port-forward -n monitoring-testing-october24 svc/thanos-release-readwrite 9092:9092 &

# Check the status of the services
kubectl get service -n monitoring-testing-october24
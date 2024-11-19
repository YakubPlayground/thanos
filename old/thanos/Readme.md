# Thanos Deployment with Helm and Minikube 🚀

This repository contains scripts and configurations to deploy Thanos using Helm on a Minikube cluster. The deployment includes various Thanos components and sets up port forwarding for easy access.

## Prerequisites 📋

- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Nginx](https://www.nginx.com/resources/wiki/start/topics/tutorials/install/)

## Deployment Steps 🛠️

1. **Start Minikube**: Ensure Minikube is running.
2. **Create Namespace**: Create a Kubernetes namespace for Thanos.
3. **Add Helm Repository**: Add the Bitnami Helm repository if not already added.
4. **Update Helm Repositories**: Update Helm repositories to get the latest charts.
5. **Install/Upgrade Thanos**: Install or upgrade the Thanos Helm chart with the specified values.
6. **Configure Nginx**: Create a symbolic link for the Nginx configuration and restart Nginx.
7. **Port Forwarding**: Set up port forwarding for Thanos services.

## Usage 🚀

Run the provided shell script to automate the deployment process:

```bash
./thanos.sh
```

This script will:

- Start Minikube if it is not already running.
- Create a namespace for Thanos.
- Add the Bitnami Helm repository if it is not already added.
- Update Helm repositories.
- Install or upgrade the Thanos Helm chart.
- Create a symbolic link for the Nginx configuration and restart Nginx.
- Set up port forwarding for Thanos services.

## Verifying Deployment ✅

After running the script, you can verify the deployment by checking the status of the pods and services:

kubectl get pods -n <namespace-name>
kubectl get service -n <namespace-name>

## Accessing Thanos Components 🔍

The following ports are forwarded to localhost:

- **Thanos Query**: `localhost:9090`
- **Thanos Store Gateway**: `localhost:10902`
- **Thanos Receiver**: `localhost:10903`
- **Thanos Frontend**: `localhost:9091`
- **Thanos ReadWrite**: `localhost:9092`

You can access these components using the forwarded ports on your local machine.

## Cleanup 🧹

To clean up the deployment, you can delete the namespace:

```bash
kubectl delete namespace <namespace-name>
```
# thanos
## Thanos Platform

The Thanos platform uses Bitnami and consists of two main components:

### Frontend

The frontend is responsible for providing the user interface and interacting with the backend services.

### Automation Script

To automate the setup process, you can use the following script. Save it as `setup-thanos.sh` and run it to deploy the Thanos platform on Minikube:

```sh
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
kubectl apply -f thanos/frontend/frontend-deployment.yaml
kubectl apply -f thanos/frontend/frontend-service.yaml
kubectl apply -f thanos/receiver/receiver-deployment.yaml
kubectl apply -f thanos/receiver/receiver-service.yaml

# Access Thanos
echo "Accessing Thanos service..."
minikube service thanos-frontend-service
```

Make the script executable and run it:

```sh
chmod +x setup-thanos.sh
./setup-thanos.sh
```

This script will automate the process of starting Minikube, deploying the Thanos platform, and accessing the Thanos service.

### Kubernetes Configuration

To set up the frontend and receiver environments for the Thanos platform, you need to create Kubernetes configuration files. Below are the necessary files:

#### Frontend Deployment Configuration

Create a file named `frontend-deployment.yaml` with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: thanos-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: thanos-frontend
  template:
    metadata:
      labels:
        app: thanos-frontend
    spec:
      containers:
      - name: thanos-frontend
        image: bitnami/thanos:latest
        ports:
        - containerPort: 80
```

#### Frontend Service Configuration

Create a file named `frontend-service.yaml` with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: thanos-frontend-service
spec:
  selector:
    app: thanos-frontend
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```

#### Receiver Deployment Configuration

Create a file named `receiver-deployment.yaml` with the following content:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: thanos-receiver
spec:
  replicas: 1
  selector:
    matchLabels:
      app: thanos-receiver
  template:
    metadata:
      labels:
        app: thanos-receiver
    spec:
      containers:
      - name: thanos-receiver
        image: bitnami/thanos:latest
        ports:
        - containerPort: 9090
```

#### Receiver Service Configuration

Create a file named `receiver-service.yaml` with the following content:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: thanos-receiver-service
spec:
  selector:
    app: thanos-receiver
  ports:
    - protocol: TCP
      port: 9090
      targetPort: 9090
  type: NodePort
```

#### Applying the Configuration

To deploy the frontend and receiver environments, apply the configuration files using the following commands:

```sh
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml
kubectl apply -f receiver-deployment.yaml
kubectl apply -f receiver-service.yaml
```

This will set up the frontend and receiver components of the Thanos platform on your Kubernetes cluster.

### Receiver

The receiver component handles incoming data and processes it for storage and analysis.
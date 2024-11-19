# Setting Up Prometheus

Prometheus is an open-source systems monitoring and alerting toolkit. Follow these steps to set up Prometheus on a Minikube cluster:

## Prerequisites

- Minikube installed on your system
- kubectl installed and configured

## Steps

1. **Start Minikube**

    Start your Minikube cluster with the following command:

    ```sh
    minikube start
    ```

2. **Create a Namespace**

    Create a namespace for Prometheus:

    ```sh
    kubectl create namespace monitoring
    ```

3. **Deploy Prometheus**

    Create a `prometheus-deployment.yaml` file with the following content:

    ```yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: prometheus
      namespace: monitoring
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: prometheus
      template:
        metadata:
          labels:
            app: prometheus
        spec:
          containers:
          - name: prometheus
            image: prom/prometheus
            ports:
            - containerPort: 9090
            volumeMounts:
            - name: prometheus-config-volume
              mountPath: /etc/prometheus/
          volumes:
          - name: prometheus-config-volume
            configMap:
              name: prometheus-server-conf
    ```

4. **Create a Prometheus ConfigMap**

    Create a `prometheus-configmap.yaml` file with the following content:

    ```yaml
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: prometheus-server-conf
      namespace: monitoring
    data:
      prometheus.yml: |
        global:
          scrape_interval: 15s

        scrape_configs:
          - job_name: 'prometheus'
            static_configs:
              - targets: ['localhost:9090']
    ```

5. **Apply the ConfigMap and Deployment**

    Apply the ConfigMap and Deployment to your Minikube cluster:

    ```sh
    kubectl apply -f prometheus-configmap.yaml
    kubectl apply -f prometheus-deployment.yaml
    ```

6. **Expose Prometheus**

    Expose the Prometheus deployment as a service:

    ```sh
    kubectl expose deployment prometheus --type=NodePort --name=prometheus-service --namespace=monitoring
    ```

7. **Access Prometheus**

    Get the URL to access Prometheus:

    ```sh
    minikube service prometheus-service -n monitoring --url
    ```

    Open the provided URL in your web browser to access the Prometheus web interface.

## Conclusion

You have successfully set up Prometheus using Minikube. You can now start monitoring your systems and applications.

## Using Helm to Deploy Prometheus

Alternatively, you can use Helm to deploy Prometheus on your Minikube cluster. Follow these steps:

1. **Add the Bitnami Helm Repo**

    Add the Bitnami Helm repository:

    ```sh
    helm repo add bitnami https://charts.bitnami.com/bitnami
    helm repo update
    ```

2. **Install Prometheus using Helm**

    Install Prometheus in the `monitoring-testing-october24` namespace (skip the `--create-namespace` flag if the namespace already exists):

    ```sh
    helm install prometheus oci://registry-1.docker.io/bitnamicharts/prometheus --namespace monitoring-testing-october24 --create-namespace
    ```

3. **Forward Prometheus Address**

    Forward the Prometheus service to your local machine:

    ```sh
    kubectl port-forward -n monitoring-testing-october24 deploy/prometheus-server 9090:9090
    ```

    You can now access Prometheus at `http://localhost:9090` in your web browser.

## Conclusion

You have successfully set up Prometheus using Minikube and Helm. You can now start monitoring your systems and applications.

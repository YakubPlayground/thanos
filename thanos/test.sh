INGRESS_PATH="minikube"
MINIKUBE_HOST_IP="127.0.0.1"


ls -l "$INGRESS_PATH"

test -d "$INGRESS_PATH" || {
    echo "Checking the contents of $INGRESS_PATH..."
    
    echo "Error: $INGRESS_PATH does not exist."
    exit 1
}
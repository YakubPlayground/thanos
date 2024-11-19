```mermaid
graph TD
    subgraph Kubernetes Cluster
        subgraph Namespace: Monitoring
            A[Thanos Receiver]
            B[Thanos Frontend]
            C[Rewrite Service]
            D[Prometheus]
        end
    end

    D --> A
    A --> B
    B --> C
```

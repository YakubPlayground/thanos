```markdown
# Thanos Frontend CrashLoopBackOff Issue

## Pod Description

```shell
kubectl describe pod thanos-frontend-65498bb78c-z4twc
```

## Fix

Update the Thanos container command in your Kubernetes deployment to include the correct subcommand and flags. For example, if you want to run the Thanos query frontend, update the deployment as follows:

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
        args:
        - "query-frontend"
        - "--log.level=info"
        ports:
        - containerPort: 80
```

### Output

```
Name:             thanos-frontend-65498bb78c-z4twc
Namespace:        default
Priority:         0
Service Account:  default
Node:             minikube/192.168.49.2
Start Time:       Fri, 08 Nov 2024 16:52:16 +0000
Labels:           app=thanos-frontend
                  pod-template-hash=65498bb78c
Annotations:      <none>
Status:           Running
IP:               10.244.0.7
IPs:
  IP:           10.244.0.7
Controlled By:  ReplicaSet/thanos-frontend-65498bb78c
Containers:
  thanos-frontend:
    Container ID:   docker://9efa86f5167f10bec952a5c23ddd20259892f0a9788e97658be339b864428c29
    Image:          bitnami/thanos:latest
    Image ID:       docker-pullable://bitnami/thanos@sha256:191f297b6ca9d0c66b4fbc25621e0e3d49060bc0898694f8dece8e7aa0adef4d
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Fri, 08 Nov 2024 17:18:09 +0000
      Finished:     Fri, 08 Nov 2024 17:18:10 +0000
    Ready:          False
    Restart Count:  10
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-h5wd9 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       False 
  ContainersReady             False 
  PodScheduled                True 
Volumes:
  kube-api-access-h5wd9:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason     Age                    From               Message
  ----     ------     ----                   ----               -------
  Normal   Scheduled  30m                    default-scheduler  Successfully assigned default/thanos-frontend-65498bb78c-z4twc to minikube
  Normal   Pulled     29m                    kubelet            Successfully pulled image "bitnami/thanos:latest" in 816ms (816ms including waiting). Image size: 79797038 bytes.
  Normal   Pulled     29m                    kubelet            Successfully pulled image "bitnami/thanos:latest" in 821ms (821ms including waiting). Image size: 79797038 bytes.
  Normal   Pulled     29m                    kubelet            Successfully pulled image "bitnami/thanos:latest" in 867ms (867ms including waiting). Image size: 79797038 bytes.
  Normal   Created    29m (x4 over 29m)      kubelet            Created container thanos-frontend
  Normal   Started    29m (x4 over 29m)      kubelet            Started container thanos-frontend
  Normal   Pulled     29m                    kubelet            Successfully pulled image "bitnami/thanos:latest" in 845ms (845ms including waiting). Image size: 79797038 bytes.
  Normal   Pulling    28m (x5 over 29m)      kubelet            Pulling image "bitnami/thanos:latest"
  Normal   Pulled     28m                    kubelet            Successfully pulled image "bitnami/thanos:latest" in 783ms (783ms including waiting). Image size: 79797038 bytes.
  Warning  BackOff    4m50s (x117 over 29m)  kubelet            Back-off restarting failed container thanos-frontend in pod thanos-frontend-65498bb78c-z4twc_default(0b77e2d3-726a-4711-9929-f56c4547c829)
```

## Logs

```shell
kubectl logs pod/thanos-frontend-65498bb78c-z4twc
```

### Output

```
usage: thanos [<flags>] <command> [<args> ...]

A block storage based long-term storage for Prometheus.

Flags:
      --auto-gomemlimit.ratio=0.9  
                                The ratio of reserved GOMEMLIMIT memory to the
                                detected maximum container or system memory.
      --enable-auto-gomemlimit  Enable go runtime to automatically limit memory
                                consumption.
  -h, --help                    Show context-sensitive help (also try
                                --help-long and --help-man).
      --log.format=logfmt       Log format to use. Possible options: logfmt or
                                json.
      --log.level=info          Log filtering level.
      --tracing.config=<content>  
                                Alternative to 'tracing.config-file' flag
                                (mutually exclusive). Content of YAML file
                                with tracing configuration. See format details:
                                https://thanos.io/tip/thanos/tracing.md/#configuration
      --tracing.config-file=<file-path>  
                                Path to YAML file with tracing
                                configuration. See format details:
                                https://thanos.io/tip/thanos/tracing.md/#configuration
      --version                 Show application version.

Commands:
  help [<command>...]
    Show help.

  sidecar [<flags>]
    Sidecar for Prometheus server.

  store [<flags>]
    Store node giving access to blocks in a bucket provider. Now supported GCS,
    S3, Azure, Swift, Tencent COS and Aliyun OSS.

  query [<flags>]
    Query node exposing PromQL enabled Query API with data retrieved from
    multiple store nodes.

  rule [<flags>]
    Ruler evaluating Prometheus rules against given Query nodes, exposing Store
    API and storing old blocks in bucket.

  compact [<flags>]
    Continuously compacts blocks in an object store bucket.

  tools bucket verify [<flags>]
    Verify all blocks in the bucket against specified issues. NOTE: Depending on
    issue this might take time and will need downloading all specified blocks to
    disk.

  tools bucket ls [<flags>]
    List all blocks in the bucket.

  tools bucket inspect [<flags>]
    Inspect all blocks in the bucket in detailed, table-like way.

  tools bucket web [<flags>]
    Web interface for remote storage bucket.

  tools bucket replicate [<flags>]
    Replicate data from one object storage to another. NOTE: Currently it works
    only with Thanos blocks (meta.json has to have Thanos metadata).

  tools bucket downsample [<flags>]
    Continuously downsamples blocks in an object store bucket.

  tools bucket cleanup [<flags>]
    Cleans up all blocks marked for deletion.

  tools bucket mark --id=ID --marker=MARKER [<flags>]
    Mark block for deletion or no-compact in a safe way. NOTE: If the compactor
    is currently running compacting same block, this operation would be
    potentially a noop.

  tools bucket rewrite --id=ID [<flags>]
    Rewrite chosen blocks in the bucket, while deleting or modifying
    series Resulted block has modified stats in meta.json. Additionally
    compaction.sources are altered to not confuse readers of meta.json.
    Instead thanos.rewrite section is added with useful info like old sources
    and deletion requests. NOTE: It's recommended to turn off compactor while
    doing this operation. If the compactor is running and touching exactly same
    block that is being rewritten, the resulted rewritten block might only cause
    overlap (mitigated by marking overlapping block manually for deletion) and
    the data you wanted to rewrite could already part of bigger block.

    Use FILESYSTEM type of bucket to rewrite block on disk (suitable for vanilla
    Prometheus) After rewrite, it's caller responsibility to delete or mark
    source block for deletion to avoid overlaps. WARNING: This procedure is
    *IRREVERSIBLE* after certain time (delete delay), so do backup your blocks
    first.

  tools bucket retention [<flags>]
    Retention applies retention policies on the given bucket. Please make sure
    no compactor is running on the same bucket at the same time.

  tools bucket upload-blocks [<flags>]
    Upload blocks push blocks from the provided path to the object storage.

  tools rules-check --rules=RULES
    Check if the rule files are valid or not.

  receive [<flags>]
    Accept Prometheus remote write API requests and write to local tsdb.

  query-frontend [<flags>]
    Query frontend command implements a service deployed in front of queriers to
    improve query parallelization and caching.
```
```

## Remove Pods and Stop Deployment

To remove the Thanos frontend pods and stop the deployment, you can use the following commands:

```shell
# Scale down the deployment to zero replicas
kubectl scale deployment thanos-frontend --replicas=0

# Delete the Thanos frontend pods
kubectl delete pod -l app=thanos-frontend
```
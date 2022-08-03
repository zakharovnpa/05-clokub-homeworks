## ЛР-2 по Задаче 2 (*): Работа с секретами внутри модуля

### Задача 2 (*): Работа с секретами внутри модуля

#### Задача:
1. На основе образа fedora создать модуль;
2. Создать секрет, в котором будет указан токен;
3. Подключить секрет к модулю;
4. Запустить модуль и проверить доступность сервиса Vault.




### 1. На основе образа fedora создать модуль

* Dockerfile

```
FROM fedora:latest

CMD sleep 3600

```
```
docker build -t zakharovnpa/k8s-fedore:03.08.22 .
```

#### Скрипт для развертывания окружения
```
date && \
mkdir -p My-Project && cd My-Project && \
touch username.txt password.txt secret-fedora-pod.yaml fedora-pod.yaml && \
echo ‘admin’ > username.txt && \
echo ‘password’ > password.txt && \
echo "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: sbb-app
  name: secret-fedora-pod 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sbb-app
  template:
    metadata:
      labels:
        app: sbb-app
    spec:
      containers:
        - image: fedora
          imagePullPolicy: IfNotPresent
          name: one-fedora
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-secret-volume
        - image: fedora
          imagePullPolicy: IfNotPresent
          name: two-fedora
          volumeMounts:
            - mountPath: /tmp/cache
              name: my-secret-volume
      volumes:
        - name: my-secret-volume
          secret:
            secretName: user-cred
            
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: fedora-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30092
  selector:
    app: sbb-pod
" > secret-fedora-pod.yaml && \
echo "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: fedora-pod 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bb-app
  template:
    metadata:
      labels:
        app: bb-app
    spec:
      containers:
        - image: fedore
          imagePullPolicy: IfNotPresent
          name: one-fedora
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-volume
        - image: fedora
          imagePullPolicy: IfNotPresent
          name: two-fedora
          volumeMounts:
            - mountPath: /tmp/cache
              name: my-volume
      volumes:
        - name: my-volume
          emptyDir: {}
          
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: fedora-pod
  labels:
    app: bb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30091
  selector:
    app: bb-pod
" > fedore-pod.yaml
```
```
kubectl create secret generic user-cred --from-file=./username.txt --from-file=./password.txt && \
clear && \
echo "Script working!" && \
sleep 10 && \
kubectl apply -f busybox-pod.yaml && \
sleep 3 && \
kubectl apply -f secret-busybox-pod.yaml && \
sleep 10 && \
kubectl get secrets && \
sleep 3 && \
kubectl get deployment && \
sleep 3 && \
kubectl get svc && \
sleep 3 && \
kubectl get pod
```


### 2. Создать секрет, в котором будет указан токен


### 3. Подключить секрет к модулю



### 4. Запустить модуль и проверить доступность сервиса Vault.

### Лог - 1
* Tab 1
```
> ---
> apiVersion: apps/v1
> kind: Deployment
> metadata:
>   labels:
>     app: sbb-app
>   name: secret-fedore-pod 
> spec:
>   replicas: 1
>   selector:
>     matchLabels:
>       app: sbb-app
>   template:
>     metadata:
>       labels:
>         app: sbb-app
>     spec:
>       containers:
>         - image: fedore
>           imagePullPolicy: IfNotPresent
>           name: one-fedore
>           ports:
>           - containerPort: 80
>           volumeMounts:
>             - mountPath: /static
>               name: my-secret-volume
>         - image: fedore
>           imagePullPolicy: IfNotPresent
>           name: two-fedore
>           volumeMounts:
>             - mountPath: /tmp/cache
>               name: my-secret-volume
>       volumes:
>         - name: my-secret-volume
>           secret:
>             secretName: user-cred
>             
> ---
> # Config Service
> apiVersion: v1
> kind: Service
> metadata:
>   name: fedore-pod
>   labels:
>     app: sbb
> spec:
>   type: NodePort
>   ports:
>   - port: 80
>     nodePort: 30092
>   selector:
>     app: sbb-pod
> " > secret-fedore-pod.yaml && \
> echo "
> ---
> apiVersion: apps/v1
> kind: Deployment
> metadata:
>   labels:
>     app: bb-app
>   name: fedore-pod 
> spec:
>   replicas: 1
>   selector:
>     matchLabels:
>       app: bb-app
>   template:
>     metadata:
>       labels:
>         app: bb-app
>     spec:
>       containers:
>         - image: fedore
>           imagePullPolicy: IfNotPresent
>           name: one-fedore
>           ports:
>           - containerPort: 80
>           volumeMounts:
>             - mountPath: /static
>               name: my-volume
>         - image: fedore
>           imagePullPolicy: IfNotPresent
>           name: two-fedore
>           volumeMounts:
>             - mountPath: /tmp/cache
>               name: my-volume
>       volumes:
>         - name: my-volume
>           emptyDir: {}
>           
> ---
> # Config Service
> apiVersion: v1
> kind: Service
> metadata:
>   name: fedore-pod
>   labels:
>     app: bb
> spec:
>   type: NodePort
>   ports:
>   - port: 80
>     nodePort: 30091
>   selector:
>     app: bb-pod
> " > fedore-pod.yaml
Wed Aug  3 17:01:58 UTC 2022
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ ls -l
total 16
-rw-r--r-- 1 root root 929 Aug  3 17:01 fedore-pod.yaml
-rw-r--r-- 1 root root  15 Aug  3 17:01 password.txt
-rw-r--r-- 1 root root 993 Aug  3 17:01 secret-fedore-pod.yaml
-rw-r--r-- 1 root root  12 Aug  3 17:01 username.txt
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/fedore-pod created
service/fedore-pod created
controlplane $ 
controlplane $ kubectl get po
NAME                          READY   STATUS         RESTARTS   AGE
fedore-pod-686bcb7696-kvjnv   0/2     ErrImagePull   0          17s
controlplane $ 
controlplane $ kubectl get po
NAME                          READY   STATUS         RESTARTS   AGE
fedore-pod-686bcb7696-kvjnv   0/2     ErrImagePull   0          43s
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                          READY   STATUS         RESTARTS   AGE
fedore-pod-686bcb7696-kvjnv   0/2     ErrImagePull   0          51s
controlplane $ 
controlplane $ kubectl describe pod fedore-pod-686bcb7696-kvjnv
Name:         fedore-pod-686bcb7696-kvjnv
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Wed, 03 Aug 2022 17:02:29 +0000
Labels:       app=bb-app
              pod-template-hash=686bcb7696
Annotations:  cni.projectcalico.org/containerID: 114c9495ac33781770008d149ecdc452ae0fdd70ca0fd72427a5c7cdfd18221e
              cni.projectcalico.org/podIP: 192.168.1.4/32
              cni.projectcalico.org/podIPs: 192.168.1.4/32
Status:       Pending
IP:           192.168.1.4
IPs:
  IP:           192.168.1.4
Controlled By:  ReplicaSet/fedore-pod-686bcb7696
Containers:
  one-fedore:
    Container ID:   
    Image:          fedore
    Image ID:       
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /static from my-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qmn6n (ro)
  two-fedore:
    Container ID:   
    Image:          fedore
    Image ID:       
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       ImagePullBackOff
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /tmp/cache from my-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-qmn6n (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  my-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kube-api-access-qmn6n:
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
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  67s                default-scheduler  Successfully assigned default/fedore-pod-686bcb7696-kvjnv to node01
  Warning  Failed     30s (x2 over 62s)  kubelet            Error: ImagePullBackOff
  Normal   BackOff    30s (x2 over 62s)  kubelet            Back-off pulling image "fedore"
  Normal   Pulling    15s (x3 over 66s)  kubelet            Pulling image "fedore"
  Warning  Failed     12s (x3 over 63s)  kubelet            Failed to pull image "fedore": rpc error: code = Unknown desc = failed to pull and unpack image "docker.io/library/fedore:latest": failed to resolve reference "docker.io/library/fedore:latest": pull access denied, repository does not exist or may require authorization: server message: insufficient_scope: authorization failed
  Warning  Failed     12s (x3 over 63s)  kubelet            Error: ErrImagePull
  Normal   BackOff    12s (x5 over 63s)  kubelet            Back-off pulling image "fedore"
  Warning  Failed     12s (x5 over 63s)  kubelet            Error: ImagePullBackOff
controlplane $ 
controlplane $ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
controlplane $ 
controlplane $ 
controlplane $ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
controlplane $ 
controlplane $ docker -h
Flag shorthand -h has been deprecated, please use --help

Usage:  docker [OPTIONS] COMMAND

A self-sufficient runtime for containers

Options:
      --config string      Location of client config files (default "/root/.docker")
  -c, --context string     Name of the context to use to connect to the daemon (overrides DOCKER_HOST env var and default context set with "docker context use")
  -D, --debug              Enable debug mode
  -H, --host list          Daemon socket(s) to connect to
  -l, --log-level string   Set the logging level ("debug"|"info"|"warn"|"error"|"fatal") (default "info")
      --tls                Use TLS; implied by --tlsverify
      --tlscacert string   Trust certs signed only by this CA (default "/root/.docker/ca.pem")
      --tlscert string     Path to TLS certificate file (default "/root/.docker/cert.pem")
      --tlskey string      Path to TLS key file (default "/root/.docker/key.pem")
      --tlsverify          Use TLS and verify the remote
  -v, --version            Print version information and quit

Management Commands:
  builder     Manage builds
  config      Manage Docker configs
  container   Manage containers
  context     Manage contexts
  image       Manage images
  manifest    Manage Docker image manifests and manifest lists
  network     Manage networks
  node        Manage Swarm nodes
  plugin      Manage plugins
  secret      Manage Docker secrets
  service     Manage services
  stack       Manage Docker stacks
  swarm       Manage Swarm
  system      Manage Docker
  trust       Manage trust on Docker images
  volume      Manage volumes

Commands:
  attach      Attach local standard input, output, and error streams to a running container
  build       Build an image from a Dockerfile
  commit      Create a new image from a container's changes
  cp          Copy files/folders between a container and the local filesystem
  create      Create a new container
  diff        Inspect changes to files or directories on a container's filesystem
  events      Get real time events from the server
  exec        Run a command in a running container
  export      Export a container's filesystem as a tar archive
  history     Show the history of an image
  images      List images
  import      Import the contents from a tarball to create a filesystem image
  info        Display system-wide information
  inspect     Return low-level information on Docker objects
  kill        Kill one or more running containers
  load        Load an image from a tar archive or STDIN
  login       Log in to a Docker registry
  logout      Log out from a Docker registry
  logs        Fetch the logs of a container
  pause       Pause all processes within one or more containers
  port        List port mappings or a specific mapping for the container
  ps          List containers
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rename      Rename a container
  restart     Restart one or more containers
  rm          Remove one or more containers
  rmi         Remove one or more images
  run         Run a command in a new container
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  search      Search the Docker Hub for images
  start       Start one or more stopped containers
  stats       Display a live stream of container(s) resource usage statistics
  stop        Stop one or more running containers
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE
  top         Display the running processes of a container
  unpause     Unpause all processes within one or more containers
  update      Update configuration of one or more containers
  version     Show the Docker version information
  wait        Block until one or more containers stop, then print their exit codes

Run 'docker COMMAND --help' for more information on a command.

To get more help with docker, check out our guides at https://docs.docker.com/go/guides/
controlplane $ 
controlplane $ 
controlplane $ docker search fedore
NAME                                          DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
fedorenchik/vimrc-homerc                                                                      0                    
fedorenkolanguagelab/backend                                                                  0                    
fedorenko/get-started                                                                         0                    
fedorenko78ostap/keras606b5cdec847b                                                           0                    
fedorenkolanguagelab/evlabwebapps-sentspace                                                   0                    
fedorenkolanguagelab/evlabwebapps-mdatlas                                                     0                    
fedorenkolanguagelab/evlabwebapps-langatlas                                                   0                    
fedoreva/jiratomkdocs                         Archive Jira project to markdown/HTML via Mk…   0                    
suarora/fedore_suarora                                                                        0                    
manish2190/fedore_custom_image                                                                0                    
ppsec/fedorento2                                                                              0                    
fedorenkolanguagelab/evlab-web-apps-admin                                                     0                    
fedorenkolanguagelab/langatlas                                                                0                    
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
controlplane $ 
controlplane $ docker image list
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
controlplane $ 
controlplane $ docker run -d fedore sleep 3600
Unable to find image 'fedore:latest' locally
docker: Error response from daemon: pull access denied for fedore, repository does not exist or may require 'docker login': denied: requested access to the resource is denied.
See 'docker run --help'.
controlplane $ 
controlplane $ ls
fedore-pod.yaml  password.txt  secret-fedore-pod.yaml  username.txt
controlplane $ 
controlplane $ vi Dockerfile
controlplane $ 
controlplane $ docker build .  
Sending build context to Docker daemon  7.168kB
Step 1/1 : FROM fedore
pull access denied for fedore, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ docker build -t zakharovnpa/k8s-fedore:03.08.22 ..
unable to prepare context: unable to evaluate symlinks in Dockerfile path: lstat /root/Dockerfile: no such file or directory
controlplane $ 
controlplane $ docker build -t zakharovnpa/k8s-fedore:03.08.22 . 
Sending build context to Docker daemon  7.168kB
Step 1/1 : FROM fedore
pull access denied for fedore, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
controlplane $ 
controlplane $ 
controlplane $ docker build -t zakharovnpa/k8s-fedore:03.08.22 .
Sending build context to Docker daemon  7.168kB
Step 1/1 : FROM fedore:latest
pull access denied for fedore, repository does not exist or may require 'docker login': denied: requested access to the resource is denied
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/fedore-pod unchanged
service/fedore-pod unchanged
controlplane $ 
controlplane $ kubectl get po
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (13m ago)   13m
fedore-pod-686bcb7696-kvjnv   0/2     ImagePullBackOff   0             19m
controlplane $ 
controlplane $ 
controlplane $ date && mkdir -p My-Project && cd My-Project && touch username.txt password.txt secret-fedore-pod.yaml fedore-pod.yaml && echo ‘admin’ > username.txt && echo ‘password’ > password.txt && echo "
---            ls -l
controlplane $      
controlplane $ 
controlplane $ ls
Dockerfile  fedore-pod.yaml  password.txt  secret-fedore-pod.yaml  username.txt
controlplane $ 
controlplane $ vi fedore-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/fedora-pod created
The Service "fedora-pod" is invalid: spec.ports[0].nodePort: Invalid value: 30091: provided port is already allocated
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (17m ago)   18m
fedora-pod-799db4f968-2wmzm   0/2     CrashLoopBackOff   2 (7s ago)    12s
fedore-pod-686bcb7696-kvjnv   0/2     ImagePullBackOff   0             23m
controlplane $ 
controlplane $ kubectl delete -f fedore-pod.yaml 
deployment.apps "fedora-pod" deleted
Error from server (NotFound): error when deleting "fedore-pod.yaml": services "fedora-pod" not found
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (18m ago)   18m
fedora-pod-799db4f968-2wmzm   0/2     Terminating        4 (18s ago)   39s
fedore-pod-686bcb7696-kvjnv   0/2     ImagePullBackOff   0             24m
controlplane $ 
controlplane $ kubectl delete fedore-pod-686bcb7696-kvjnv
error: the server doesn't have a resource type "fedore-pod-686bcb7696-kvjnv"
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (18m ago)   19m
fedore-pod-686bcb7696-kvjnv   0/2     ImagePullBackOff   0             24m
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (20m ago)   20m
fedore-pod-686bcb7696-kvjnv   0/2     ImagePullBackOff   0             26m
controlplane $ 
controlplane $ kubectl get deployments.apps 
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
fedore-pod   0/1     1            0           26m
controlplane $ 
controlplane $ kubectl delete deployments.apps fedore-pod 
deployment.apps "fedore-pod" deleted
controlplane $ 
controlplane $ kubectl get pod
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (20m ago)   21m
controlplane $ 
controlplane $ 
controlplane $ kubectl get deployments.apps 
No resources found in default namespace.
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/fedora-pod created
The Service "fedora-pod" is invalid: spec.ports[0].nodePort: Invalid value: 30091: provided port is already allocated
controlplane $ 
controlplane $ 
controlplane $ kubectl get svc
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
fedore-pod   NodePort    10.106.91.120   <none>        80:30091/TCP   27m
kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP        86d
controlplane $ 
controlplane $ kubectl delete svc fedore-pod 
service "fedore-pod" deleted
controlplane $ 
controlplane $ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   86d
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (21m ago)   22m
fedora-pod-799db4f968-dg95m   0/2     CrashLoopBackOff   4 (28s ago)   45s
controlplane $ 
controlplane $ kubectl get deployments.apps 
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
fedora-pod   0/1     1            0           53s
controlplane $ 
controlplane $ kubectl get deployments.apps 
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
fedora-pod   0/1     1            0           60s
controlplane $ 
controlplane $ 
controlplane $ kubectl delete deployments.apps fedore-pod 
Error from server (NotFound): deployments.apps "fedore-pod" not found
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (22m ago)   22m
fedora-pod-799db4f968-dg95m   0/2     CrashLoopBackOff   6 (27s ago)   72s
controlplane $ 
controlplane $ kubectl get deployments.apps 
NAME         READY   UP-TO-DATE   AVAILABLE   AGE
fedora-pod   0/1     1            0           81s
controlplane $ 
controlplane $ kubectl delete deployments.apps fedora-pod 
deployment.apps "fedora-pod" deleted
controlplane $ 
controlplane $ kubectl get deployments.apps 
No resources found in default namespace.
controlplane $ 
controlplane $ kubectl get pod
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (22m ago)   23m
controlplane $ 
controlplane $ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   86d
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/fedora-pod created
service/fedora-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (23m ago)   23m
fedora-pod-799db4f968-gmg9b   0/2     CrashLoopBackOff   2 (5s ago)    6s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (23m ago)   23m
fedora-pod-799db4f968-gmg9b   0/2     CrashLoopBackOff   4 (5s ago)    20s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (23m ago)   23m
fedora-pod-799db4f968-gmg9b   0/2     CrashLoopBackOff   4 (19s ago)   34s
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS      RESTARTS      AGE
fedora                        1/1     Running     1 (23m ago)   24m
fedora-pod-799db4f968-gmg9b   0/2     Completed   6 (31s ago)   46s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (23m ago)   24m
fedora-pod-799db4f968-gmg9b   0/2     CrashLoopBackOff   6 (7s ago)    52s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (24m ago)   24m
fedora-pod-799db4f968-gmg9b   0/2     CrashLoopBackOff   6 (14s ago)   59s
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (24m ago)   24m
fedora-pod-799db4f968-gmg9b   0/2     CrashLoopBackOff   6 (22s ago)   67s
controlplane $ 
controlplane $ kubectl describe pod fedora-pod-799db4f968-gmg9b 
Name:         fedora-pod-799db4f968-gmg9b
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Wed, 03 Aug 2022 17:31:22 +0000
Labels:       app=bb-app
              pod-template-hash=799db4f968
Annotations:  cni.projectcalico.org/containerID: 26cc2f6c130881fa5c642850b1825f553def700e30e78652899eba6c201891a0
              cni.projectcalico.org/podIP: 192.168.1.7/32
              cni.projectcalico.org/podIPs: 192.168.1.7/32
Status:       Running
IP:           192.168.1.7
IPs:
  IP:           192.168.1.7
Controlled By:  ReplicaSet/fedora-pod-799db4f968
Containers:
  one-fedora:
    Container ID:   containerd://eaf39a10068cd3d17aaf70caebdc1e5eaa1efcf1d8a1222ce974363dbe4df32d
    Image:          fedora
    Image ID:       docker.io/library/fedora@sha256:cbf627299e327f564233aac6b97030f9023ca41d3453c497be2f5e8f7762d185
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Wed, 03 Aug 2022 17:32:07 +0000
      Finished:     Wed, 03 Aug 2022 17:32:07 +0000
    Ready:          False
    Restart Count:  3
    Environment:    <none>
    Mounts:
      /static from my-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-tr26s (ro)
  two-fedora:
    Container ID:   containerd://492c134bd06ff5d5a63b026df167c5608647433d0fc161515ed209c811576aad
    Image:          fedora
    Image ID:       docker.io/library/fedora@sha256:cbf627299e327f564233aac6b97030f9023ca41d3453c497be2f5e8f7762d185
    Port:           <none>
    Host Port:      <none>
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Wed, 03 Aug 2022 17:32:07 +0000
      Finished:     Wed, 03 Aug 2022 17:32:07 +0000
    Ready:          False
    Restart Count:  3
    Environment:    <none>
    Mounts:
      /tmp/cache from my-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-tr26s (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  my-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kube-api-access-tr26s:
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
  Type     Reason     Age                From               Message
  ----     ------     ----               ----               -------
  Normal   Scheduled  82s                default-scheduler  Successfully assigned default/fedora-pod-799db4f968-gmg9b to node01
  Normal   Pulled     67s (x3 over 81s)  kubelet            Container image "fedora" already present on machine
  Normal   Created    67s (x3 over 81s)  kubelet            Created container one-fedora
  Normal   Started    67s (x3 over 81s)  kubelet            Started container one-fedora
  Normal   Pulled     67s (x3 over 81s)  kubelet            Container image "fedora" already present on machine
  Normal   Created    67s (x3 over 81s)  kubelet            Created container two-fedora
  Normal   Started    67s (x3 over 81s)  kubelet            Started container two-fedora
  Warning  BackOff    66s (x3 over 80s)  kubelet            Back-off restarting failed container
  Warning  BackOff    65s (x4 over 80s)  kubelet            Back-off restarting failed container
controlplane $ 
controlplane $ 
controlplane $ kubectl logs fedora-pod-799db4f968-gmg9b 
Defaulted container "one-fedora" out of: one-fedora, two-fedora
controlplane $ 
controlplane $ kubectl logs fedora-pod-799db4f968-gmg9b -c one
error: container one is not valid for pod fedora-pod-799db4f968-gmg9b
controlplane $ 
controlplane $ kubectl logs fedora-pod-799db4f968-gmg9b       
Defaulted container "one-fedora" out of: one-fedora, two-fedora
controlplane $ 
controlplane $ kubectl logs fedora-pod-799db4f968-gmg9b one-fedora 
controlplane $ 
controlplane $ kubectl logs fedora-pod-799db4f968-gmg9b two-fedora 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS       AGE
fedora                        1/1     Running            1 (26m ago)    26m
fedora-pod-799db4f968-gmg9b   0/2     CrashLoopBackOff   10 (18s ago)   3m17s
controlplane $ 
controlplane $ 
controlplane $ vo fedore-pod.yaml 
vo: command not found
controlplane $ 
controlplane $ vi fedore-pod.yaml 
controlplane $ 
controlplane $ kubectl delete deployments.apps fedora-pod 
deployment.apps "fedora-pod" deleted
controlplane $ 
controlplane $ kubectl get pod
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (28m ago)   28m
controlplane $ 
controlplane $ 
controlplane $ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
fedora-pod   NodePort    10.101.202.101   <none>        80:30091/TCP   5m23s
kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP        86d
controlplane $ 
controlplane $ kubectl delete svc fedora-pod              
service "fedora-pod" deleted
controlplane $ 
controlplane $ 
controlplane $ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   86d
controlplane $ 
controlplane $ kubectl get pod
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (28m ago)   28m
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/fedora-pod created
service/fedora-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS      RESTARTS      AGE
fedora                        1/1     Running     1 (29m ago)   29m
fedora-pod-799db4f968-x9jv8   0/2     Completed   2 (2s ago)    3s
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (29m ago)   29m
fedora-pod-799db4f968-x9jv8   0/2     CrashLoopBackOff   2 (4s ago)    6s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (29m ago)   29m
fedora-pod-799db4f968-x9jv8   0/2     CrashLoopBackOff   2 (6s ago)    8s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (29m ago)   29m
fedora-pod-799db4f968-x9jv8   0/2     CrashLoopBackOff   2 (7s ago)    9s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                          READY   STATUS             RESTARTS      AGE
fedora                        1/1     Running            1 (29m ago)   29m
fedora-pod-799db4f968-x9jv8   0/2     CrashLoopBackOff   2 (9s ago)    11s
controlplane $ 
controlplane $ 
controlplane $ vi fedore-pod.yaml 
controlplane $ 
controlplane $ 
controlplane $ docker build -t zakharovnpa/k8s-fedore:03.08.22-2 .
Sending build context to Docker daemon  8.192kB
Step 1/2 : FROM fedora:latest
 ---> 98ffdbffd207
Step 2/2 : CMD sleep 3600
 ---> Running in 4d957eb32f78
Removing intermediate container 4d957eb32f78
 ---> a79683367dd1
Successfully built a79683367dd1
Successfully tagged zakharovnpa/k8s-fedore:03.08.22-2
controlplane $ 
controlplane $ 
controlplane $ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
controlplane $ 
controlplane $ docker ps -a
CONTAINER ID   IMAGE           COMMAND       CREATED              STATUS                          PORTS     NAMES
f422c47da357   fedora:latest   "/bin/bash"   About a minute ago   Exited (0) About a minute ago             lucid_sutherland
controlplane $ 
controlplane $ docker stop f422c47da357
f422c47da357
controlplane $ 
controlplane $ docker rm f422c47da357
f422c47da357
controlplane $ 
controlplane $ docker image list
REPOSITORY               TAG          IMAGE ID       CREATED          SIZE
zakharovnpa/k8s-fedore   03.08.22-2   a79683367dd1   55 seconds ago   163MB
fedora                   latest       98ffdbffd207   2 months ago     163MB
controlplane $ 
controlplane $ 
controlplane $ docker run -d zakharovnpa/k8s-fedore:03.08.22-2 
0edf5aa915a2c902b5f22899d27c14a416de16f621583d754a1393eafec97b9f
controlplane $ 
controlplane $ 
controlplane $ docker image ps  

Usage:  docker image COMMAND

Manage images

Commands:
  build       Build an image from a Dockerfile
  history     Show the history of an image
  import      Import the contents from a tarball to create a filesystem image
  inspect     Display detailed information on one or more images
  load        Load an image from a tar archive or STDIN
  ls          List images
  prune       Remove unused images
  pull        Pull an image or a repository from a registry
  push        Push an image or a repository to a registry
  rm          Remove one or more images
  save        Save one or more images to a tar archive (streamed to STDOUT by default)
  tag         Create a tag TARGET_IMAGE that refers to SOURCE_IMAGE

Run 'docker image COMMAND --help' for more information on a command.
controlplane $ 
controlplane $ docker ps
CONTAINER ID   IMAGE                               COMMAND                  CREATED          STATUS          PORTS     NAMES
0edf5aa915a2   zakharovnpa/k8s-fedore:03.08.22-2   "/bin/sh -c 'sleep 3…"   16 seconds ago   Up 11 seconds             xenodochial_euclid
controlplane $ 
controlplane $ 
controlplane $ cat Dockerfile 
FROM fedora:latest

CMD sleep 3600

controlplane $ 
controlplane $ 
controlplane $ vim pod.yaml   
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
deployment.apps/one-fedora-pod configured
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (44m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               9s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m13s ago)   7m55s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               16s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m20s ago)   8m2s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ImagePullBackOff   0               18s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m22s ago)   8m4s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ImagePullBackOff   0               19s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m23s ago)   8m5s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ImagePullBackOff   0               29s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m33s ago)   8m15s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ImagePullBackOff   0               32s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m36s ago)   8m18s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               34s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m38s ago)   8m20s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               36s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m40s ago)   8m22s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               37s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m41s ago)   8m23s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               38s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m42s ago)   8m24s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               39s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m43s ago)   8m25s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               40s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m44s ago)   8m26s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               41s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m45s ago)   8m27s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               43s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m47s ago)   8m29s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS             RESTARTS        AGE
fedora                            1/1     Running            1 (45m ago)     45m
one-fedora-pod-5fc5bf7fd6-5ps7p   0/1     ErrImagePull       0               44s
one-fedora-pod-687d46485-lf4qx    0/1     CrashLoopBackOff   6 (2m48s ago)   8m30s
controlplane $ 
controlplane $ kubectl delete deployments.apps one-fedora-pod 
deployment.apps "one-fedora-pod" deleted
controlplane $ 
controlplane $ kubectl get pod                          
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (48m ago)   48m
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
deployment.apps/one-fedora-pod created
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS              RESTARTS      AGE
fedora                            1/1     Running             1 (48m ago)   48m
one-fedora-pod-5fc5bf7fd6-6mj6q   0/1     ContainerCreating   0             3s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS         RESTARTS      AGE
fedora                            1/1     Running        1 (48m ago)   48m
one-fedora-pod-5fc5bf7fd6-6mj6q   0/1     ErrImagePull   0             7s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS         RESTARTS      AGE
fedora                            1/1     Running        1 (48m ago)   48m
one-fedora-pod-5fc5bf7fd6-6mj6q   0/1     ErrImagePull   0             9s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS         RESTARTS      AGE
fedora                            1/1     Running        1 (48m ago)   48m
one-fedora-pod-5fc5bf7fd6-6mj6q   0/1     ErrImagePull   0             12s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS         RESTARTS      AGE
fedora                            1/1     Running        1 (48m ago)   48m
one-fedora-pod-5fc5bf7fd6-6mj6q   0/1     ErrImagePull   0             14s
controlplane $ 
controlplane $ vim pod.yaml 
controlplane $ 
controlplane $ kubectl delete po one-fedora-pod-5fc5bf7fd6-6mj6q 
pod "one-fedora-pod-5fc5bf7fd6-6mj6q" deleted
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS         RESTARTS      AGE
fedora                            1/1     Running        1 (49m ago)   49m
one-fedora-pod-5fc5bf7fd6-vfdwv   0/1     ErrImagePull   0             3s
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS         RESTARTS      AGE
fedora                            1/1     Running        1 (49m ago)   49m
one-fedora-pod-5fc5bf7fd6-vfdwv   0/1     ErrImagePull   0             7s
controlplane $ 
controlplane $ kubectl delete deployments.apps one-fedora-pod 
deployment.apps "one-fedora-pod" deleted
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (49m ago)   49m
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
deployment.apps/one-fedora-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                             READY   STATUS              RESTARTS      AGE
fedora                           1/1     Running             1 (49m ago)   49m
one-fedora-pod-76547fdf4-npq6c   0/1     ContainerCreating   0             2s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                             READY   STATUS         RESTARTS      AGE
fedora                           1/1     Running        1 (49m ago)   50m
one-fedora-pod-76547fdf4-npq6c   0/1     ErrImagePull   0             5s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                             READY   STATUS         RESTARTS      AGE
fedora                           1/1     Running        1 (49m ago)   50m
one-fedora-pod-76547fdf4-npq6c   0/1     ErrImagePull   0             7s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                             READY   STATUS         RESTARTS      AGE
fedora                           1/1     Running        1 (49m ago)   50m
one-fedora-pod-76547fdf4-npq6c   0/1     ErrImagePull   0             8s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                             READY   STATUS         RESTARTS      AGE
fedora                           1/1     Running        1 (49m ago)   50m
one-fedora-pod-76547fdf4-npq6c   0/1     ErrImagePull   0             10s
controlplane $ 
controlplane $ kubectl get pod
NAME                             READY   STATUS         RESTARTS      AGE
fedora                           1/1     Running        1 (49m ago)   50m
one-fedora-pod-76547fdf4-npq6c   0/1     ErrImagePull   0             13s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                             READY   STATUS         RESTARTS      AGE
fedora                           1/1     Running        1 (50m ago)   50m
one-fedora-pod-76547fdf4-npq6c   0/1     ErrImagePull   0             14s
controlplane $ 
controlplane $ 
controlplane $ vim pod.yaml 
controlplane $ 
controlplane $ kubectl delete deployments.apps one-fedora-pod 
deployment.apps "one-fedora-pod" deleted
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (50m ago)   50m
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
deployment.apps/one-fedora-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS              RESTARTS      AGE
fedora                            1/1     Running             1 (50m ago)   50m
one-fedora-pod-6875f5879c-nxbk8   0/1     ContainerCreating   0             3s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS    RESTARTS      AGE
fedora                            1/1     Running   1 (50m ago)   51m
one-fedora-pod-6875f5879c-nxbk8   1/1     Running   0             5s
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ cat pod.yaml 

---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: one-fedora-pod 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bb-app
  template:
    metadata:
      labels:
        app: bb-app
    spec:
      containers:
        - image: zakharovnpa/k8s-fedora:03.08.22
          imagePullPolicy: IfNotPresent
          name: one-fedora
controlplane $ 
controlplane $ vim fedore-pod.yaml 
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/fedora-pod created
service/fedora-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS    RESTARTS      AGE
fedora                            1/1     Running   1 (51m ago)   52m
fedora-pod-75b6f4c74d-bh8lg       2/2     Running   0             5s
one-fedora-pod-6875f5879c-nxbk8   1/1     Running   0             70s
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod
NAME                              READY   STATUS    RESTARTS      AGE
fedora                            1/1     Running   1 (51m ago)   52m
fedora-pod-75b6f4c74d-bh8lg       2/2     Running   0             9s
one-fedora-pod-6875f5879c-nxbk8   1/1     Running   0             74s
controlplane $ 
controlplane $ 
controlplane $ 
```

* Tab 2
```
controlplane $ kubectl run -i --tty fedora --image=fedora -- bash
If you don't see a command prompt, try pressing enter.
[root@fedora /]# 
[root@fedora /]# 
[root@fedora /]# exit
exit
Session ended, resume using 'kubectl attach fedora -c fedora -i -t' command when the pod is running
controlplane $ 
controlplane $ docker pull fedora
Using default tag: latest
latest: Pulling from library/fedora
e1deda52ffad: Pull complete 
Digest: sha256:cbf627299e327f564233aac6b97030f9023ca41d3453c497be2f5e8f7762d185
Status: Downloaded newer image for fedora:latest
docker.io/library/fedora:latest
controlplane $ 
controlplane $ ls
My-Project  filesystem
controlplane $ 
controlplane $ cd My-Project/
controlplane $ 
controlplane $ ls
Dockerfile  fedore-pod.yaml  password.txt  secret-fedore-pod.yaml  username.txt
controlplane $ 
controlplane $ 
controlplane $ docker image list
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
fedora       latest    98ffdbffd207   2 months ago   163MB
controlplane $ 
controlplane $ vim Dockerfile 
controlplane $ 
controlplane $ vim Dockerfile 
controlplane $ 
controlplane $ kubectl run -i --tty fedora --image=fedora -- bash
Error from server (AlreadyExists): pods "fedora" already exists
controlplane $ 
controlplane $ kubectl exec fedora -it bash -- pwd
/
controlplane $ 
controlplane $ kubectl exec fedora -it bash       
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
[root@fedora /]# 
[root@fedora /]# exit
exit
controlplane $ 
controlplane $ kubectl exec fedora -it bash --
error: you must specify at least one command for the container
controlplane $ 
controlplane $ kubectl exec fedora -it bash -- date
Wed Aug  3 17:40:44 UTC 2022
controlplane $ 
controlplane $ kubectl exec fedora -it bash -- ip a
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "002ebc290a4a1fc626d53a144f3c6d8dd34027a410e5e1b4d69cd70ddb1aa839": OCI runtime exec failed: exec failed: unable to start container process: exec: "ip": executable file not found in $PATH: unknown
controlplane $ 
controlplane $ kubectl exec fedora -it bash -- exit
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "d34c7648763bfd0f64c5003dc8ae5028101bc7681fab72b4c128d3f85ba41158": OCI runtime exec failed: exec failed: unable to start container process: exec: "exit": executable file not found in $PATH: unknown
controlplane $ 
controlplane $ kubectl exec fedora -it bash        
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
[root@fedora /]# 
[root@fedora /]# 
[root@fedora /]# 
[root@fedora /]# env
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
HOSTNAME=fedora
DISTTAG=f36container
PWD=/
FBR=f36
HOME=/root
LANG=C.UTF-8
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:
FGC=f36
FEDORE_POD_SERVICE_PORT=80
FEDORE_POD_PORT_80_TCP_PORT=80
FEDORE_POD_PORT=tcp://10.106.91.120:80
TERM=xterm
SHLVL=1
KUBERNETES_PORT_443_TCP_PROTO=tcp
FEDORE_POD_PORT_80_TCP=tcp://10.106.91.120:80
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
FEDORE_POD_PORT_80_TCP_PROTO=tcp
FEDORE_POD_PORT_80_TCP_ADDR=10.106.91.120
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
FEDORE_POD_SERVICE_HOST=10.106.91.120
_=/usr/bin/env
[root@fedora /]# 
[root@fedora /]# 
[root@fedora /]# exit
exit
controlplane $ 
controlplane $ cp fedore-pod.yaml pod.yaml
controlplane $ 
controlplane $ vim pod.yaml 
controlplane $ 
controlplane $ vim pod.yaml 
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                          READY   STATUS             RESTARTS       AGE
fedora                        1/1     Running            1 (36m ago)    36m
fedora-pod-799db4f968-x9jv8   0/2     CrashLoopBackOff   12 (68s ago)   7m5s
controlplane $ 
controlplane $ kubectl delete deployments.apps fedora-pod 
deployment.apps "fedora-pod" deleted
controlplane $ 
controlplane $ kubectl delete svc fedora-pod 
service "fedora-pod" deleted
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME     READY   STATUS    RESTARTS      AGE
fedora   1/1     Running   1 (36m ago)   37m
controlplane $ 
controlplane $ kubectl get svc
NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   86d
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
deployment.apps/one-fedora-pod created
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS             RESTARTS      AGE
fedora                           1/1     Running            1 (37m ago)   37m
one-fedora-pod-687d46485-lf4qx   0/1     CrashLoopBackOff   1 (3s ago)    5s
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS      RESTARTS      AGE
fedora                           1/1     Running     1 (37m ago)   37m
one-fedora-pod-687d46485-lf4qx   0/1     Completed   2 (20s ago)   22s
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS             RESTARTS      AGE
fedora                           1/1     Running            1 (37m ago)   37m
one-fedora-pod-687d46485-lf4qx   0/1     CrashLoopBackOff   2 (14s ago)   30s
controlplane $ 
controlplane $ 
controlplane $ ls
Dockerfile  fedore-pod.yaml  password.txt  pod.yaml  secret-fedore-pod.yaml  username.txt
controlplane $ 
controlplane $ docker image list
REPOSITORY   TAG       IMAGE ID       CREATED        SIZE
fedora       latest    98ffdbffd207   2 months ago   163MB
controlplane $ 
controlplane $ docker run -d fedora:latest 
f422c47da357cad3e6a6216f2ec1520573782583170189ec9b71ce6b540eebd5
controlplane $ 
controlplane $ dsocker ps

Command 'dsocker' not found, did you mean:

  command 'docker' from deb docker.io (20.10.12-0ubuntu2~20.04.1)

Try: apt install <deb name>

controlplane $ 
controlplane $ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
controlplane $ 
controlplane $ docker ps -a
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS                      PORTS     NAMES
f422c47da357   fedora:latest   "/bin/bash"   15 seconds ago   Exited (0) 14 seconds ago             lucid_sutherland
controlplane $ 
controlplane $ vim Dockerfile 
controlplane $ 
controlplane $ exit
```

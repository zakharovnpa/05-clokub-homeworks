### ДР по ДЗ 14.5 Security Context

- Среда для запуска K8S - сайт [killercoda.com](https://killercoda.com/playgrounds/scenario/kubernetes). Авторизация через УЗ GitHub.


- Logs
```tf
Initialising Kubernetes... done

controlplane $ 
controlplane $ 
controlplane $ date && \
> mkdir -p My-Project && cd My-Project && \
> touch example-security-context.yml example-network-policy.yml
Sun Feb 19 13:00:29 UTC 2023
controlplane $ echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: security-context-demo
> spec:
>   containers:
>   - name: sec-ctx-demo
>     image: fedora:latest
>     command: [ "id" ]
>     # command: [ "sh", "-c", "sleep 1h" ]
>     securityContext:
>       runAsUser: 1000
>       runAsGroup: 3000
> " > example-security-context.yml && \
> echo "
> ---
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: test-network-policy
>   namespace: default
> spec:
>   podSelector:
>     matchLabels:
>       role: db
>   policyTypes:
>   - Ingress
>   - Egress
>   ingress:
>   - from:
>     - ipBlock:
>         cidr: 172.17.0.0/16
>         except:
>         - 172.17.1.0/24
>     - namespaceSelector:
>         matchLabels:
>           project: myproject
>     - podSelector:
>         matchLabels:
>           role: frontend
>     ports:
>     - protocol: TCP
>       port: 6379
>   egress:
>   - to:
>     - ipBlock:
>         cidr: 10.0.0.0/24
>     ports:
>     - protocol: TCP
>       port: 5978
> " > example-network-policy.yml && \
> sleep 3 && \
> cat example-network-policy.yml && \
> sleep 3 && \
> cat example-security-context.yml && \
> date

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978


---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ id ]
    # command: [ sh, -c, sleep 1h ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000

Sun Feb 19 13:00:35 UTC 2023
controlplane $ 
controlplane $ 
controlplane $ cat example-security-context.yml 

---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ id ]
    # command: [ sh, -c, sleep 1h ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000

controlplane $ 
controlplane $ vi example-security-context.yml 
controlplane $ 
controlplane $ 
controlplane $ cat example-security-context.yml 

---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ "id" ]
    command: [ "sh", "-c", "sleep 1h" ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000

controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f example-security-context.yml 
pod/security-context-demo created
controlplane $ 
controlplane $ kubectl get pod
NAME                    READY   STATUS    RESTARTS   AGE
security-context-demo   1/1     Running   0          16s
controlplane $ 
controlplane $ 
controlplane $ kubectl logs security-context-demo 
controlplane $ 
controlplane $ kubectl logs -h                    
Print the logs for a container in a pod or specified resource. If the pod has only one container, the container name is
optional.

Examples:
  # Return snapshot logs from pod nginx with only one container
  kubectl logs nginx
  
  # Return snapshot logs from pod nginx with multi containers
  kubectl logs nginx --all-containers=true
  
  # Return snapshot logs from all containers in pods defined by label app=nginx
  kubectl logs -l app=nginx --all-containers=true
  
  # Return snapshot of previous terminated ruby container logs from pod web-1
  kubectl logs -p -c ruby web-1
  
  # Begin streaming the logs of the ruby container in pod web-1
  kubectl logs -f -c ruby web-1
  
  # Begin streaming the logs from all containers in pods defined by label app=nginx
  kubectl logs -f -l app=nginx --all-containers=true
  
  # Display only the most recent 20 lines of output in pod nginx
  kubectl logs --tail=20 nginx
  
  # Show all logs from pod nginx written in the last hour
  kubectl logs --since=1h nginx
  
  # Show logs from a kubelet with an expired serving certificate
  kubectl logs --insecure-skip-tls-verify-backend nginx
  
  # Return snapshot logs from first container of a job named hello
  kubectl logs job/hello
  
  # Return snapshot logs from container nginx-1 of a deployment named nginx
  kubectl logs deployment/nginx -c nginx-1

Options:
    --all-containers=false:
        Get all containers' logs in the pod(s).

    -c, --container='':
        Print the logs of this container

    -f, --follow=false:
        Specify if the logs should be streamed.

    --ignore-errors=false:
        If watching / following pod logs, allow for any errors that occur to be non-fatal

    --insecure-skip-tls-verify-backend=false:
        Skip verifying the identity of the kubelet that logs are requested from.  In theory, an attacker could provide
        invalid log content back. You might want to use this if your kubelet serving certificates have expired.

    --limit-bytes=0:
        Maximum bytes of logs to return. Defaults to no limit.

    --max-log-requests=5:
        Specify maximum number of concurrent logs to follow when using by a selector. Defaults to 5.

    --pod-running-timeout=20s:
        The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running

    --prefix=false:
        Prefix each log line with the log source (pod name and container name)

    -p, --previous=false:
        If true, print the logs for the previous instance of the container in a pod if it exists.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matching
        objects must satisfy all of the specified label constraints.

    --since=0s:
        Only return logs newer than a relative duration like 5s, 2m, or 3h. Defaults to all logs. Only one of
        since-time / since may be used.

    --since-time='':
        Only return logs after a specific date (RFC3339). Defaults to all logs. Only one of since-time / since may be
        used.

    --tail=-1:
        Lines of recent log file to display. Defaults to -1 with no selector, showing all log lines otherwise 10, if a
        selector is provided.

    --timestamps=false:
        Include timestamps on each line in the log output

Usage:
  kubectl logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).
controlplane $ 
controlplane $ kubectl logs -c security-context-demo 
error: expected 'logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER]'.
POD or TYPE/NAME is a required argument for the logs command
See 'kubectl logs -h' for help and examples
controlplane $ 
controlplane $ kubectl apply -f example-network-policy.yml 
networkpolicy.networking.k8s.io/test-network-policy created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                    READY   STATUS    RESTARTS   AGE
security-context-demo   1/1     Running   0          3m26s
controlplane $ 
controlplane $ cat example-network-policy.yml 

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978

controlplane $ 
controlplane $ 
controlplane $ kubectl get np
^C
controlplane $ 
controlplane $ kubectl get           
You must specify the type of resource to get. Use "kubectl api-resources" for a complete list of supported resources.

error: Required resource not specified.
Use "kubectl explain <resource>" for a detailed description of that resource (e.g. kubectl explain pods).
See 'kubectl get -h' for help and examples
controlplane $ 
controlplane $ kubectl get -h
Display one or many resources.

 Prints a table of the most important information about the specified resources. You can filter the list using a label
selector and the --selector flag. If the desired resource type is namespaced you will only see results in your current
namespace unless you pass --all-namespaces.

 By specifying the output as 'template' and providing a Go template as the value of the --template flag, you can filter
the attributes of the fetched resources.

Use "kubectl api-resources" for a complete list of supported resources.

Examples:
  # List all pods in ps output format
  kubectl get pods
  
  # List all pods in ps output format with more information (such as node name)
  kubectl get pods -o wide
  
  # List a single replication controller with specified NAME in ps output format
  kubectl get replicationcontroller web
  
  # List deployments in JSON output format, in the "v1" version of the "apps" API group
  kubectl get deployments.v1.apps -o json
  
  # List a single pod in JSON output format
  kubectl get -o json pod web-pod-13je7
  
  # List a pod identified by type and name specified in "pod.yaml" in JSON output format
  kubectl get -f pod.yaml -o json
  
  # List resources from a directory with kustomization.yaml - e.g. dir/kustomization.yaml
  kubectl get -k dir/
  
  # Return only the phase value of the specified pod
  kubectl get -o template pod/web-pod-13je7 --template={{.status.phase}}
  
  # List resource information in custom columns
  kubectl get pod test-pod -o custom-columns=CONTAINER:.spec.containers[0].name,IMAGE:.spec.containers[0].image
  
  # List all replication controllers and services together in ps output format
  kubectl get rc,services
  
  # List one or more resources by their type and names
  kubectl get rc/web service/frontend pods/web-pod-13je7
  
  # List status subresource for a single pod.
  kubectl get pod web-pod-13je7 --subresource status

Options:
    -A, --all-namespaces=false:
        If present, list the requested object(s) across all namespaces. Namespace in current context is ignored even
        if specified with --namespace.

    --allow-missing-template-keys=true:
        If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to
        golang and jsonpath output formats.

    --chunk-size=500:
        Return large lists in chunks rather than all at once. Pass 0 to disable. This flag is beta and may change in
        the future.

    --field-selector='':
        Selector (field query) to filter on, supports '=', '==', and '!='.(e.g. --field-selector
        key1=value1,key2=value2). The server only supports a limited number of field queries per type.

    -f, --filename=[]:
        Filename, directory, or URL to files identifying the resource to get from a server.

    --ignore-not-found=false:
        If the requested object does not exist the command will return exit code 0.

    -k, --kustomize='':
        Process the kustomization directory. This flag can't be used together with -f or -R.

    -L, --label-columns=[]:
        Accepts a comma separated list of labels that are going to be presented as columns. Names are case-sensitive.
        You can also use multiple flag options like -L label1 -L label2...

    --no-headers=false:
        When using the default or custom-column output format, don't print headers (default print headers).

    -o, --output='':
        Output format. One of: (json, yaml, name, go-template, go-template-file, template, templatefile, jsonpath,
        jsonpath-as-json, jsonpath-file, custom-columns, custom-columns-file, wide). See custom columns
        [https://kubernetes.io/docs/reference/kubectl/#custom-columns], golang template
        [http://golang.org/pkg/text/template/#pkg-overview] and jsonpath template
        [https://kubernetes.io/docs/reference/kubectl/jsonpath/].

    --output-watch-events=false:
        Output watch event objects when --watch or --watch-only is used. Existing objects are output as initial ADDED
        events.

    --raw='':
        Raw URI to request from the server.  Uses the transport specified by the kubeconfig file.

    -R, --recursive=false:
        Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests
        organized within the same directory.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matching
        objects must satisfy all of the specified label constraints.

    --server-print=true:
        If true, have the server return the appropriate table output. Supports extension APIs and CRDs.

    --show-kind=false:
        If present, list the resource type for the requested object(s).

    --show-labels=false:
        When printing, show all labels as the last column (default hide labels column)

    --show-managed-fields=false:
        If true, keep the managedFields when printing objects in JSON or YAML format.

    --sort-by='':
        If non-empty, sort list types using this field specification.  The field specification is expressed as a
        JSONPath expression (e.g. '{.metadata.name}'). The field in the API resource specified by this JSONPath
        expression must be an integer or a string.

    --subresource='':
        If specified, gets the subresource of the requested object. Must be one of [status scale]. This flag is alpha
        and may change in the future.

    --template='':
        Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format
        is golang templates [http://golang.org/pkg/text/template/#pkg-overview].

    -w, --watch=false:
        After listing/getting the requested object, watch for changes.

    --watch-only=false:
        Watch for changes to the requested object(s), without listing/getting first.

Usage:
  kubectl get
[(-o|--output=)json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-as-json|jsonpath-file|custom-columns|custom-columns-file|wide]
(TYPE[.VERSION][.GROUP] [NAME | -l label] | TYPE[.VERSION][.GROUP]/NAME ...) [flags] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl logs security-context-demo 
controlplane $ 
controlplane $ kubectl logs -c                    
error: flag needs an argument: 'c' in -c
See 'kubectl logs --help' for usage.
controlplane $ 
controlplane $ kubectl logs -A
error: unknown shorthand flag: 'A' in -A
See 'kubectl logs --help' for usage.
controlplane $ 
controlplane $ kubectl get -A 
You must specify the type of resource to get. Use "kubectl api-resources" for a complete list of supported resources.

error: Required resource not specified.
Use "kubectl explain <resource>" for a detailed description of that resource (e.g. kubectl explain pods).
See 'kubectl get -h' for help and examples
controlplane $ 
controlplane $ kubectl get pod -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
default       security-context-demo                      1/1     Running   0          6m57s
kube-system   calico-kube-controllers-5f94594857-5n2vd   1/1     Running   2          23d
kube-system   canal-7l5nf                                2/2     Running   0          27m
kube-system   canal-qvblw                                2/2     Running   0          27m
kube-system   coredns-68dc769db8-56kh8                   1/1     Running   0          23d
kube-system   coredns-68dc769db8-ppqqg                   1/1     Running   0          23d
kube-system   etcd-controlplane                          1/1     Running   0          23d
kube-system   kube-apiserver-controlplane                1/1     Running   2          23d
kube-system   kube-controller-manager-controlplane       1/1     Running   2          23d
kube-system   kube-proxy-7bh6f                           1/1     Running   0          23d
kube-system   kube-proxy-pml4f                           1/1     Running   0          23d
kube-system   kube-scheduler-controlplane                1/1     Running   2          23d
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl get networkpolicy.networking.k8s.io/test-network-policy
NAME                  POD-SELECTOR   AGE
test-network-policy   role=db        4m51s
controlplane $ 
controlplane $ kubectl logs security-context-demo 
controlplane $ 
controlplane $ kubectl describe pod security-context-demo 
Name:             security-context-demo
Namespace:        default
Priority:         0
Service Account:  default
Node:             node01/172.30.2.2
Start Time:       Sun, 19 Feb 2023 13:02:36 +0000
Labels:           <none>
Annotations:      cni.projectcalico.org/containerID: 64685024a3a694e6100c812321f0cba4c99bba7a61d9ca88342415f67b2b03de
                  cni.projectcalico.org/podIP: 192.168.1.3/32
                  cni.projectcalico.org/podIPs: 192.168.1.3/32
Status:           Running
IP:               192.168.1.3
IPs:
  IP:  192.168.1.3
Containers:
  sec-ctx-demo:
    Container ID:  containerd://385b326aae2badc48a5504e0314d4ac40c7228c1a1e83d0d1b9251bdd474461f
    Image:         fedora:latest
    Image ID:      docker.io/library/fedora@sha256:07a6341eb8b7dcc45fb392fdac0210362a3901ab19846d29e949d70285883216
    Port:          <none>
    Host Port:     <none>
    Command:
      sh
      -c
      sleep 1h
    State:          Running
      Started:      Sun, 19 Feb 2023 13:02:41 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-d7thx (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-d7thx:
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
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  10m   default-scheduler  Successfully assigned default/security-context-demo to node01
  Normal  Pulling    10m   kubelet            Pulling image "fedora:latest"
  Normal  Pulled     10m   kubelet            Successfully pulled image "fedora:latest" in 4.53137475s (4.531378575s including waiting)
  Normal  Created    10m   kubelet            Created container sec-ctx-demo
  Normal  Started    10m   kubelet            Started container sec-ctx-demo
controlplane $ 
controlplane $ 
controlplane $ kubectl logs security-context-demo ?
error: container ? is not valid for pod security-context-demo
controlplane $ 
controlplane $ kubectl logs security-context-demo uid=1000
error: container uid=1000 is not valid for pod security-context-demo
controlplane $ 
controlplane $ kubectl logs pods/security-context-demo uid=1000
error: container uid=1000 is not valid for pod security-context-demo
controlplane $ 
controlplane $ kubectl logs pods/security-context-demo         
controlplane $ 
controlplane $ kubectl logs -h                        
Print the logs for a container in a pod or specified resource. If the pod has only one container, the container name is
optional.

Examples:
  # Return snapshot logs from pod nginx with only one container
  kubectl logs nginx
  
  # Return snapshot logs from pod nginx with multi containers
  kubectl logs nginx --all-containers=true
  
  # Return snapshot logs from all containers in pods defined by label app=nginx
  kubectl logs -l app=nginx --all-containers=true
  
  # Return snapshot of previous terminated ruby container logs from pod web-1
  kubectl logs -p -c ruby web-1
  
  # Begin streaming the logs of the ruby container in pod web-1
  kubectl logs -f -c ruby web-1
  
  # Begin streaming the logs from all containers in pods defined by label app=nginx
  kubectl logs -f -l app=nginx --all-containers=true
  
  # Display only the most recent 20 lines of output in pod nginx
  kubectl logs --tail=20 nginx
  
  # Show all logs from pod nginx written in the last hour
  kubectl logs --since=1h nginx
  
  # Show logs from a kubelet with an expired serving certificate
  kubectl logs --insecure-skip-tls-verify-backend nginx
  
  # Return snapshot logs from first container of a job named hello
  kubectl logs job/hello
  
  # Return snapshot logs from container nginx-1 of a deployment named nginx
  kubectl logs deployment/nginx -c nginx-1

Options:
    --all-containers=false:
        Get all containers' logs in the pod(s).

    -c, --container='':
        Print the logs of this container

    -f, --follow=false:
        Specify if the logs should be streamed.

    --ignore-errors=false:
        If watching / following pod logs, allow for any errors that occur to be non-fatal

    --insecure-skip-tls-verify-backend=false:
        Skip verifying the identity of the kubelet that logs are requested from.  In theory, an attacker could provide
        invalid log content back. You might want to use this if your kubelet serving certificates have expired.

    --limit-bytes=0:
        Maximum bytes of logs to return. Defaults to no limit.

    --max-log-requests=5:
        Specify maximum number of concurrent logs to follow when using by a selector. Defaults to 5.

    --pod-running-timeout=20s:
        The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running

    --prefix=false:
        Prefix each log line with the log source (pod name and container name)

    -p, --previous=false:
        If true, print the logs for the previous instance of the container in a pod if it exists.

    -l, --selector='':
        Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2). Matching
        objects must satisfy all of the specified label constraints.

    --since=0s:
        Only return logs newer than a relative duration like 5s, 2m, or 3h. Defaults to all logs. Only one of
        since-time / since may be used.

    --since-time='':
        Only return logs after a specific date (RFC3339). Defaults to all logs. Only one of since-time / since may be
        used.

    --tail=-1:
        Lines of recent log file to display. Defaults to -1 with no selector, showing all log lines otherwise 10, if a
        selector is provided.

    --timestamps=false:
        Include timestamps on each line in the log output

Usage:
  kubectl logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER] [options]

Use "kubectl options" for a list of global command-line options (applies to all commands).
controlplane $ 
controlplane $ kubectl logs pods/security-context-demo -c 385b326aae2badc48a5504e0314d4ac40c7228c1a1e83d0d1b9251bdd474461f
error: container 385b326aae2badc48a5504e0314d4ac40c7228c1a1e83d0d1b9251bdd474461f is not valid for pod security-context-demo
controlplane $ 
controlplane $ kubectl logs pods/security-context-demo -c sec-ctx-demo                                                    
controlplane $ 
controlplane $ kubectl logs -c sec-ctx-demo
error: expected 'logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER]'.
POD or TYPE/NAME is a required argument for the logs command
See 'kubectl logs -h' for help and examples
controlplane $ 
controlplane $ kubectl logs pods/security-context-demo -c sec-ctx-demo
controlplane $ 
controlplane $ 
controlplane $ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
controlplane $ 
controlplane $ docker ps -a
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
controlplane $ 
controlplane $ kubectl exec security-context-demo -it sh -c sec-ctx-demo
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
sh-5.2$ 
sh-5.2$ pwd
/
sh-5.2$ 
sh-5.2$ ;s -lha
sh: syntax error near unexpected token `;'
sh-5.2$ 
sh-5.2$ ls -lha
total 64K
drwxr-xr-x   1 root root 4.0K Feb 19 13:02 .
drwxr-xr-x   1 root root 4.0K Feb 19 13:02 ..
dr-xr-xr-x   2 root root 4.0K Aug  9  2022 afs
lrwxrwxrwx   1 root root    7 Aug  9  2022 bin -> usr/bin
dr-xr-xr-x   2 root root 4.0K Aug  9  2022 boot
drwxr-xr-x   5 root root  360 Feb 19 13:02 dev
drwxr-xr-x  44 root root 4.0K Feb  5 05:49 etc
drwxr-xr-x   2 root root 4.0K Aug  9  2022 home
lrwxrwxrwx   1 root root    7 Aug  9  2022 lib -> usr/lib
lrwxrwxrwx   1 root root    9 Aug  9  2022 lib64 -> usr/lib64
drwx------   2 root root 4.0K Feb  5 05:48 lost+found
drwxr-xr-x   2 root root 4.0K Aug  9  2022 media
drwxr-xr-x   2 root root 4.0K Aug  9  2022 mnt
drwxr-xr-x   2 root root 4.0K Aug  9  2022 opt
dr-xr-xr-x 207 root root    0 Feb 19 13:02 proc
dr-xr-x---   2 root root 4.0K Feb  5 05:49 root
drwxr-xr-x   1 root root 4.0K Feb 19 13:02 run
lrwxrwxrwx   1 root root    8 Aug  9  2022 sbin -> usr/sbin
drwxr-xr-x   2 root root 4.0K Aug  9  2022 srv
dr-xr-xr-x  13 root root    0 Feb 19 13:02 sys
drwxrwxrwt   2 root root 4.0K Feb  5 05:48 tmp
drwxr-xr-x  12 root root 4.0K Feb  5 05:48 usr
drwxr-xr-x  18 root root 4.0K Feb  5 05:48 var
sh-5.2$ 
sh-5.2$ cd usr/   
sh-5.2$ 
sh-5.2$ pwd
/usr
sh-5.2$ 
sh-5.2$ ls -l
total 56
dr-xr-xr-x  2 root root  4096 Feb  5 05:49 bin
drwxr-xr-x  2 root root  4096 Aug  9  2022 games
drwxr-xr-x  3 root root  4096 Feb  5 05:48 include
dr-xr-xr-x 17 root root  4096 Feb  5 05:49 lib
dr-xr-xr-x 22 root root 20480 Feb  5 05:49 lib64
drwxr-xr-x  9 root root  4096 Feb  5 05:49 libexec
drwxr-xr-x 12 root root  4096 Feb  5 05:48 local
dr-xr-xr-x  2 root root  4096 Feb  5 05:49 sbin
drwxr-xr-x 55 root root  4096 Feb  5 05:49 share
drwxr-xr-x  4 root root  4096 Feb  5 05:48 src
lrwxrwxrwx  1 root root    10 Aug  9  2022 tmp -> ../var/tmp
sh-5.2$ 
sh-5.2$ la share/
sh: la: command not found
sh-5.2$ 
sh-5.2$ ls share/
X11           authselect       crypto-policies      file    gdb       i18n          libreport  man        p11-kit       python-wheels  vim
aclocal       awk              desktop-directories  fish    glib-2.0  icons         licenses   metainfo   pam.d         sounds         wayland-sessions
appdata       backgrounds      dict                 games   gnome     idl           locale     mime-info  pixmaps       tabset         xsessions
applications  bash-completion  doc                  gawk    gnupg     info          lua        misc       pki           terminfo       zoneinfo
augeas        cracklib         empty                gcc-12  help      libgpg-error  magic      omf        publicsuffix  themes         zsh
sh-5.2$ 
sh-5.2$ 
sh-5.2$ cd /
sh-5.2$ 
sh-5.2$ pwd
/
sh-5.2$ 
sh-5.2$ ping 8.8.8.8
sh: ping: command not found
sh-5.2$ 
sh-5.2$ curl 8.8.8.8
^C
sh-5.2$ 
sh-5.2$ 
sh-5.2$ 
sh-5.2$ exit
exit
command terminated with exit code 130
controlplane $ 
controlplane $ cat example-security-context.yml 

---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ "id" ]
    command: [ "sh", "-c", "sleep 1h" ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000

controlplane $ 
controlplane $ kubectl exec -it security-context-demo bash
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
bash-5.2$ 
bash-5.2$ ps -ef
bash: ps: command not found
bash-5.2$ 
bash-5.2$ id
uid=1000 gid=3000 groups=3000
bash-5.2$ 
bash-5.2$ id
uid=1000 gid=3000 groups=3000
bash-5.2$ 
bash-5.2$ exit
exit
controlplane $ 
controlplane $ kubectl logs pods/security-context-demo -c sec-ctx-demo
controlplane $ 
controlplane $ kubectl logs pods/security-context-demo                
controlplane $ 
controlplane $ kubectl logs security-context-demo
controlplane $ 
controlplane $ id
uid=0(root) gid=0(root) groups=0(root)
controlplane $ 
controlplane $ 
```

## - ЛР-3. Запуск пода с командами и просмотр результатов выполнения команд

###  Логи выполнения

* Tab 1
```
controlplane $ 
controlplane $ mkdir -p My-Project
controlplane $ 
controlplane $ vi pod.yaml
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
error: error validating "pod.yaml": error validating data: [ValidationError(Pod): unknown field "command" in io.k8s.api.core.v1.Pod, ValidationError(Pod): unknown field "containers" in io.k8s.api.core.v1.Pod, ValidationError(Pod): unknown field "image" in io.k8s.api.core.v1.Pod, ValidationError(Pod): unknown field "name" in io.k8s.api.core.v1.Pod]; if you choose to ignore these errors, turn validation off with --validate=false
controlplane $ 
controlplane $ vi pod.yaml
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
error: error validating "pod.yaml": error validating data: [ValidationError(Pod.spec): unknown field "command" in io.k8s.api.core.v1.PodSpec, ValidationError(Pod.spec): unknown field "image" in io.k8s.api.core.v1.PodSpec]; if you choose to ignore these errors, turn validation off with --validate=false
controlplane $ 
controlplane $ vi pod.yaml
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
error: error parsing pod.yaml: error converting YAML to JSON: yaml: line 10: mapping values are not allowed in this context
controlplane $ 
controlplane $ vi pod.yaml
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          8s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS     AGE
netology-14.4   0/1     Completed   1 (3s ago)   10s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (2s ago)   11s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (3s ago)   12s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (4s ago)   13s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (5s ago)   14s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (6s ago)   15s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (7s ago)   16s
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl delete -f pod.yaml 
pod "netology-14.4" deleted
controlplane $ 
controlplane $ cp pod.yaml my-pod.yaml
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl delete -f my-pod.yaml 
error: error parsing my-pod.yaml: error converting YAML to JSON: yaml: line 10: mapping values are not allowed in this context
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl delete -f my-pod.yaml 
Error from server (NotFound): error when deleting "my-pod.yaml": pods "netology-14.4" not found
controlplane $ 
controlplane $ kubectl aply -f my-pod.yaml 
error: unknown command "aply" for "kubectl"

Did you mean this?
        apply
controlplane $ 
controlplane $ kubectl apply -f my-pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (4s ago)   6s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (5s ago)   7s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (6s ago)   8s
controlplane $ 
controlplane $ kubectl delete -f my-pod.yaml 
pod "netology-14.4" deleted
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f my-pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS     AGE
netology-14.4   0/1     Completed   1 (2s ago)   3s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (2s ago)   4s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (4s ago)   6s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (5s ago)   7s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (5s ago)   7s
controlplane $ 
controlplane $ kubectl delete -f my-pod.yaml 
pod "netology-14.4" deleted
controlplane $ 
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f my-pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.4   1/1     Running   0          3s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.4   1/1     Running   0          4s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.4   1/1     Running   0          5s
controlplane $ 
controlplane $ 
controlplane $ cat pod.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.4
spec:
  containers:
  - name: myapp
    image: fedora:latest
    command: ['ls', '-la', '/var/run/secrets/kubernetes.io/serviceaccount']

controlplane $ 
controlplane $ 
controlplane $ kubectl delete -f my-pod.yaml 
pod "netology-14.4" deleted
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f my-pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (2s ago)   4s
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (4s ago)   6s
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (5s ago)   7s
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (6s ago)   8s
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS      AGE
netology-14.4   0/1     CrashLoopBackOff   3 (33s ago)   79s
controlplane $ 
controlplane $ kubectl describe pod netology-14.4 
Name:         netology-14.4
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Thu, 11 Aug 2022 07:39:01 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: eae8d9f442283f9139ba90c7d2598ef9a4ec016e38225f22eff2357e1643d421
              cni.projectcalico.org/podIP: 192.168.1.8/32
              cni.projectcalico.org/podIPs: 192.168.1.8/32
Status:       Running
IP:           192.168.1.8
IPs:
  IP:  192.168.1.8
Containers:
  myapp:
    Container ID:  containerd://04e08caff25ec4523d58cc24f271285b187140b520e90ffd6aa3e6b55014813f
    Image:         zakharovnpa/k8s-fedora:03.08.22
    Image ID:      docker.io/zakharovnpa/k8s-fedora@sha256:36f6660840fb3e78c56906dbc899778a65b904bc5a18ce58653acd33b93f7ed7
    Port:          <none>
    Host Port:     <none>
    Command:
      pwd
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 11 Aug 2022 07:39:47 +0000
      Finished:     Thu, 11 Aug 2022 07:39:47 +0000
    Ready:          False
    Restart Count:  3
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-vknwp (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-vknwp:
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
  Normal   Scheduled  88s                default-scheduler  Successfully assigned default/netology-14.4 to node01
  Normal   Created    42s (x4 over 87s)  kubelet            Created container myapp
  Normal   Started    42s (x4 over 87s)  kubelet            Started container myapp
  Warning  BackOff    15s (x7 over 85s)  kubelet            Back-off restarting failed container
  Normal   Pulled     1s (x5 over 87s)   kubelet            Container image "zakharovnpa/k8s-fedora:03.08.22" already present on machine
controlplane $ 
controlplane $ 
controlplane $ kubectl explain pod.spec.containers.  
KIND:     Pod
VERSION:  v1

RESOURCE: containers <[]Object>

DESCRIPTION:
     List of containers belonging to the pod. Containers cannot currently be
     added or removed. There must be at least one container in a Pod. Cannot be
     updated.

     A single application container that you want to run within a pod.

FIELDS:
   args <[]string>
     Arguments to the entrypoint. The container image's CMD is used if this is
     not provided. Variable references $(VAR_NAME) are expanded using the
     container's environment. If a variable cannot be resolved, the reference in
     the input string will be unchanged. Double $$ are reduced to a single $,
     which allows for escaping the $(VAR_NAME) syntax: i.e. "$$(VAR_NAME)" will
     produce the string literal "$(VAR_NAME)". Escaped references will never be
     expanded, regardless of whether the variable exists or not. Cannot be
     updated. More info:
     https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell

   command      <[]string>
     Entrypoint array. Not executed within a shell. The container image's
     ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME)
     are expanded using the container's environment. If a variable cannot be
     resolved, the reference in the input string will be unchanged. Double $$
     are reduced to a single $, which allows for escaping the $(VAR_NAME)
     syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)".
     Escaped references will never be expanded, regardless of whether the
     variable exists or not. Cannot be updated. More info:
     https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell

   env  <[]Object>
     List of environment variables to set in the container. Cannot be updated.

   envFrom      <[]Object>
     List of sources to populate environment variables in the container. The
     keys defined within a source must be a C_IDENTIFIER. All invalid keys will
     be reported as an event when the container is starting. When a key exists
     in multiple sources, the value associated with the last source will take
     precedence. Values defined by an Env with a duplicate key will take
     precedence. Cannot be updated.

   image        <string>
     Container image name. More info:
     https://kubernetes.io/docs/concepts/containers/images This field is
     optional to allow higher level config management to default or override
     container images in workload controllers like Deployments and StatefulSets.

   imagePullPolicy      <string>
     Image pull policy. One of Always, Never, IfNotPresent. Defaults to Always
     if :latest tag is specified, or IfNotPresent otherwise. Cannot be updated.
     More info:
     https://kubernetes.io/docs/concepts/containers/images#updating-images

     Possible enum values:
     - `"Always"` means that kubelet always attempts to pull the latest image.
     Container will fail If the pull fails.
     - `"IfNotPresent"` means that kubelet pulls if the image isn't present on
     disk. Container will fail if the image isn't present and the pull fails.
     - `"Never"` means that kubelet never pulls an image, but only uses a local
     image. Container will fail if the image isn't present

   lifecycle    <Object>
     Actions that the management system should take in response to container
     lifecycle events. Cannot be updated.

   livenessProbe        <Object>
     Periodic probe of container liveness. Container will be restarted if the
     probe fails. Cannot be updated. More info:
     https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

   name <string> -required-
     Name of the container specified as a DNS_LABEL. Each container in a pod
     must have a unique name (DNS_LABEL). Cannot be updated.

   ports        <[]Object>
     List of ports to expose from the container. Exposing a port here gives the
     system additional information about the network connections a container
     uses, but is primarily informational. Not specifying a port here DOES NOT
     prevent that port from being exposed. Any port which is listening on the
     default "0.0.0.0" address inside a container will be accessible from the
     network. Cannot be updated.

   readinessProbe       <Object>
     Periodic probe of container service readiness. Container will be removed
     from service endpoints if the probe fails. Cannot be updated. More info:
     https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

   resources    <Object>
     Compute Resources required by this container. Cannot be updated. More info:
     https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

   securityContext      <Object>
     SecurityContext defines the security options the container should be run
     with. If set, the fields of SecurityContext override the equivalent fields
     of PodSecurityContext. More info:
     https://kubernetes.io/docs/tasks/configure-pod-container/security-context/

   startupProbe <Object>
     StartupProbe indicates that the Pod has successfully initialized. If
     specified, no other probes are executed until this completes successfully.
     If this probe fails, the Pod will be restarted, just as if the
     livenessProbe failed. This can be used to provide different probe
     parameters at the beginning of a Pod's lifecycle, when it might take a long
     time to load data or warm a cache, than during steady-state operation. This
     cannot be updated. More info:
     https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes

   stdin        <boolean>
     Whether this container should allocate a buffer for stdin in the container
     runtime. If this is not set, reads from stdin in the container will always
     result in EOF. Default is false.

   stdinOnce    <boolean>
     Whether the container runtime should close the stdin channel after it has
     been opened by a single attach. When stdin is true the stdin stream will
     remain open across multiple attach sessions. If stdinOnce is set to true,
     stdin is opened on container start, is empty until the first client
     attaches to stdin, and then remains open and accepts data until the client
     disconnects, at which time stdin is closed and remains closed until the
     container is restarted. If this flag is false, a container processes that
     reads from stdin will never receive an EOF. Default is false

   terminationMessagePath       <string>
     Optional: Path at which the file to which the container's termination
     message will be written is mounted into the container's filesystem. Message
     written is intended to be brief final status, such as an assertion failure
     message. Will be truncated by the node if greater than 4096 bytes. The
     total message length across all containers will be limited to 12kb.
     Defaults to /dev/termination-log. Cannot be updated.

   terminationMessagePolicy     <string>
     Indicate how the termination message should be populated. File will use the
     contents of terminationMessagePath to populate the container status message
     on both success and failure. FallbackToLogsOnError will use the last chunk
     of container log output if the termination message file is empty and the
     container exited with an error. The log output is limited to 2048 bytes or
     80 lines, whichever is smaller. Defaults to File. Cannot be updated.

     Possible enum values:
     - `"FallbackToLogsOnError"` will read the most recent contents of the
     container logs for the container status message when the container exits
     with an error and the terminationMessagePath has no contents.
     - `"File"` is the default behavior and will set the container status
     message to the contents of the container's terminationMessagePath when the
     container exits.

   tty  <boolean>
     Whether this container should allocate a TTY for itself, also requires
     'stdin' to be true. Default is false.

   volumeDevices        <[]Object>
     volumeDevices is the list of block devices to be used by the container.

   volumeMounts <[]Object>
     Pod volumes to mount into the container's filesystem. Cannot be updated.

   workingDir   <string>
     Container's working directory. If not specified, the container runtime's
     default will be used, which might be configured in the container image.
     Cannot be updated.

controlplane $ 
controlplane $ kubectl explain pod.spec.containers.command.
KIND:     Pod
VERSION:  v1

FIELD:    command <[]string>

DESCRIPTION:
     Entrypoint array. Not executed within a shell. The container image's
     ENTRYPOINT is used if this is not provided. Variable references $(VAR_NAME)
     are expanded using the container's environment. If a variable cannot be
     resolved, the reference in the input string will be unchanged. Double $$
     are reduced to a single $, which allows for escaping the $(VAR_NAME)
     syntax: i.e. "$$(VAR_NAME)" will produce the string literal "$(VAR_NAME)".
     Escaped references will never be expanded, regardless of whether the
     variable exists or not. Cannot be updated. More info:
     https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell
controlplane $ 
controlplane $ kubectl delete pod netology-14.4 
pod "netology-14.4" deleted
controlplane $ 
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f my-pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS              RESTARTS   AGE
netology-14.4   0/1     ContainerCreating   0          5s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS              RESTARTS   AGE
netology-14.4   0/1     ContainerCreating   0          7s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS              RESTARTS   AGE
netology-14.4   0/1     ContainerCreating   0          8s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS              RESTARTS   AGE
netology-14.4   0/1     ContainerCreating   0          9s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          10s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS     AGE
netology-14.4   0/1     Completed   1 (2s ago)   12s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (2s ago)   13s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (3s ago)   14s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (4s ago)   15s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (6s ago)   17s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (7s ago)   18s
controlplane $ 
controlplane $ kubectl describe pod netology-14.4 
Name:         netology-14.4
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Thu, 11 Aug 2022 07:51:32 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: 5c3fc8fe6b50be1d7507a11a1d20ebf530b1827f2e0a0d56eb06f4512bee0c56
              cni.projectcalico.org/podIP: 192.168.1.9/32
              cni.projectcalico.org/podIPs: 192.168.1.9/32
Status:       Running
IP:           192.168.1.9
IPs:
  IP:  192.168.1.9
Containers:
  myapp:
    Container ID:  containerd://4dd6291748acb3153192729885330a6d92efd7c25882d3ab9ba5981655be92b8
    Image:         zakharovnpa/k8s-fedora:03.08.22
    Image ID:      docker.io/zakharovnpa/k8s-fedora@sha256:36f6660840fb3e78c56906dbc899778a65b904bc5a18ce58653acd33b93f7ed7
    Port:          <none>
    Host Port:     <none>
    Command:
      pwd
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 11 Aug 2022 07:51:43 +0000
      Finished:     Thu, 11 Aug 2022 07:51:43 +0000
    Ready:          False
    Restart Count:  1
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-crslm (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-crslm:
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
  Normal   Scheduled  24s                default-scheduler  Successfully assigned default/netology-14.4 to node01
  Normal   Pulled     14s (x2 over 20s)  kubelet            Container image "zakharovnpa/k8s-fedora:03.08.22" already present on machine
  Normal   Created    14s (x2 over 14s)  kubelet            Created container myapp
  Normal   Started    13s (x2 over 14s)  kubelet            Started container myapp
  Warning  BackOff    12s (x2 over 13s)  kubelet            Back-off restarting failed container
controlplane $ 
controlplane $ 
controlplane $ kubectl delete pod netology-14.4 
pod "netology-14.4" deleted
controlplane $ 
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f my-pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          4s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          6s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          7s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          8s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          9s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          10s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          11s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          12s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          13s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          14s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          16s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          17s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          18s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          19s
controlplane $ 
controlplane $ kubectl describe pod netology-14.4 
Name:         netology-14.4
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Thu, 11 Aug 2022 07:54:37 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: 1f9139b42220bf1161348e77d5a81f7b3faadfbb6d42d86b71143e4545f19625
              cni.projectcalico.org/podIP: 
              cni.projectcalico.org/podIPs: 
Status:       Succeeded
IP:           192.168.1.10
IPs:
  IP:  192.168.1.10
Containers:
  myapp:
    Container ID:  containerd://59848bb4eef6e2cec8c0bfd2698caf54fff334f865578dd128a3b8b2d2b50bed
    Image:         zakharovnpa/k8s-fedora:03.08.22
    Image ID:      docker.io/zakharovnpa/k8s-fedora@sha256:36f6660840fb3e78c56906dbc899778a65b904bc5a18ce58653acd33b93f7ed7
    Port:          <none>
    Host Port:     <none>
    Command:
      printenv
    Args:
      HOSTNAME
      KUBERNETES_PORT
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 11 Aug 2022 07:54:38 +0000
      Finished:     Thu, 11 Aug 2022 07:54:38 +0000
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-wf9hd (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-wf9hd:
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
  Normal  Scheduled  21s   default-scheduler  Successfully assigned default/netology-14.4 to node01
  Normal  Pulled     21s   kubelet            Container image "zakharovnpa/k8s-fedora:03.08.22" already present on machine
  Normal  Created    21s   kubelet            Created container myapp
  Normal  Started    20s   kubelet            Started container myapp
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          28s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          33s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          35s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          36s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          38s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          40s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          41s
controlplane $ 
controlplane $ kubectl describe pod netology-14.4 
Name:         netology-14.4
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Thu, 11 Aug 2022 07:54:37 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: 1f9139b42220bf1161348e77d5a81f7b3faadfbb6d42d86b71143e4545f19625
              cni.projectcalico.org/podIP: 
              cni.projectcalico.org/podIPs: 
Status:       Succeeded
IP:           192.168.1.10
IPs:
  IP:  192.168.1.10
Containers:
  myapp:
    Container ID:  containerd://59848bb4eef6e2cec8c0bfd2698caf54fff334f865578dd128a3b8b2d2b50bed
    Image:         zakharovnpa/k8s-fedora:03.08.22
    Image ID:      docker.io/zakharovnpa/k8s-fedora@sha256:36f6660840fb3e78c56906dbc899778a65b904bc5a18ce58653acd33b93f7ed7
    Port:          <none>
    Host Port:     <none>
    Command:
      printenv
    Args:
      HOSTNAME
      KUBERNETES_PORT
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 11 Aug 2022 07:54:38 +0000
      Finished:     Thu, 11 Aug 2022 07:54:38 +0000
    Ready:          False
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-wf9hd (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-wf9hd:
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
  Normal  Scheduled  43s   default-scheduler  Successfully assigned default/netology-14.4 to node01
  Normal  Pulled     43s   kubelet            Container image "zakharovnpa/k8s-fedora:03.08.22" already present on machine
  Normal  Created    43s   kubelet            Created container myapp
  Normal  Started    42s   kubelet            Started container myapp
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          49s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          57s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS      RESTARTS   AGE
netology-14.4   0/1     Completed   0          62s
controlplane $ 
controlplane $ kubectl delete pod netology-14.4 
pod "netology-14.4" deleted
controlplane $ 
controlplane $ kubectl get po
No resources found in default namespace.
controlplane $ 
controlplane $ vi my-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f my-pod.yaml 
pod/netology-14.4 created
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (6s ago)   8s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (8s ago)   10s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.4   0/1     CrashLoopBackOff   1 (9s ago)   11s
controlplane $ 
controlplane $ kubectl describe pod netology-14.4 
Name:         netology-14.4
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Thu, 11 Aug 2022 07:56:12 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: 4931e20a70aadfb6cfcedc3daf73e321bf390f8796c143ff75f2039648d9a35f
              cni.projectcalico.org/podIP: 192.168.1.11/32
              cni.projectcalico.org/podIPs: 192.168.1.11/32
Status:       Running
IP:           192.168.1.11
IPs:
  IP:  192.168.1.11
Containers:
  myapp:
    Container ID:  containerd://711d65b590933cf6b875e601312975e1f2093612150db39c135874a5a6c90ea2
    Image:         zakharovnpa/k8s-fedora:03.08.22
    Image ID:      docker.io/zakharovnpa/k8s-fedora@sha256:36f6660840fb3e78c56906dbc899778a65b904bc5a18ce58653acd33b93f7ed7
    Port:          <none>
    Host Port:     <none>
    Command:
      printenv
    Args:
      HOSTNAME
      KUBERNETES_PORT
    State:          Waiting
      Reason:       CrashLoopBackOff
    Last State:     Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Thu, 11 Aug 2022 07:56:14 +0000
      Finished:     Thu, 11 Aug 2022 07:56:14 +0000
    Ready:          False
    Restart Count:  1
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-fj85d (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-fj85d:
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
  Normal   Scheduled  15s                default-scheduler  Successfully assigned default/netology-14.4 to node01
  Normal   Pulled     13s (x2 over 14s)  kubelet            Container image "zakharovnpa/k8s-fedora:03.08.22" already present on machine
  Normal   Created    13s (x2 over 14s)  kubelet            Created container myapp
  Normal   Started    13s (x2 over 14s)  kubelet            Started container myapp
  Warning  BackOff    11s (x2 over 12s)  kubelet            Back-off restarting failed container
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS      AGE
netology-14.4   0/1     CrashLoopBackOff   3 (26s ago)   70s
controlplane $ 
controlplane $ kubectl logs netology-14.4 
netology-14.4
tcp://10.96.0.1:443
controlplane $ 
controlplane $ cat pod.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.4
spec:
  containers:
  - name: myapp
    image: fedora:latest
    command: ['ls', '-la', '/var/run/secrets/kubernetes.io/serviceaccount']

controlplane $ 
controlplane $ cat my-pod.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.4
spec:
  containers:
  - name: myapp
    image: zakharovnpa/k8s-fedora:03.08.22
    command: ["printenv"]
    args: ["HOSTNAME", "KUBERNETES_PORT"]
controlplane $ 
controlplane $ vi pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f pod.yaml 
pod/netology-14.5 created
controlplane $ 
controlplane $ kubectl logs netology-14.5 
total 4
drwxrwxrwt 3 root root  140 Aug 11 07:59 .
drwxr-xr-x 3 root root 4096 Aug 11 07:59 ..
drwxr-xr-x 2 root root  100 Aug 11 07:59 ..2022_08_11_07_59_45.1666067405
lrwxrwxrwx 1 root root   32 Aug 11 07:59 ..data -> ..2022_08_11_07_59_45.1666067405
lrwxrwxrwx 1 root root   13 Aug 11 07:59 ca.crt -> ..data/ca.crt
lrwxrwxrwx 1 root root   16 Aug 11 07:59 namespace -> ..data/namespace
lrwxrwxrwx 1 root root   12 Aug 11 07:59 token -> ..data/token
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS        AGE
netology-14.4   0/1     CrashLoopBackOff   7 (86s ago)     12m
netology-14.5   0/1     CrashLoopBackOff   6 (2m50s ago)   8m43s
controlplane $ 
controlplane $ 
controlplane $
controlplane $ cat pod.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.5
spec:
  containers:
  - name: myapp-fedora
    image: fedora:latest
    command: ["ls", "-la", "/var/run/secrets/kubernetes.io/serviceaccount"]

controlplane $ 
controlplane $ 
controlplane $ cat my-pod.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.4
spec:
  containers:
  - name: myapp
    image: zakharovnpa/k8s-fedora:03.08.22
    command: ["printenv"]
    args: ["HOSTNAME", "KUBERNETES_PORT"]
controlplane $ 
```

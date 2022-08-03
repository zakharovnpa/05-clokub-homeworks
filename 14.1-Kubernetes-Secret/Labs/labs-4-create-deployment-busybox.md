## ЛР-4. "Подготовка манифестов для задачи 2*, часть 2. Подключение секрета к volume"
> Задача: создать секрет и разместить его в volume. 
> Нужно чтобы в директории с общим доступом лежал файл с секретом или сертификат. И чтобы это файл был доступени и читаем.
> 

#### Скрипт для подготовки окружения

```
date && \
mkdir -p My-Project && cd My-Project/ && \
touch username.txt password.txt secret-busybox-pod.yaml busybox-pod.yaml&& \
echo ‘admin’ > username.txt && \
echo ‘password’ > password.txt && \
echo "
# Config Deployment Frontend & Backend with Volume
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: sbb-app
  name: secret-busybox-pod 
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
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: one-busybox
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: "/static"
              name: my-volume
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: two-busybox
          volumeMounts:
            - mountPath: "/tmp/cache"
              name: my-volume
      volumes:
        - name: my-volume
          secret:
            secretName: domain-cert
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: busybox-pod
  labels:
    app: bb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30091
  selector:
    app: bb-pod
" > secret-busybox-pod.yaml && \
echo "
# Config Deployment Frontend & Backend with Volume
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: busybox-pod 
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
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: one-busybox
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: "/static"
              name: my-volume
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: two-busybox
          volumeMounts:
            - mountPath: "/tmp/cache"
              name: my-volume
      volumes:
        - name: my-volume
          emptyDir: {}
 
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: busybox-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30091
  selector:
    app: sbb-pod
" > busybox-pod.yaml && \
clear && \
kubectl create secret generic user-cred --from-file=./username.txt --from-file=./password.txt

```
```
kubectl get pod 
```
```
kubectl get secrets 
```
### Логи - 2. Успешное подключение секрета в виде volume
* Tab 1
```
Initialising Kubernetes... done

controlplane $ date && \
> mkdir -p My-Project && cd My-Project/ && \
> touch username.txt password.txt secret-busybox-pod.yaml busybox-pod.yaml&& \
> echo ‘admin’ > username.txt && \
> echo ‘password’ > password.txt && \
> echo "
> # Config Deployment Frontend & Backend with Volume
> ---
> apiVersion: apps/v1
> kind: Deployment
> metadata:
>   labels:
>     app: sbb-app
>   name: secret-busybox-pod 
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
>         - image: zakharovnpa/k8s-busybox:02.08.22
>           imagePullPolicy: IfNotPresent
>           name: one-busybox
>           ports:
>           - containerPort: 80
>           volumeMounts:
>             - mountPath: "/static"
>               name: my-volume
>         - image: zakharovnpa/k8s-busybox:02.08.22
>           imagePullPolicy: IfNotPresent
>           name: two-busybox
>           volumeMounts:
>             - mountPath: "/tmp/cache"
>               name: my-volume
>       volumes:
>         - name: my-volume
>           secret:
>             secretName: domain-cert
>           emptyDir: {}
>  
> ---
> # Config Service
> apiVersion: v1
> kind: Service
> metadata:
>   name: busybox-pod
>   labels:
>     app: bb
> spec:
>   type: NodePort
>   ports:
>   - port: 80
>     nodePort: 30091
>   selector:
>     app: bb-pod
> " > secret-busybox-pod.yaml && \
> echo "
> # Config Deployment Frontend & Backend with Volume
> ---
> apiVersion: apps/v1
> kind: Deployment
> metadata:
>   labels:
>     app: bb-app
>   name: busybox-pod 
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
>         - image: zakharovnpa/k8s-busybox:02.08.22
>           imagePullPolicy: IfNotPresent
>           name: one-busybox
>           ports:
>           - containerPort: 80
>           volumeMounts:
>             - mountPath: "/static"
>               name: my-volume
>         - image: zakharovnpa/k8s-busybox:02.08.22
>           imagePullPolicy: IfNotPresent
>           name: two-busybox
>           volumeMounts:
>             - mountPath: "/tmp/cache"
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
>   name: busybox-pod
>   labels:
>     app: sbb
> spec:
>   type: NodePort
>   ports:
>   - port: 80
>     nodePort: 30091
>   selector:
>     app: sbb-pod
> " > busybox-pod.yaml && \
> kubectl create secret generic user-cred --from-file=./username.txt --from-file=./password.txt
Wed Aug  3 12:31:07 UTC 2022
secret/user-cred created
controlplane $ 
controlplane $ 
controlplane $ pwd
/root/My-Project
controlplane $ 
controlplane $ ls
busybox-pod.yaml  password.txt  secret-busybox-pod.yaml  username.txt
controlplane $ 
controlplane $ kubectl get pod 
No resources found in default namespace.
controlplane $ 
controlplane $ kubectl get secrets 
NAME        TYPE     DATA   AGE
user-cred   Opaque   2      47s
controlplane $ 
controlplane $ cat busybox-pod.yaml 

# Config Deployment Frontend & Backend with Volume
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: busybox-pod 
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
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: one-busybox
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-volume
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: two-busybox
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
  name: busybox-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30091
  selector:
    app: sbb-pod

controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f busybox-pod.yaml 
deployment.apps/busybox-pod created
service/busybox-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                           READY   STATUS    RESTARTS   AGE
busybox-pod-69b6cdf8b4-2986x   2/2     Running   0          2m4s
controlplane $ 
controlplane $ kubectl apply -f secret-busybox-pod.yaml 
service/busybox-pod configured
The Deployment "secret-busybox-pod" is invalid: 
* spec.template.spec.volumes[0].secret: Forbidden: may not specify more than 1 volume type
* spec.template.spec.containers[0].volumeMounts[0].name: Not found: "my-volume"
* spec.template.spec.containers[1].volumeMounts[0].name: Not found: "my-volume"
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f secret-busybox-pod.yaml 
service/busybox-pod unchanged
The Deployment "secret-busybox-pod" is invalid: 
* spec.template.spec.volumes[0].secret: Forbidden: may not specify more than 1 volume type
* spec.template.spec.containers[0].volumeMounts[0].name: Not found: "my-secret-volume"
* spec.template.spec.containers[1].volumeMounts[0].name: Not found: "my-secret-volume"
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ kubectl get secrets                
NAME        TYPE     DATA   AGE
user-cred   Opaque   2      7m26s
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f secret-busybox-pod.yaml 
service/busybox-pod unchanged
The Deployment "secret-busybox-pod" is invalid: 
* spec.template.spec.volumes[0].secret: Forbidden: may not specify more than 1 volume type
* spec.template.spec.containers[0].volumeMounts[0].name: Not found: "my-secret-volume"
* spec.template.spec.containers[1].volumeMounts[0].name: Not found: "my-secret-volume"
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f secret-busybox-pod.yaml 
deployment.apps/secret-busybox-pod created
service/busybox-pod unchanged
controlplane $ 
controlplane $ kubectl get pod
NAME                                  READY   STATUS    RESTARTS   AGE
busybox-pod-69b6cdf8b4-2986x          2/2     Running   0          8m32s
secret-busybox-pod-6fc569f94b-spkbj   2/2     Running   0          12s
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ date
Wed Aug  3 12:41:52 UTC 2022
controlplane $ 
controlplane $ cat secret-busybox-pod.yaml 

# Config Deployment Frontend & Backend with Volume
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: sbb-app
  name: secret-busybox-pod 
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
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: one-busybox
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-secret-volume
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: two-busybox
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
  name: busybox-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30092
  selector:
    app: sbb-pod

controlplane $ 
controlplane $ 
controlplane $ kubectl get secrets 
NAME        TYPE     DATA   AGE
user-cred   Opaque   2      11m
controlplane $ 
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-spkbj -it sh -c one-busybox 
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
/ # 
/ # pwd
/
/ # 
/ # ls
bin     dev     etc     home    proc    root    static  sys     tmp     usr     var
/ # 
/ # cd static/
/static # 
/static # ls
password.txt  username.txt
/static # 
/static # cat password.txt 
‘password’
/static # 
/static # cat username.txt 
‘admin’
/static # 
```
![screen-secret-file-in-volume](/14.1-Kubernetes-Secret/Files/screen-secret-file-in-volume.png)




### Логи - 1. Неуспешная попытка подключения секрета в виде volume
* Tab 1
```
Initialising Kubernetes... done

controlplane $ mkdir -p My-Project
controlplane $ 
controlplane $ cd My-Project/
controlplane $ 
controlplane $ vi pod.yml
controlplane $ 
controlplane $ cat pod.yml 
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: nginx
    image: nginx:latest
  ports:
  - containerPort: 80
    protocol: TCP
  - containerPort: 443
    protocol: TCP
  volumeMounts:
  - name: certs
    mountPath: "/etc/nginx/ssl"
    readOnly: true
  - name: config
    mountPath: /etc/nginx/conf.d
    readOnly: true
  volumes:
  - name: certs
    secret:
      secretName: domain-cert
  - name: config
    configMap:
      name: nginx-config
controlplane $ 
controlplane $ 
controlplane $ echo ‘admin’ > username.txt
controlplane $ 
controlplane $ echo ‘password’ > password.txt
controlplane $ 
controlplane $ kubectl create secret generic user-cred --from-file=./username.txt --from-file=./password.txt
secret/user-cred created
controlplane $ 
controlplane $ kubectl get secrets 
NAME        TYPE     DATA   AGE
user-cred   Opaque   2      8s
controlplane $ 
controlplane $ kubectl create secret generic domain-cert --from-file=./username.txt --from-file=./password.txt
secret/domain-cert created
controlplane $ 
controlplane $ kubectl get secrets 
NAME          TYPE     DATA   AGE
domain-cert   Opaque   2      3s
user-cred     Opaque   2      51s
controlplane $ 
controlplane $ 
controlplane $ kubectl get secrets domain-cert -o yaml
apiVersion: v1
data:
  password.txt: 4oCYcGFzc3dvcmTigJkK
  username.txt: 4oCYYWRtaW7igJkK
kind: Secret
metadata:
  creationTimestamp: "2022-08-03T02:36:19Z"
  name: domain-cert
  namespace: default
  resourceVersion: "1962"
  uid: 73f73510-af43-41e7-a78b-3a4c64e159fd
type: Opaque
controlplane $ 
controlplane $ 
controlplane $ kubectl get secrets user-cred -o yaml
apiVersion: v1
data:
  password.txt: 4oCYcGFzc3dvcmTigJkK
  username.txt: 4oCYYWRtaW7igJkK
kind: Secret
metadata:
  creationTimestamp: "2022-08-03T02:35:31Z"
  name: user-cred
  namespace: default
  resourceVersion: "1896"
  uid: 2497c0f4-f727-446d-8f06-60b3ec09d231
type: Opaque
controlplane $ 
controlplane $ kubectl get pod
No resources found in default namespace.
controlplane $ 
controlplane $ ls -l
total 12
-rw-r--r-- 1 root root  15 Aug  3 02:34 password.txt
-rw-r--r-- 1 root root 478 Aug  3 02:33 pod.yml
-rw-r--r-- 1 root root  12 Aug  3 02:34 username.txt
controlplane $ 
controlplane $ ls
password.txt  pod.yml  username.txt
controlplane $ 
controlplane $ 
controlplane $ date
Wed Aug  3 02:38:09 UTC 2022
controlplane $ 
controlplane $ kubectl apply -f pod.yml 
error: error validating "pod.yml": error validating data: [ValidationError(Pod.spec): unknown field "ports" in io.k8s.api.core.v1.PodSpec, ValidationError(Pod.spec): unknown field "volumeMounts" in io.k8s.api.core.v1.PodSpec]; if you choose to ignore these errors, turn validation off with --validate=false
controlplane $ 
controlplane $ vi pod.yml
controlplane $ 
controlplane $ kubectl apply -f pod.yml 
error: error validating "pod.yml": error validating data: [ValidationError(Pod.spec): unknown field "ports" in io.k8s.api.core.v1.PodSpec, ValidationError(Pod.spec): unknown field "volumeMounts" in io.k8s.api.core.v1.PodSpec]; if you choose to ignore these errors, turn validation off with --validate=false
controlplane $ 
controlplane $ 
controlplane $ vi pod.yml
controlplane $ 
controlplane $ kubectl apply -f pod.yml 
error: error validating "pod.yml": error validating data: ValidationError(Pod.spec): unknown field "volumeMounts" in io.k8s.api.core.v1.PodSpec; if you choose to ignore these errors, turn validation off with --validate=false
controlplane $ 
controlplane $ vi pod.yml
controlplane $ 
controlplane $ vi fb-pod.yaml
controlplane $ 
controlplane $ vi pod.yml
controlplane $ 
controlplane $ kubectl apply -f fb-pod.yaml 
deployment.apps/fb-pod created
service/fb-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                      READY   STATUS              RESTARTS   AGE
fb-pod-6464948946-vczgl   0/2     ContainerCreating   0          10s
controlplane $ 
controlplane $ 
controlplane $ cp fb-pod.yaml busybox-pod.yaml
controlplane $ 
controlplane $ vi busybox-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f busybox-pod.yaml 
deployment.apps/busybox-pod created
service/busybox-pod created
controlplane $ 
controlplane $ kubectl get po
NAME                           READY   STATUS    RESTARTS   AGE
busybox-pod-69b6cdf8b4-r8bgv   2/2     Running   0          8s
fb-pod-6464948946-vczgl        2/2     Running   0          4m59s
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl get svc
NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
busybox-pod   NodePort    10.101.242.218   <none>        80:30090/TCP   111s
fb-pod        NodePort    10.98.105.117    <none>        80:30080/TCP   6m42s
kubernetes    ClusterIP   10.96.0.1        <none>        443/TCP        86d
controlplane $ 
controlplane $ kubectl get pod busybox-pod-69b6cdf8b4-r8bgv -o yaml
apiVersion: v1
kind: Pod
metadata:
  annotations:
    cni.projectcalico.org/containerID: 2d08fa2bdcd844cf837424fd53725e997c8ec676524b0578ef59a9b8b1d035e6
    cni.projectcalico.org/podIP: 192.168.0.6/32
    cni.projectcalico.org/podIPs: 192.168.0.6/32
  creationTimestamp: "2022-08-03T02:50:14Z"
  generateName: busybox-pod-69b6cdf8b4-
  labels:
    app: bb-app
    pod-template-hash: 69b6cdf8b4
  name: busybox-pod-69b6cdf8b4-r8bgv
  namespace: default
  ownerReferences:
  - apiVersion: apps/v1
    blockOwnerDeletion: true
    controller: true
    kind: ReplicaSet
    name: busybox-pod-69b6cdf8b4
    uid: 6de6a854-2880-437e-aa5c-1ba3fdfd5d83
  resourceVersion: "3103"
  uid: 1ecd2f43-bf6b-4b22-b256-b20a073f2cc7
spec:
  containers:
  - image: zakharovnpa/k8s-busybox:02.08.22
    imagePullPolicy: IfNotPresent
    name: one-busybox
    ports:
    - containerPort: 80
      protocol: TCP
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /static
      name: my-volume
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-nk7k5
      readOnly: true
  - image: zakharovnpa/k8s-busybox:02.08.22
    imagePullPolicy: IfNotPresent
    name: two-busybox
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /tmp/cache
      name: my-volume
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-nk7k5
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: controlplane
  preemptionPolicy: PreemptLowerPriority
  priority: 0
  restartPolicy: Always
  schedulerName: default-scheduler
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - emptyDir: {}
    name: my-volume
  - name: kube-api-access-nk7k5
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          expirationSeconds: 3607
          path: token
      - configMap:
          items:
          - key: ca.crt
            path: ca.crt
          name: kube-root-ca.crt
      - downwardAPI:
          items:
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
            path: namespace
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2022-08-03T02:50:14Z"
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2022-08-03T02:50:18Z"
    status: "True"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2022-08-03T02:50:18Z"
    status: "True"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2022-08-03T02:50:14Z"
    status: "True"
    type: PodScheduled
  containerStatuses:
  - containerID: containerd://466246a6f5953e0120b6d7a8819b1bbe0162332b4742376fc7adb7a504c0b2bc
    image: docker.io/zakharovnpa/k8s-busybox:02.08.22
    imageID: docker.io/zakharovnpa/k8s-busybox@sha256:ca18e2401ab009f346871abbb543c3f50dbe372f100fdc2f835d92379365c25d
    lastState: {}
    name: one-busybox
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2022-08-03T02:50:17Z"
  - containerID: containerd://2b7bca117f27f3188426391e4a201a44122a8823eb09b4cae52027753e5f3062
    image: docker.io/zakharovnpa/k8s-busybox:02.08.22
    imageID: docker.io/zakharovnpa/k8s-busybox@sha256:ca18e2401ab009f346871abbb543c3f50dbe372f100fdc2f835d92379365c25d
    lastState: {}
    name: two-busybox
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2022-08-03T02:50:17Z"
  hostIP: 172.30.1.2
  phase: Running
  podIP: 192.168.0.6
  podIPs:
  - ip: 192.168.0.6
  qosClass: BestEffort
  startTime: "2022-08-03T02:50:14Z"
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl get svc busybox-pod -o yaml                 
apiVersion: v1
kind: Service
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Service","metadata":{"annotations":{},"labels":{"app":"bb"},"name":"busybox-pod","namespace":"default"},"spec":{"ports":[{"nodePort":30090,"port":80}],"selector":{"app":"bb-pod"},"type":"NodePort"}}
  creationTimestamp: "2022-08-03T02:50:14Z"
  labels:
    app: bb
  name: busybox-pod
  namespace: default
  resourceVersion: "3087"
  uid: 9dc7a856-9dd1-4b75-9b6e-76718f3a13a8
spec:
  clusterIP: 10.101.242.218
  clusterIPs:
  - 10.101.242.218
  externalTrafficPolicy: Cluster
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - nodePort: 30090
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: bb-pod
  sessionAffinity: None
  type: NodePort
status:
  loadBalancer: {}
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl get deployments.apps 
NAME          READY   UP-TO-DATE   AVAILABLE   AGE
busybox-pod   1/1     1            1           5m
fb-pod        1/1     1            1           9m51s
controlplane $ 
controlplane $ kubectl delete deployments.apps busybox-pod                  
deployment.apps "busybox-pod" deleted
controlplane $ 
controlplane $ kubectl get deployments.apps 
NAME     READY   UP-TO-DATE   AVAILABLE   AGE
fb-pod   1/1     1            1           10m
controlplane $ 
controlplane $ kubectl get pod                                     
NAME                           READY   STATUS        RESTARTS   AGE
busybox-pod-69b6cdf8b4-r8bgv   2/2     Terminating   0          5m38s
fb-pod-6464948946-vczgl        2/2     Running       0          10m
controlplane $ 
controlplane $ kubectl get pod
NAME                           READY   STATUS        RESTARTS   AGE
busybox-pod-69b6cdf8b4-r8bgv   2/2     Terminating   0          5m44s
fb-pod-6464948946-vczgl        2/2     Running       0          10m
controlplane $ 
controlplane $ kubectl get pod
NAME                           READY   STATUS        RESTARTS   AGE
busybox-pod-69b6cdf8b4-r8bgv   2/2     Terminating   0          5m52s
fb-pod-6464948946-vczgl        2/2     Running       0          10m
controlplane $ 
controlplane $ kubectl get pod
NAME                      READY   STATUS    RESTARTS   AGE
fb-pod-6464948946-vczgl   2/2     Running   0          10m
controlplane $ 
controlplane $ 
controlplane $ vi busybox-pod.yaml 
controlplane $ 
controlplane $ cp busybox-pod.yaml secret-busybox-pod.yaml
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f secret-busybox-pod.yaml 
service/busybox-pod unchanged
The Deployment "busybox-pod" is invalid: 
* spec.template.spec.volumes[0].secret: Forbidden: may not specify more than 1 volume type
* spec.template.spec.containers[0].volumeMounts[0].name: Not found: "my-volume"
* spec.template.spec.containers[1].volumeMounts[0].name: Not found: "my-volume"
controlplane $ 
controlplane $ vi secret-busybox-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f secret-busybox-pod.yaml 
service/busybox-pod configured
The Deployment "secret-busybox-pod" is invalid: 
* spec.template.spec.volumes[0].secret: Forbidden: may not specify more than 1 volume type
* spec.template.spec.containers[0].volumeMounts[0].name: Not found: "my-volume"
* spec.template.spec.containers[1].volumeMounts[0].name: Not found: "my-volume"
controlplane $ 
controlplane $ 
controlplane $ 
```
```
controlplane $ 
controlplane $ cat secret-busybox-pod.yaml 
# Config Deployment Frontend & Backend with Volume
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: secret-busybox-pod 
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
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: one-busybox
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: "/static"
              name: my-volume
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: two-busybox
          volumeMounts:
            - mountPath: "/tmp/cache"
              name: my-volume
      volumes:
        - name: my-volume
          secret:
            secretName: domain-cert
          emptyDir: {}
 
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: busybox-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30091
  selector:
    app: sbb-pod
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                      READY   STATUS    RESTARTS   AGE
fb-pod-6464948946-vczgl   2/2     Running   0          27m
controlplane $ 
controlplane $ kubectl get secrets 
NAME          TYPE     DATA   AGE
domain-cert   Opaque   2      36m
user-cred     Opaque   2      37m
controlplane $ 
controlplane $ 
```
```
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                      READY   STATUS    RESTARTS   AGE
fb-pod-6464948946-vczgl   2/2     Running   0          27m
controlplane $ 
controlplane $ kubectl get secrets 
NAME          TYPE     DATA   AGE
domain-cert   Opaque   2      36m
user-cred     Opaque   2      37m
controlplane $ 
controlplane $ ls -l
total 24
-rw-r--r-- 1 root root 1029 Aug  3 02:50 busybox-pod.yaml
-rw-r--r-- 1 root root 1013 Aug  3 02:44 fb-pod.yaml
-rw-r--r-- 1 root root   15 Aug  3 02:34 password.txt
-rw-r--r-- 1 root root  348 Aug  3 02:41 pod.yml
-rw-r--r-- 1 root root 1094 Aug  3 03:07 secret-busybox-pod.yaml
-rw-r--r-- 1 root root   12 Aug  3 02:34 username.txt
controlplane $ 
controlplane $ 
controlplane $ 
controlplane 
controlplane $ 
controlplane $ kubectl apply -f busybox-pod.yaml 
deployment.apps/busybox-pod created
service/busybox-pod configured
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                           READY   STATUS    RESTARTS   AGE
busybox-pod-69b6cdf8b4-xjpxc   2/2     Running   0          15s
fb-pod-6464948946-vczgl        2/2     Running   0          35m
controlplane $ 
controlplane $ kubectl get volumeattachments.storage.k8s.io 
No resources found
controlplane $ 
controlplane $ kubectl describe po busybox-pod-69b6cdf8b4-xjpxc  
Name:         busybox-pod-69b6cdf8b4-xjpxc
Namespace:    default
Priority:     0
Node:         controlplane/172.30.1.2
Start Time:   Wed, 03 Aug 2022 03:21:06 +0000
Labels:       app=bb-app
              pod-template-hash=69b6cdf8b4
Annotations:  cni.projectcalico.org/containerID: f90eba5332ae601ac6a0bbf65a71c8aecf40728dd700cc1f31d2bbbf52a02b2b
              cni.projectcalico.org/podIP: 192.168.0.7/32
              cni.projectcalico.org/podIPs: 192.168.0.7/32
Status:       Running
IP:           192.168.0.7
IPs:
  IP:           192.168.0.7
Controlled By:  ReplicaSet/busybox-pod-69b6cdf8b4
Containers:
  one-busybox:
    Container ID:   containerd://dd772a6bc542f89da77222b023216578e2934feb186820c484a2702ebb5f9fc8
    Image:          zakharovnpa/k8s-busybox:02.08.22
    Image ID:       docker.io/zakharovnpa/k8s-busybox@sha256:ca18e2401ab009f346871abbb543c3f50dbe372f100fdc2f835d92379365c25d
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Wed, 03 Aug 2022 03:21:07 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /static from my-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-kpdtz (ro)
  two-busybox:
    Container ID:   containerd://ed2b0d30f3417b787b12e406cad429444da4d49b8689cbfd2ff601212164dfc0
    Image:          zakharovnpa/k8s-busybox:02.08.22
    Image ID:       docker.io/zakharovnpa/k8s-busybox@sha256:ca18e2401ab009f346871abbb543c3f50dbe372f100fdc2f835d92379365c25d
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Wed, 03 Aug 2022 03:21:07 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /tmp/cache from my-volume (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-kpdtz (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  my-volume:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     
    SizeLimit:  <unset>
  kube-api-access-kpdtz:
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
  Normal  Scheduled  49s   default-scheduler  Successfully assigned default/busybox-pod-69b6cdf8b4-xjpxc to controlplane
  Normal  Pulled     48s   kubelet            Container image "zakharovnpa/k8s-busybox:02.08.22" already present on machine
  Normal  Created    48s   kubelet            Created container one-busybox
  Normal  Started    48s   kubelet            Started container one-busybox
  Normal  Pulled     48s   kubelet            Container image "zakharovnpa/k8s-busybox:02.08.22" already present on machine
  Normal  Created    48s   kubelet            Created container two-busybox
  Normal  Started    48s   kubelet            Started container two-busybox
controlplane $ 
controlplane $ 
controlplane $ 
```

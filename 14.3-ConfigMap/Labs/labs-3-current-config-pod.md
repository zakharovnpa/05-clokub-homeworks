## ЛР-3. Поиск причин краша контейнера при запуске. Устранение ошибки CrashLoopBackOff

```
Initialising Kubernetes... done

controlplane $ date && \
> mkdir -p My-Project/templates && cd My-Project && \
> touch nginx.conf myapp-pod.yml generator.py templates/nginx.vhosts.jinja && \
> echo "
> server {
>     listen 80;
>     server_name  netology.ru www.netology.ru;
>     access_log  /var/log/nginx/domains/netology.ru-access.log  main;
>     error_log   /var/log/nginx/domains/netology.ru-error.log info;
>     location / {
>         include proxy_params;
>         proxy_pass http://10.10.10.10:8080/;
>     }
> }
> " > nginx.conf && \
> echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: netology-14.3
> spec:
>   containers:
>   - name: myapp
>     image: fedora:latest
>     command: ['/bin/bash', '-c']
>     args: [\"env; ls -la /etc/nginx/conf.d\"]
>     env:
>       - name: SPECIAL_LEVEL_KEY
>         valueFrom:
>           configMapKeyRef:
>             name: nginx-config
>             key: nginx.conf
>     envFrom:
>       - configMapRef:
>           name: nginx-config
>     volumeMounts:
>       - mountPath: /etc/nginx/conf.d
>         name: config
>         readOnly: true
>   volumes:
>   - name: config
>     configMap:
>       name: nginx-config
> " > myapp-pod.yml && \
> echo "
> #!/usr/bin/env python3
bash: !/usr/bin/env: event not found
> 
> from jinja2 import Environment, FileSystemLoader
> 
> env = Environment(
>     loader=FileSystemLoader('templates')
> )
> template = env.get_template('nginx.vhosts.jinja')
> 
> domains = [{'domain': 'netology.ru',
>      'ip': '10.10.10.10'}]
> 
> for item in domains:
>     config=template.render(
>         domain=item['domain'], ip=item['ip']
>     )
>     print(config)
> " > generator.py && \
> echo "
> server {
>     listen 80;
>     server_name  {{ domain }} www.{{ domain }};
>     access_log  /var/log/nginx/domains/{{ domain }}-access.log  main;
>     error_log   /var/log/nginx/domains/{{ domain }}-error.log info;
>     location / {
>         include proxy_params;
>         proxy_pass http://{{ ip }}:8080/;
>     }
> }
> " > templates/nginx.vhosts.jinja && \
> echo "cat templates/nginx.vhosts.jinja" && \
> sleep 2 && \
> cat templates/nginx.vhosts.jinja && \
> echo "cat generator.py" && \
> sleep 2 && \
> cat generator.py && \
> echo "cat myapp-pod.yml" && \
> sleep 2 && \
> cat myapp-pod.yml && \
> echo "cat nginx.conf" && \
> sleep 2 && \
> cat nginx.conf && \
> kubectl create configmap nginx-config --from-file=nginx.conf
Wed Aug 10 06:47:55 UTC 2022
```
```
cat templates/nginx.vhosts.jinja

server {
    listen 80;
    server_name  {{ domain }} www.{{ domain }};
    access_log  /var/log/nginx/domains/{{ domain }}-access.log  main;
    error_log   /var/log/nginx/domains/{{ domain }}-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://{{ ip }}:8080/;
    }
}
```
```
cat generator.py


from jinja2 import Environment, FileSystemLoader

env = Environment(
    loader=FileSystemLoader('templates')
)
template = env.get_template('nginx.vhosts.jinja')

domains = [{'domain': 'netology.ru',
     'ip': '10.10.10.10'}]

for item in domains:
    config=template.render(
        domain=item['domain'], ip=item['ip']
    )
    print(config)
```
```
cat myapp-pod.yml

---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: myapp
    image: fedora:latest
    command: ['/bin/bash', '-c']
    args: ["env; ls -la /etc/nginx/conf.d"]
    env:
      - name: SPECIAL_LEVEL_KEY
        valueFrom:
          configMapKeyRef:
            name: nginx-config
            key: nginx.conf
    envFrom:
      - configMapRef:
          name: nginx-config
    volumeMounts:
      - mountPath: /etc/nginx/conf.d
        name: config
        readOnly: true
  volumes:
  - name: config
    configMap:
      name: nginx-config
```
```
cat nginx.conf

server {
    listen 80;
    server_name  netology.ru www.netology.ru;
    access_log  /var/log/nginx/domains/netology.ru-access.log  main;
    error_log   /var/log/nginx/domains/netology.ru-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://10.10.10.10:8080/;
    }
}
```
```
configmap/nginx-config created
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ vim myapp-pod.yml 
controlplane $ 
controlplane $ cp myapp-pod.yml app-pod.yaml
controlplane $ 
controlplane $ vi app-pod.yaml 
controlplane $ 
controlplane $ kubectl apply -f app-pod.yaml 
pod/netology-14.3 created
```
```
controlplane $ kubectl get po
NAME            READY   STATUS              RESTARTS   AGE
netology-14.3   0/1     ContainerCreating   0          6s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS   RESTARTS     AGE
netology-14.3   0/1     Error    1 (2s ago)   8s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.3   0/1     CrashLoopBackOff   1 (3s ago)   10s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.3   0/1     CrashLoopBackOff   1 (4s ago)   11s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.3   0/1     CrashLoopBackOff   1 (6s ago)   13s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS             RESTARTS     AGE
netology-14.3   0/1     CrashLoopBackOff   1 (8s ago)   15s
```
```
controlplane $ kubectl describe pod netology-14.3  
Name:         netology-14.3
Namespace:    default
Priority:     0
Node:         node01/172.30.2.2
Start Time:   Wed, 10 Aug 2022 06:49:32 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: 22bec7b931b3bc3e45a31b15c517b850cc76d32fbd591c39d1004b4cde1b9a54
              cni.projectcalico.org/podIP: 192.168.1.4/32
              cni.projectcalico.org/podIPs: 192.168.1.4/32
Status:       Running
IP:           192.168.1.4
IPs:
  IP:  192.168.1.4
Containers:
  myapp:
    Container ID:  containerd://20a1ce2462ac436e68ee08e770cbc1af21fef1f7e545cabcee5fa852e1446bdf
    Image:         fedora:latest
    Image ID:      docker.io/library/fedora@sha256:cbf627299e327f564233aac6b97030f9023ca41d3453c497be2f5e8f7762d185
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/bash
      -c
    Args:
      env; ls -la /etc/nginx/conf.d
    State:          Terminated
      Reason:       Error
      Exit Code:    2
      Started:      Wed, 10 Aug 2022 06:49:56 +0000
      Finished:     Wed, 10 Aug 2022 06:49:56 +0000
    Last State:     Terminated
      Reason:       Error
      Exit Code:    2
      Started:      Wed, 10 Aug 2022 06:49:39 +0000
      Finished:     Wed, 10 Aug 2022 06:49:39 +0000
    Ready:          False
    Restart Count:  2
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-drvxg (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             False 
  ContainersReady   False 
  PodScheduled      True 
Volumes:
  kube-api-access-drvxg:
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
  Type     Reason     Age               From               Message
  ----     ------     ----              ----               -------
  Normal   Scheduled  29s               default-scheduler  Successfully assigned default/netology-14.3 to node01
  Normal   Pulled     24s               kubelet            Successfully pulled image "fedora:latest" in 4.666848637s
  Normal   Pulled     22s               kubelet            Successfully pulled image "fedora:latest" in 408.371244ms
  Normal   Pulling    5s (x3 over 28s)  kubelet            Pulling image "fedora:latest"
  Normal   Created    5s (x3 over 23s)  kubelet            Created container myapp
  Normal   Started    5s (x3 over 23s)  kubelet            Started container myapp
  Normal   Pulled     5s                kubelet            Successfully pulled image "fedora:latest" in 359.751629ms
  Warning  BackOff    4s (x3 over 22s)  kubelet            Back-off restarting failed container
```
#### Создаем новый манифест app-pod.yaml. Без подключения Volume и ConfigMap
```
controlplane $ cat app-pod.yaml 

---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: myapp
    image: fedora:latest
    command: ['/bin/bash', '-c']
    args: ["env; ls -la /etc/nginx/conf.d"]
```
```
controlplane $ kubectl delete -f app-pod.yaml 
pod "netology-14.3" deleted
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
No resources found in default namespace.
```
```
controlplane $ vi app-pod.yaml 
```
#### Изменили манифест. Убрали строки
```
     command: ['/bin/bash', '-c']
    args: ["env; ls -la /etc/nginx/conf.d"]
```

```
controlplane $ cat app-pod.yaml 

---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: app
    image: zakharovnpa/k8s-fedora:03.08.22
```
#### Результат: под запустился без ошибок
```
controlplane $ kubectl apply -f app-pod.yaml 
pod/netology-14.3 created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS              RESTARTS   AGE
netology-14.3   0/1     ContainerCreating   0          3s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          10s
controlplane $ 
controlplane $ 
controlplane $ vi app-pod.yaml 
```
#### Новый манифест с рабочей конфигурацией
```
controlplane $ cat app-pod.yaml 

---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: app
    image: zakharovnpa/k8s-fedora:03.08.22
```
#### Старый манифест с нерабочей конфигурацией
```
controlplane $ cat myapp-pod.yml 

---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: myapp
    image: fedora:latest
    command: ['/bin/bash', '-c']
    args: ["env; ls -la /etc/nginx/conf.d"]
    env:
      - name: SPECIAL_LEVEL_KEY
        valueFrom:
          configMapKeyRef:
            name: nginx-config
            key: nginx.conf
    envFrom:
      - configMapRef:
          name: nginx-config
    volumeMounts:
      - mountPath: /etc/nginx/conf.d
        name: config
        readOnly: true
  volumes:
  - name: config
    configMap:
      name: nginx-config

```
#### Удаляем аварийный под
```
controlplane $ kubectl delete -f app-pod.yaml 
pod "netology-14.3" deleted
controlplane $ 
controlplane $ kubectl get po
No resources found in default namespace.
```
#### Создаем новый манифест с добавлением информаци о подключении Volume
```
controlplane $ cp app-pod.yaml cm-app-pod.yaml
controlplane $ 
controlplane $ vi cm-app-pod.yaml 
```
#### Запускаем Config Map
```
controlplane $ kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      93d
nginx-config       1      10m
controlplane $ 
controlplane $ kubectl get po
No resources found in default namespace.
```
#### Запускаем новый под
```
controlplane $ kubectl apply -f cm-app-pod.yaml 
pod/netology-14.3 created
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS              RESTARTS   AGE
netology-14.3   0/1     ContainerCreating   0          2s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          4s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          5s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          6s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          7s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          8s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          9s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          10s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          11s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          12s
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          102s
```
#### Заходим в контейнер и проверяем подключение Config Map в качестве Environment
```
controlplane $ kubectl exec netology-14.3 -it -- bash
[root@netology-14 /]# 
[root@netology-14 /]# pwd
/
[root@netology-14 /]# env
nginx.conf=
server {
    listen 80;
    server_name  netology.ru www.netology.ru;
    access_log  /var/log/nginx/domains/netology.ru-access.log  main;
    error_log   /var/log/nginx/domains/netology.ru-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://10.10.10.10:8080/;
    }
}


KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
HOSTNAME=netology-14.3
SPECIAL_LEVEL_KEY=
server {
    listen 80;
    server_name  netology.ru www.netology.ru;
    access_log  /var/log/nginx/domains/netology.ru-access.log  main;
    error_log   /var/log/nginx/domains/netology.ru-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://10.10.10.10:8080/;
    }
}


DISTTAG=f36container
PWD=/
FBR=f36
HOME=/root
LANG=C.UTF-8
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=01;37;41:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=01;36:*.au=01;36:*.flac=01;36:*.m4a=01;36:*.mid=01;36:*.midi=01;36:*.mka=01;36:*.mp3=01;36:*.mpc=01;36:*.ogg=01;36:*.ra=01;36:*.wav=01;36:*.oga=01;36:*.opus=01;36:*.spx=01;36:*.xspf=01;36:
FGC=f36
TERM=xterm
PASS_W=cGFzc3dvcmQK
SUPER_USER=YWRtaW4K
SHLVL=1
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
PATH=/root/.local/bin:/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
_=/usr/bin/env
[root@netology-14 /]# 
[root@netology-14 /]# 
[root@netology-14 /]# exit
exit
```

```
controlplane $ kubectl exec netology-14.3 -it -- bash -c pwd
/
controlplane $ 
controlplane $ kubectl exec netology-14.3 -it -- bash -c env | grep SPECIAL_LEVEL_KEY
SPECIAL_LEVEL_KEY=
controlplane $ 
controlplane $ kubectl exec netology-14.3 -it -- bash -c echo $SPECIAL_LEVEL_KEY

controlplane $ 
```
#### Результирующий рабочий манифест
```
controlplane $ cat cm-app-pod.yaml 

---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: app
    image: zakharovnpa/k8s-fedora:03.08.22
    env:
      - name: SPECIAL_LEVEL_KEY
        valueFrom:
          configMapKeyRef:
            name: nginx-config
            key: nginx.conf
    envFrom:
      - configMapRef:
          name: nginx-config
    volumeMounts:
      - mountPath: /etc/nginx/conf.d
        name: config
        readOnly: true
  volumes:
  - name: config
    configMap:
      name: nginx-config
```
#### Подтверждение успешности подключения ConfigMap в качестве Volume
```
controlplane $ kubectl exec netology-14.3 -it -- bash
[root@netology-14 /]# 
[root@netology-14 /]# ls -l /etc/nginx/conf.d/
total 0
lrwxrwxrwx 1 root root 17 Aug 10 06:59 nginx.conf -> ..data/nginx.conf
[root@netology-14 /]# 
[root@netology-14 /]# cat /etc/nginx/conf.d/nginx.conf 

server {
    listen 80;
    server_name  netology.ru www.netology.ru;
    access_log  /var/log/nginx/domains/netology.ru-access.log  main;
    error_log   /var/log/nginx/domains/netology.ru-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://10.10.10.10:8080/;
    }
}

[root@netology-14 /]# 
[root@netology-14 /]# 
```

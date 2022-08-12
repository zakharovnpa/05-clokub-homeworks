# Ход решения по ДЗ к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```
#### Ответ:
```
controlplane $ kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
```
```
controlplane $ kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      92d
nginx-config       1      8s
```
```
controlplane $ kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```
```
controlplane $ kubectl get cm
NAME               DATA   AGE
domain             1      4s
kube-root-ca.crt   1      92d
nginx-config       1      33s
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```
#### Ответ:
```
controlplane $ kubectl get configmaps
NAME               DATA   AGE
kube-root-ca.crt   1      93d
nginx-config       1      49s
controlplane $ 
controlplane $ kubectl get configmap 
NAME               DATA   AGE
kube-root-ca.crt   1      93d
nginx-config       1      55s
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```
#### Ответ:

```
controlplane $ kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      57s
```
```
controlplane $ kubectl describe configmap domain
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
controlplane $ 
controlplane $ kubectl describe configmap nginx-config
Name:         nginx-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
nginx.conf:
----

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



BinaryData
====

Events:  <none>
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```
#### Ответ:
```
controlplane $ kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |2+

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

kind: ConfigMap
metadata:
  creationTimestamp: "2022-08-09T06:39:11Z"
  name: nginx-config
  namespace: default
  resourceVersion: "1529"
  uid: 11c269ca-d218-4bf3-82ea-8cb389816919
```
```
controlplane $ kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-08-09T06:39:40Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "1570",
        "uid": "87a5d52a-6b32-48db-a550-c3ce35741873"
    }
}
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```
#### Ответ:
```
controlplane $ kubectl get configmaps -o json > configmaps.json
```
```
controlplane $ cat configmaps.json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "name": "netology.ru"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2022-08-09T06:39:40Z",
                "name": "domain",
                "namespace": "default",
                "resourceVersion": "1570",
                "uid": "87a5d52a-6b32-48db-a550-c3ce35741873"
            }
        },
        {
            "apiVersion": "v1",
            "data": {
                "ca.crt": "-----BEGIN CERTIFICATE-----\nMIIC/
                .
                .
                8a\ni3U=\n-----END CERTIFICATE-----\n"
            },
            "kind": "ConfigMap",
            "metadata": {
                "annotations": {
                    "kubernetes.io/description": "Contains a CA bundle that can be used to verify the kube-apiserver when using internal endpoints such as the internal service IP or kubernetes.default.svc. No other usage is guaranteed across distributions of Kubernetes clusters."
                },
                "creationTimestamp": "2022-05-08T19:32:42Z",
                "name": "kube-root-ca.crt",
                "namespace": "default",
                "resourceVersion": "424",
                "uid": "bcc4a3a4-b34a-40b0-9d26-71aeff7b4e4f"
            }
        },
        {
            "apiVersion": "v1",
            "data": {
                "nginx.conf": "\nserver {\n    listen 80;\n    server_name  netology.ru www.netology.ru;\n    access_log  /var/log/nginx/domains/netology.ru-access.log  main;\n    error_log   /var/log/nginx/domains/netology.ru-error.log info;\n    location / {\n        include proxy_params;\n        proxy_pass http://10.10.10.10:8080/;\n    }\n}\n\n"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2022-08-09T06:39:11Z",
                "name": "nginx-config",
                "namespace": "default",
                "resourceVersion": "1529",
                "uid": "11c269ca-d218-4bf3-82ea-8cb389816919"
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
```

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```
#### Ответ:
```
controlplane $ kubectl delete configmap nginx-config
configmap "nginx-config" deleted
```

```
controlplane $ date
Tue Aug  9 06:50:39 UTC 2022
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```
#### Ответ:
```
controlplane $ kubectl apply -f nginx-config.yml
configmap/nginx-config created
```
```
controlplane $ kubectl get configmaps 
NAME               DATA   AGE
domain             1      8m10s
kube-root-ca.crt   1      92d
nginx-config       1      19s
```


### Ход решения Задача 1
- [ ЛР-1. Создание стартового скрипта для создания окружения](/14.3-ConfigMap/Labs/labs-1-create-start.script.md)
- [ ЛР-2. Исследование работы Config Map. Для чего они нужны. Как создать. Как подключить. Как использовать.](/14.3-ConfigMap/Labs/labs-2-learning-configmaps.md)


### Логи
* Tab 1
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
>       - name: config
>         mountPath: /etc/nginx/conf.d
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
> cat nginx.conf
Tue Aug  9 06:38:13 UTC 2022
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
      - name: config
        mountPath: /etc/nginx/conf.d
        readOnly: true
  volumes:
  - name: config
    configMap:
      name: nginx-config

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
controlplane $ kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
```
```
controlplane $ kubectl get cm
NAME               DATA   AGE
kube-root-ca.crt   1      92d
nginx-config       1      8s
```
```
controlplane $ kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```
```
controlplane $ kubectl get cm
NAME               DATA   AGE
domain             1      4s
kube-root-ca.crt   1      92d
nginx-config       1      33s
```
 
```
controlplane $ kubectl get configmap nginx-config
NAME           DATA   AGE
nginx-config   1      57s
```
```
controlplane $ kubectl describe configmap domain
Name:         domain
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
name:
----
netology.ru

BinaryData
====

Events:  <none>
controlplane $ 
controlplane $ kubectl describe configmap nginx-config
Name:         nginx-config
Namespace:    default
Labels:       <none>
Annotations:  <none>

Data
====
nginx.conf:
----

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



BinaryData
====

Events:  <none>
```

```
controlplane $ kubectl get configmap nginx-config -o yaml
apiVersion: v1
data:
  nginx.conf: |2+

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

kind: ConfigMap
metadata:
  creationTimestamp: "2022-08-09T06:39:11Z"
  name: nginx-config
  namespace: default
  resourceVersion: "1529"
  uid: 11c269ca-d218-4bf3-82ea-8cb389816919
```
```
controlplane $ kubectl get configmap domain -o json
{
    "apiVersion": "v1",
    "data": {
        "name": "netology.ru"
    },
    "kind": "ConfigMap",
    "metadata": {
        "creationTimestamp": "2022-08-09T06:39:40Z",
        "name": "domain",
        "namespace": "default",
        "resourceVersion": "1570",
        "uid": "87a5d52a-6b32-48db-a550-c3ce35741873"
    }
}
```

```
controlplane $ kubectl get configmaps -o json > configmaps.json
```
```
controlplane $ cat configmaps.json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "name": "netology.ru"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2022-08-09T06:39:40Z",
                "name": "domain",
                "namespace": "default",
                "resourceVersion": "1570",
                "uid": "87a5d52a-6b32-48db-a550-c3ce35741873"
            }
        },
        {
            "apiVersion": "v1",
            "data": {
                "ca.crt": "-----BEGIN CERTIFICATE-----\nMIIC/
                .
                .
                8a\ni3U=\n-----END CERTIFICATE-----\n"
            },
            "kind": "ConfigMap",
            "metadata": {
                "annotations": {
                    "kubernetes.io/description": "Contains a CA bundle that can be used to verify the kube-apiserver when using internal endpoints such as the internal service IP or kubernetes.default.svc. No other usage is guaranteed across distributions of Kubernetes clusters."
                },
                "creationTimestamp": "2022-05-08T19:32:42Z",
                "name": "kube-root-ca.crt",
                "namespace": "default",
                "resourceVersion": "424",
                "uid": "bcc4a3a4-b34a-40b0-9d26-71aeff7b4e4f"
            }
        },
        {
            "apiVersion": "v1",
            "data": {
                "nginx.conf": "\nserver {\n    listen 80;\n    server_name  netology.ru www.netology.ru;\n    access_log  /var/log/nginx/domains/netology.ru-access.log  main;\n    error_log   /var/log/nginx/domains/netology.ru-error.log info;\n    location / {\n        include proxy_params;\n        proxy_pass http://10.10.10.10:8080/;\n    }\n}\n\n"
            },
            "kind": "ConfigMap",
            "metadata": {
                "creationTimestamp": "2022-08-09T06:39:11Z",
                "name": "nginx-config",
                "namespace": "default",
                "resourceVersion": "1529",
                "uid": "11c269ca-d218-4bf3-82ea-8cb389816919"
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
```

```
controlplane $ kubectl get configmap nginx-config -o yaml > nginx-config.yml
```
```
controlplane $ cat nginx-config.yml 
apiVersion: v1
data:
  nginx.conf: |2+

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

kind: ConfigMap
metadata:
  creationTimestamp: "2022-08-09T06:39:11Z"
  name: nginx-config
  namespace: default
  resourceVersion: "1529"
  uid: 11c269ca-d218-4bf3-82ea-8cb389816919
```
```
controlplane $ kubectl delete configmap nginx-config
configmap "nginx-config" deleted
```
```
controlplane $ kubectl apply -f nginx-config.yml
configmap/nginx-config created
```
```
controlplane $ kubectl get configmaps 
NAME               DATA   AGE
domain             1      8m10s
kube-root-ca.crt   1      92d
nginx-config       1      19s
```
```
controlplane $ date
Tue Aug  9 06:50:39 UTC 2022
controlplane $ 
```

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома

### Ход решения
- [ЛР-3. Поиск причин краша контейнера при запуске. Устранение ошибки CrashLoopBackOff](/14.3-ConfigMap/Labs/labs-3-current-config-pod.md)

#### Манифест пода

* cm-app-pod.yaml 

```yml
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
#### Запускаем под
```
controlplane $ kubectl apply -f cm-app-pod.yaml 
pod/netology-14.3 created
controlplane $ 
controlplane $ kubectl get po
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          102s
```
#### Заходим в контейнер и проверяем подключение Config Map в качестве Environment
```
controlplane $ kubectl exec netology-14.3 -it -- bash
[root@netology-14 /]# 
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


---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, configmaps) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

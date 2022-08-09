# Ход решения по ДЗ к занятию "14.3 Карты конфигураций"

## Задача 1: Работа с картами конфигураций через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать карту конфигураций?

```
kubectl create configmap nginx-config --from-file=nginx.conf
kubectl create configmap domain --from-literal=name=netology.ru
```

### Как просмотреть список карт конфигураций?

```
kubectl get configmaps
kubectl get configmap
```

### Как просмотреть карту конфигурации?

```
kubectl get configmap nginx-config
kubectl describe configmap domain
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get configmap nginx-config -o yaml
kubectl get configmap domain -o json
```

### Как выгрузить карту конфигурации и сохранить его в файл?

```
kubectl get configmaps -o json > configmaps.json
kubectl get configmap nginx-config -o yaml > nginx-config.yml
```

### Как удалить карту конфигурации?

```
kubectl delete configmap nginx-config
```

### Как загрузить карту конфигурации из файла?

```
kubectl apply -f nginx-config.yml
```
### Ход решения Задача 1
- [ ЛР-1. Создание стартового скрипта для создания окружения](/14.3-ConfigMap/Labs/labs-1-create-start.script.md)

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

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, configmaps) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

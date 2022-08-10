# Домашнее задание к занятию "14.3 Карты конфигураций" - Захаров Сергей Николаевич

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

## Задача 2 (*): Работа с картами конфигураций внутри модуля

Выбрать любимый образ контейнера, подключить карты конфигураций и проверить
их доступность как в виде переменных окружения, так и в виде примонтированного
тома

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, configmaps) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

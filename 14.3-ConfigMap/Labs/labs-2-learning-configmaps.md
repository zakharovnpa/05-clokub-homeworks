## - ЛР-2. Исследование работы Config Map. Для чего они нужны. Как создать. Как подключить. Как использовать.

### Задача:
1. На основек чего создаются CM
2. Что содержится в CM
3. Как используются CM

### Стартовый скрипт для создания учебной среды

* создается рабочая директория My-Project
* создаётся файл [nginx.conf](/14.3-ConfigMap/Files/nginx.conf) - для конфигурирования nginx
* создаётся файл [myapp-pod.yml](/14.3-ConfigMap/Files/myapp-pod.yml) - манифест Pod
* создаётся файл [generator.py](/14.3-ConfigMap/Files/generator.py) - для 
* создаётся файл [nginx.vhosts.jinja](/14.3-ConfigMap/Files/templates/nginx.vhosts.jinja) - шаблон для generator.py
* запускаются команды просмотра содержимого созданных файлов
```sh
date && \
mkdir -p My-Project/templates && cd My-Project && \
touch nginx.conf myapp-pod.yml generator.py templates/nginx.vhosts.jinja && \
echo "
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
" > nginx.conf && \
echo "
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
    args: [\"env; ls -la /etc/nginx/conf.d\"]
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
" > myapp-pod.yml && \
echo "
#!/usr/bin/env python3

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
" > generator.py && \
echo "
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
" > templates/nginx.vhosts.jinja && \
echo "cat templates/nginx.vhosts.jinja" && \
sleep 2 && \
cat templates/nginx.vhosts.jinja && \
echo "cat generator.py" && \
sleep 2 && \
cat generator.py && \
echo "cat myapp-pod.yml" && \
sleep 2 && \
cat myapp-pod.yml && \
echo "cat nginx.conf" && \
sleep 2 && \
cat nginx.conf && \
kubectl create configmap nginx-config --from-file=nginx.conf
```
### Ход работы
#### 1. Создание configmap из файла и просмотр содержимого
```
controlplane $ kubectl create configmap nginx-config --from-file=nginx.conf
configmap/nginx-config created
controlplane $ 
controlplane $ kubectl get configmaps 
NAME               DATA   AGE
kube-root-ca.crt   1      93d
nginx-config       1      15s
controlplane $ 
controlplane $ kubectl describe configmaps nginx-config 
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
controlplane $ 
```

```
controlplane $ kubectl get configmaps -o yaml
apiVersion: v1
items:
- apiVersion: v1
  data:
    ca.crt: |
      -----BEGIN CERTIFICATE-----
      MIIC/jCCAeagAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl
      cm5ldGVzMB4XDTIyMDUwODE5MzE1NloXDTMyMDUwNTE5MzE1NlowFTETMBEGA1UE
      AxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALHw
      NMF3o3nxCj912U6nRcOgQFV82j1KebV3nYcvXZMWVYhiqq7LG3TKGqmK0V0UCagN
      Zpx0WALCWkHPv9fJM4G3/bGTMR3y59piDisANk0Px34Q50NGBwcG2FcQOdxlnIuc
      bxzoeVi1BmA7xhHgiOPkdanwUZBEKVUiChK+k58YpFGfJPFpiwPSY4+MVabTUaJk
      5nRCLqhfjm3QmKx061u6hB8bmky4+scqGiX1XCAJrb6MHzCbJKLTp2Oqq6ItHAyJ
      r0c/onM4/5U0eZpItSJCr5XVRdTgijvOnP5mMNdDmOSiCY3l+VlC7SFkja+6M3Pn
      ZwrS0ajqcM3978/+KekCAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB
      /wQFMAMBAf8wHQYDVR0OBBYEFDpn5o08aYwKfnqJ/w1LiY0l8717MBUGA1UdEQQO
      MAyCCmt1YmVybmV0ZXMwDQYJKoZIhvcNAQELBQADggEBAEVXkQK3NN1snBOwEbYy
      Py87cO6ttB7cgwOi6f3xKHAbt9yNlX6URCaykMDx8OhtPPTDH9CiQylpYRAHNQZF
      HeCTyNh7H8FHq6QP5HEex02O1V1ClTerRDCVj5oRDkGcLurFzNla5ccdD8FXIlKZ
      m6iDk3rOqMn5C2cdS84tm21OG1bVxuL96Q7NPdJ/NDDbrm9l0CJRxHtpG9EVA/op
      0AF9AeELMGtFladczpMaE13rDxvi1wyTVN8+03p8Aln0PXM93dDwTfEDl549Kl3L
      mMn7CrQGwyJIPtmdV9E7nc7zfW5al8Wlbn41H2R5QdmdFYYCCoew12ze7p6Fgs8a
      i3U=
      -----END CERTIFICATE-----
  kind: ConfigMap
  metadata:
    annotations:
      kubernetes.io/description: Contains a CA bundle that can be used to verify the
        kube-apiserver when using internal endpoints such as the internal service
        IP or kubernetes.default.svc. No other usage is guaranteed across distributions
        of Kubernetes clusters.
    creationTimestamp: "2022-05-08T19:32:42Z"
    name: kube-root-ca.crt
    namespace: default
    resourceVersion: "424"
    uid: bcc4a3a4-b34a-40b0-9d26-71aeff7b4e4f
- apiVersion: v1
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
    creationTimestamp: "2022-08-10T02:31:32Z"
    name: nginx-config
    namespace: default
    resourceVersion: "14138"
    uid: 8818395f-8988-4188-b090-d1a02efe22c3
kind: List
metadata:
  resourceVersion: ""
```
```
controlplane $ kubectl get configmaps -o json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "ca.crt": "-----BEGIN CERTIFICATE-----\nMIIC/jCCAeagAwIBAgIBADANBgkqhkiG9w0BAQsFADAVMRMwEQYDVQQDEwprdWJl\ncm5ldGVzMB4XDTIyMDUwODE5MzE1NloXDTMyMDUwNTE5MzE1NlowFTETMBEGA1UE\nAxMKa3ViZXJuZXRlczCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALHw\nNMF3o3nxCj912U6nRcOgQFV82j1KebV3nYcvXZMWVYhiqq7LG3TKGqmK0V0UCagN\nZpx0WALCWkHPv9fJM4G3/bGTMR3y59piDisANk0Px34Q50NGBwcG2FcQOdxlnIuc\nbxzoeVi1BmA7xhHgiOPkdanwUZBEKVUiChK+k58YpFGfJPFpiwPSY4+MVabTUaJk\n5nRCLqhfjm3QmKx061u6hB8bmky4+scqGiX1XCAJrb6MHzCbJKLTp2Oqq6ItHAyJ\nr0c/onM4/5U0eZpItSJCr5XVRdTgijvOnP5mMNdDmOSiCY3l+VlC7SFkja+6M3Pn\nZwrS0ajqcM3978/+KekCAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgKkMA8GA1UdEwEB\n/wQFMAMBAf8wHQYDVR0OBBYEFDpn5o08aYwKfnqJ/w1LiY0l8717MBUGA1UdEQQO\nMAyCCmt1YmVybmV0ZXMwDQYJKoZIhvcNAQELBQADggEBAEVXkQK3NN1snBOwEbYy\nPy87cO6ttB7cgwOi6f3xKHAbt9yNlX6URCaykMDx8OhtPPTDH9CiQylpYRAHNQZF\nHeCTyNh7H8FHq6QP5HEex02O1V1ClTerRDCVj5oRDkGcLurFzNla5ccdD8FXIlKZ\nm6iDk3rOqMn5C2cdS84tm21OG1bVxuL96Q7NPdJ/NDDbrm9l0CJRxHtpG9EVA/op\n0AF9AeELMGtFladczpMaE13rDxvi1wyTVN8+03p8Aln0PXM93dDwTfEDl549Kl3L\nmMn7CrQGwyJIPtmdV9E7nc7zfW5al8Wlbn41H2R5QdmdFYYCCoew12ze7p6Fgs8a\ni3U=\n-----END CERTIFICATE-----\n"
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
                "creationTimestamp": "2022-08-10T02:31:32Z",
                "name": "nginx-config",
                "namespace": "default",
                "resourceVersion": "14138",
                "uid": "8818395f-8988-4188-b090-d1a02efe22c3"
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
controlplane $ 
```
#### 2. Создание configmap из команды и просмотр содержимого

```
controlplane $ kubectl create configmap domain --from-literal=name=netology.ru
configmap/domain created
```
```
controlplane $ kubectl get configmaps        
NAME               DATA   AGE
domain             1      11s
kube-root-ca.crt   1      93d
nginx-config       1      28m
```
```
controlplane $ kubectl describe configmaps domain 
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
```
```
controlplane $ kubectl describe configmaps nginx-config 
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
controlplane $ 
```
#### 3. При запуске пода сложилась ситуация, при которой под не запускается. Состояние - CrashLoopBackOff
* Причина - не подключены Volume
* Решение - создать PV, PVC? Вроде не надо, т.к. мы подключаем конфигмапы (по аналогии с секретами)

```
ontrolplane $ kubectl apply -f myapp-pod.yml 
pod/netology-14.3 created
controlplane $ 
controlplane $ kubectl get pod
NAME            READY   STATUS              RESTARTS   AGE
netology-14.3   0/1     ContainerCreating   0          5s
controlplane $ 
controlplane $ kubectl get pod
NAME            READY   STATUS             RESTARTS     AGE
netology-14.3   0/1     CrashLoopBackOff   1 (2s ago)   8s
controlplane $ 
controlplane $ kubectl get pod
NAME            READY   STATUS      RESTARTS      AGE
netology-14.3   0/1     Completed   3 (31s ago)   53s
controlplane $ 
controlplane $ kubectl get pod
NAME            READY   STATUS      RESTARTS      AGE
netology-14.3   0/1     Completed   3 (35s ago)   57s
controlplane $ 
controlplane $ kubectl get pod
NAME            READY   STATUS      RESTARTS      AGE
netology-14.3   0/1     Completed   3 (40s ago)   62s
controlplane $ 
controlplane $ kubectl get pod
NAME            READY   STATUS             RESTARTS      AGE
netology-14.3   0/1     CrashLoopBackOff   3 (20s ago)   68s
```

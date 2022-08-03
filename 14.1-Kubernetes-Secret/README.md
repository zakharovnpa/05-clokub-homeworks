# Домашнее задание к занятию "14.1 Создание и использование секретов" - Захаров Сергей Николаевич

#### 1. Как создать секрет?

```
openssl genrsa -out cert.key 4096
openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
kubectl create secret tls domain-cert --cert=cert.crt --key=cert.key
```
#### Ход решения
1. Генерируем файл ключа
```
controlplane $ openssl genrsa -out cert.key 4096
Generating RSA private key, 4096 bit long modulus (2 primes)
................................++++
................................................................................................++++
e is 65537 (0x010001)
```
```
controlplane $ ls
cert.key
controlplane $ 
```
![screen-cert-key](/14.1-Kubernetes-Secret/Files/screen-cert-key.png)

2. На основе ключа генерируем сертификат
```
controlplane $ openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
> -subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
```
```
controlplane $ ls
cert.crt  cert.key
```
![screen-cert-crt](/14.1-Kubernetes-Secret/Files/screen-cert-crt.png)


3. Создаем в Kubernetes Секрет tls на основе сгенерированных ключа и сертификата

```
controlplane $ kubectl create secret tls domain-cert --cert=cert.crt --key=cert.key
secret/domain-cert created
```
### 2. Как просмотреть список секретов?
```
kubectl get secrets
kubectl get secret
```
```
controlplane $ kubectl get secrets 
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      36s
controlplane $ 
controlplane $ kubectl get secrets -o yaml
```
```yml
apiVersion: v1
items:
- apiVersion: v1
  data:
    tls.crt: AAAAAABBBBBBCCCCCC
    tls.key: BBBBBBCCCCCCFFFFFF
  kind: Secret
  metadata:
    creationTimestamp: "2022-08-01T14:03:15Z"
    name: domain-cert
    namespace: default
    resourceVersion: "2486"
    uid: 9b0ae4f5-2f21-4bf0-8ab5-87c57d32cd2d
  type: kubernetes.io/tls
kind: List
metadata:
  resourceVersion: ""
```
### 3. Как просмотреть секрет?

```
kubectl get secret domain-cert
kubectl describe secret domain-cert
```
```
controlplane $ kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      12m
controlplane $ 
controlplane $ kubectl describe secret domain-cert
Name:         domain-cert
Namespace:    default
Labels:       <none>
Annotations:  <none>

Type:  kubernetes.io/tls

Data
====
tls.crt:  1944 bytes
tls.key:  3243 bytes
```
### 4. Как получить информацию в формате YAML и/или JSON?

```
kubectl get secret domain-cert -o yaml
kubectl get secret domain-cert -o json
```
```yml
controlplane $ kubectl get secret domain-cert -o yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1C
  tls.key: LS0tLS1CRUdJTiBSU0EgU  
kind: Secret
metadata:
  creationTimestamp: "2022-08-01T14:03:15Z"
  name: domain-cert
  namespace: default
  resourceVersion: "2486"
  uid: 9b0ae4f5-2f21-4bf0-8ab5-87c57d32cd2d
type: kubernetes.io/tls
```
```json
{
    "apiVersion": "v1",
    "data": {
        "tls.crt": "LS0tLS1CRUd
        "tls.key": "LS0tLS1CRUdJTiBSU0EgUFJ
    },
    "kind": "Secret",
    "metadata": {
        "creationTimestamp": "2022-08-01T14:03:15Z",
        "name": "domain-cert",
        "namespace": "default",
        "resourceVersion": "2486",
        "uid": "9b0ae4f5-2f21-4bf0-8ab5-87c57d32cd2d"
    },
    "type": "kubernetes.io/tls"
}
        
```
### 5. Как выгрузить секрет и сохранить его в файл?
```
kubectl get secrets -o json > secrets.json
kubectl get secret domain-cert -o yaml > domain-cert.yml
```
```
controlplane $ kubectl get secrets -o json > secrets.json
controlplane $ 
controlplane $ kubectl get secret domain-cert -o yaml > domain-cert.yml
controlplane $ 
controlplane $ ls -l
total 24
-rw-r--r-- 1 root root 1944 Aug  1 13:55 cert.crt
-rw------- 1 root root 3243 Aug  1 13:52 cert.key
-rw-r--r-- 1 root root 7163 Aug  1 14:22 domain-cert.yml
-rw-r--r-- 1 root root 7546 Aug  1 14:21 secrets.json
controlplane $ 
```
### 5. Как удалить секрет?
```
kubectl delete secret domain-cert
```
```
controlplane $ kubectl delete secret domain-cert
secret "domain-cert" deleted
controlplane $ 
controlplane $ kubectl get secret domain-cert        
Error from server (NotFound): secrets "domain-cert" not found
```
### 6. Как загрузить секрет из файла?
```
kubectl apply -f domain-cert.yml
```
```
controlplane $ kubectl apply -f domain-cert.yml
secret/domain-cert created
controlplane $ 
controlplane $ kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      4s
```

## Задача 2 (*): Работа с секретами внутри модуля

Выберите любимый образ контейнера, подключите секреты и проверьте их доступность
как в виде переменных окружения, так и в виде примонтированного тома.

### Ход решения

#### 1. С помощью [скрипта](/14.1-Kubernetes-Secret/Files/script-start-environment.sh) развернули в кластере окружение
```
controlplane $ kubectl get pod
NAME                                  READY   STATUS    RESTARTS   AGE
busybox-pod-69b6cdf8b4-2986x          2/2     Running   0          33m
secret-busybox-pod-6fc569f94b-r5z7f   2/2     Running   0          25m
```
```
controlplane $ kubectl get svc
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
busybox-pod   NodePort    10.104.73.243   <none>        80:30092/TCP   34m
kubernetes    ClusterIP   10.96.0.1       <none>        443/TCP        86d
```
```
controlplane $ kubectl get secrets 
NAME        TYPE     DATA   AGE
user-cred   Opaque   2      36m
```
```
controlplane $ kubectl get deployments.apps 
NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
busybox-pod          1/1     1            1           34m
secret-busybox-pod   1/1     1            1           25m
```
#### 2. Проверяем доступность секрета через env
```
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c one-busybox               
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
/ # 
/ # echo $SUPER_USER
YWRtaW4K
/ # 
/ # echo $PASS_W
cGFzc3dvcmQK
/ # 
/ # exit
controlplane $ 
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c two-busybox
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
/ # 
/ # echo $SUPER_USER
YWRtaW4K
/ # 
/ # echo $PASS_W
cGFzc3dvcmQK
/ # 
/ # exit
controlplane $ 
```
* Скриншот доступности секрета через env

![screen-secret-pod-in-env](/14.1-Kubernetes-Secret/Files/screen-secret-pod-in-env.png)

#### 2. Проверяем доступность секрета через volume
```
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c one-busybox -- ls -l static       
total 0
lrwxrwxrwx    1 root     root            19 Aug  3 13:33 password.txt -> ..data/password.txt
lrwxrwxrwx    1 root     root            19 Aug  3 13:33 username.txt -> ..data/username.txt
controlplane $ 
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c one-busybox -- cat static/username.txt
‘admin’
controlplane $ 
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c one-busybox -- cat static/password.txt
‘password’
controlplane $ 
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c two-busybox -- ls -l tmp/cache
total 0
lrwxrwxrwx    1 root     root            19 Aug  3 13:33 password.txt -> ..data/password.txt
lrwxrwxrwx    1 root     root            19 Aug  3 13:33 username.txt -> ..data/username.txt
controlplane $ 
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c two-busybox -- cat tmp/cache/username.txt
‘admin’
controlplane $ 
controlplane $ kubectl exec secret-busybox-pod-6fc569f94b-r5z7f -it sh -c two-busybox -- cat tmp/cache/password.txt
‘password’
```
* Скриншот доступности секрета через volume

![screen-secret-pod-in-volume](/14.1-Kubernetes-Secret/Files/screen-secret-pod-in-volume.png)


---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (deployments, pods, secrets) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

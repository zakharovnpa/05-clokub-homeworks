## ЛР - 2 по теме 14.1 "Создание и использование секретов"

## Задача 1: Работа с секретами через утилиту kubectl в установленном minikube

Выполните приведённые ниже команды в консоли, получите вывод команд. Сохраните
задачу 1 как справочный материал.


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

2. На основе ключа гегерируем сертификат
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

### Ход решения:

* Выберите любимый образ контейнера, например, BusyBox
* подключите секреты. Это значит пересобрать контейнер с переменными окружения 
* Создать Dockerfile
  * `ENV SUPER_USER: YWRtaW4K`
  * `ENV PASS_W: cGFzc3dvcmQK`
  * `ENV DATABASE_URL=postgres://postgres:postgres@db:5432/news`
* проверьте их доступность
  * экспортировать переменные в файл `bashrc` 
  * как в виде переменных окружения,  - вывод команды env. В этом случае указать в файле secret.yml эти переменные окружения с логином и паролем
  * так и в виде примонтированного тома. - показать файл секрета. Монтировать только как eptydir. Это позволит хранить секреты в оперативной памяти, а не на диске

#### 1. Сборка образа и его загрузка в реджистри описан здесь:
- [ЛР-3. "Подготовка образа для задачи 2*."](/14.1-Kubernetes-Secret/Labs/labs-3-docker-image.md)

####  Имя образа `zakharovnpa/k8s-busybox:02.08.22`

#### 2. Подготовка манифеста для разворачивания приложения в кластере

* pod.yaml
```yml
cat pod.yml 
apiVersion: v1
kind: Pod
metadata:
  name: pod-learn-secret
spec:
  containers:
  - name: busybox
    image: zakharovnpa/k8s-busybox:02.08.22
    volumeMounts:
    - mountPath: "/tmp/cache"
      name: my-volume
  volumes:
    - name: my-volume
      emptyDir: {}
```
#### Логи

```
controlplane $ kubectl get po
NAME               READY   STATUS    RESTARTS   AGE
pod-learn-secret   1/1     Running   0          16s
```
```
controlplane $ kubectl exec pod-learn-secret -it sh -- env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=pod-learn-secret
SUPER_USER=YWRtaW4K
PASS_W=cGFzc3dvcmQK
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_SERVICE_PORT=443
TERM=xterm
HOME=/root
```
* Пустые ответы содержания переменных
```
controlplane $ kubectl exec pod-learn-secret -it sh -- echo $SUPER_USER

controlplane $ 
controlplane $ kubectl exec pod-learn-secret -it sh -- echo $PASS_W    

```
* Показаны переменные и их содержимое
```
controlplane $ kubectl exec pod-learn-secret -it sh                
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
/ # 
/ # env
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_SERVICE_PORT=443
HOSTNAME=pod-learn-secret
SHLVL=1
HOME=/root
PASS_W=cGFzc3dvcmQK
TERM=xterm
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
KUBERNETES_PORT_443_TCP_PORT=443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_SERVICE_HOST=10.96.0.1
PWD=/
SUPER_USER=YWRtaW4K
/ # 
/ # 
/ # echo $SUPER_USER
YWRtaW4K
/ # 
/ # echo $PASS_W
cGFzc3dvcmQK
/ # 
/ # 
```

#### secret.yaml
```yml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  superuser: $SUPER_USER
  password: $PASS_W
#  superuser: YWRtaW4K
#  password: cGFzc3dvcmQK
```

#### Экспорт переменых
```
echo 'export SUPER_USER="YWRtaW4K"' >> ~/.bashrc

echo 'export PASS_W="cGFzc3dvcmQK"' >> ~/.bashrc
```

#### Пример из лекции монтирования секрета
```
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
```



---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (deployments, pods, secrets) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

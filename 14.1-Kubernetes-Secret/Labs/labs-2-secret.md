## ЛР - 2 по теме 14.1 "Создание и использование секретов"



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

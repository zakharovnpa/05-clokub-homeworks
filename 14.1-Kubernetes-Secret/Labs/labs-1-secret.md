### ДЗ по теме 14.1 "Создание и использование секретов"

* Tab 1
```
controlplane $ mkdir -p My-Project
controlplane $ 
controlplane $ cd My-Project/
```
```
controlplane $ echo 'user' > username.txt 
controlplane $ 
controlplane $ echo 'admin' > password.txt
```
```
controlplane $ kubectl create secret generic user-cred \--from-file=./username.txt --from-file=./password.txt
secret/user-cred created
```
```
controlplane $ kubectl get secrets 
NAME        TYPE     DATA   AGE
user-cred   Opaque   2      17s
```
```
controlplane $ kubectl get secrets -o wide
NAME        TYPE     DATA   AGE
user-cred   Opaque   2      69s
```
* # controlplane $ kubectl get secrets -o yaml
```yml
apiVersion: v1
items:
- apiVersion: v1
  data:
    password.txt: YWRtaW4K
    username.txt: dXNlcgo=
  kind: Secret
  metadata:
    creationTimestamp: "2022-07-27T17:08:55Z"
    name: user-cred
    namespace: default
    resourceVersion: "4738"
    uid: b399c4b4-3639-43fb-8a0a-3ec9ee8fd134
  type: Opaque
kind: List
metadata:
  resourceVersion: ""
```
```
controlplane $ kubectl create namespace stage
namespace/stage created
```
```
controlplane $ kubectl -n stage create secret generic user-cred \--from-file=./username.txt --from-file=./password.txt
secret/user-cred created
```
```
controlplane $ kubectl -n stage create secret generic user-cred-2 \--from-file=./username.txt --from-file=./password.txt
secret/user-cred-2 created
```
```
controlplane $ kubectl -n stage get secrets 
NAME          TYPE     DATA   AGE
user-cred     Opaque   2      48s
user-cred-2   Opaque   2      34s
```
```
* controlplane $ kubectl -n stage get secrets -o yaml
```yml
apiVersion: v1
items:
- apiVersion: v1
  data:
    password.txt: YWRtaW4K
    username.txt: dXNlcgo=
  kind: Secret
  metadata:
    creationTimestamp: "2022-07-27T17:11:52Z"
    name: user-cred
    namespace: stage
    resourceVersion: "4969"
    uid: d3ebc1b5-78aa-4b06-81c0-ee01a60b5ee8
  type: Opaque
- apiVersion: v1
  data:
    password.txt: YWRtaW4K
    username.txt: dXNlcgo=
  kind: Secret
  metadata:
    creationTimestamp: "2022-07-27T17:12:06Z"
    name: user-cred-2
    namespace: stage
    resourceVersion: "4987"
    uid: aa59446a-b230-4161-8189-e9dcbb709893
  type: Opaque
kind: List
metadata:
  resourceVersion: ""
```
* Tab 2

```
openssl genrsa -out cert.key 4096
```
```
openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
```
```
kubectl create secret tls domain-cert --cert=cert.crt --key=cert.key
secret/domain-cert created
```
```
controlplane $ ls -lha
total 16K
drwxr-xr-x 2 root root 4.0K Jul 27 17:48 .
drwx------ 6 root root 4.0K Jul 27 17:47 ..
-rw-r--r-- 1 root root 1.9K Jul 27 17:48 cert.crt
-rw------- 1 root root 3.2K Jul 27 17:47 cert.key
```
#### Ход выполнения
```
controlplane $ date
Wed Jul 27 18:00:04 UTC 2022
controlplane $ 
controlplane $ kubectl get secrets
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      10m
controlplane $ kubectl get secret
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      10m
```
```
controlplane $ kubectl get secret domain-cert
NAME          TYPE                DATA   AGE
domain-cert   kubernetes.io/tls   2      10m
```
```
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
controlplane $ 
controlplane $ kubectl get secret domain-cert -o yaml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUdJTiB
  tls.key: LS0tLS1CRUdJTiBS
kind: Secret
metadata:
  creationTimestamp: "2022-07-27T17:49:41Z"
  name: domain-cert
  namespace: default
  resourceVersion: "3368"
  uid: 599cc3dd-89be-42e5-ae07-0016456fb975
type: kubernetes.io/tls
```
```
controlplane $ kubectl get secret domain-cert -o json
```
```json
{
    "apiVersion": "v1",
    "data": {
        "tls.crt": "LS0tLS1CNBIFBSSVZBVEUgS0VZLS0tLS0K"
    },
    "kind": "Secret",
    "metadata": {
        "creationTimestamp": "2022-07-27T17:49:41Z",
        "name": "domain-cert",
        "namespace": "default",
        "resourceVersion": "3368",
        "uid": "599cc3dd-89be-42e5-ae07-0016456fb975"
    },
    "type": "kubernetes.io/tls"
}
```
```
controlplane $ kubectl get secrets -o json > secrets.json
```
```
controlplane $ kubectl get secret domain-cert -o yaml > domain-cert.yml
```
```
controlplane $ ls -lha
total 32K
drwxr-xr-x 2 root root 4.0K Jul 27 18:01 .
drwx------ 6 root root 4.0K Jul 27 17:47 ..
-rw-r--r-- 1 root root 1.9K Jul 27 17:48 cert.crt
-rw------- 1 root root 3.2K Jul 27 17:47 cert.key
-rw-r--r-- 1 root root 7.0K Jul 27 18:01 domain-cert.yml
-rw-r--r-- 1 root root 7.4K Jul 27 18:01 secrets.json
```
```
controlplane $ cat domain-cert.yml 
```
```yml
apiVersion: v1
data:
  tls.crt: LS0tLS1CRUDQVRFLS0tLS0K
  tls.key: LS0tLS1CRUpGSUthVFNLOExzd0NPZGNRCn
kind: Secret
metadata:
  creationTimestamp: "2022-07-27T17:49:41Z"
  name: domain-cert
  namespace: default
  resourceVersion: "3368"
  uid: 599cc3dd-89be-42e5-ae07-0016456fb975
type: kubernetes.io/tls
```
```
controlplane $ cat secrets.json 
```
```json
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "data": {
                "tls.crt": "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZiVENDQ
                TFXZ0F3SUJBZtLS0K",
                "tls.key": "LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS
                1FJQkFBS0NBZ0VBclVuY
                VZBVEUgS0VZLS0tLS0K"
            },
            "kind": "Secret",
            "metadata": {
                "creationTimestamp": "2022-07-27T17:49:41Z",
                "name": "domain-cert",
                "namespace": "default",
                "resourceVersion": "3368",
                "uid": "599cc3dd-89be-42e5-ae07-0016456fb975"
            },
            "type": "kubernetes.io/tls"
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": ""
    }
}
```
```
controlplane $ kubectl delete secret domain-cert
secret "domain-cert" deleted
```
```
controlplane $ ls -lha
total 32K
drwxr-xr-x 2 root root 4.0K Jul 27 18:01 .
drwx------ 6 root root 4.0K Jul 27 17:47 ..
-rw-r--r-- 1 root root 1.9K Jul 27 17:48 cert.crt
-rw------- 1 root root 3.2K Jul 27 17:47 cert.key
-rw-r--r-- 1 root root 7.0K Jul 27 18:01 domain-cert.yml
-rw-r--r-- 1 root root 7.4K Jul 27 18:01 secrets.json
```
```
controlplane $ kubectl describe secret domain-cert
Error from server (NotFound): secrets "domain-cert" not found
```
```
controlplane $ kubectl apply -f domain-cert.yml
secret/domain-cert created
```
```
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




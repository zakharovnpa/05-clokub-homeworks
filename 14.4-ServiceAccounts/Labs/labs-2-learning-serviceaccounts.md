### ЛР-2 Изучение работы сервисаккаунтов. 

От препродавателя Андрюнина Сергея
- [Ссылка на репозиторий](https://github.com/hamnsk/k8s/blob/main/serviceaccount.md)

# Создаем пользователя с доступом только в неймспейс (пользователи)

## 1. Переменные среды
Для того чтобы нам было удобно работать с нашими скриптами и командами определим ряд переменных среды:
укажем имя пользователя, неймспейс, и название роли которую будем создавать

```shell script
$ ACCOUNT_NAME=petya
$ NAMESPACE=netology
$ ROLENAME=read-exec-pods-svc-ing
```

Создадим неймспейс

```shell script
$ kubectl create ns $NAMESPACE
```
### Ход решения
* Создаем переменные окружения:

```shell script
ACCOUNT_NAME=kraken
NAMESPACE=netology-svc-demo
ROLENAME=read-exec-pods-svc-ing
```
```
controlplane $ ACCOUNT_NAME=kraken
controlplane $ 
controlplane $ NAMESPACE=netology-svc-demo
controlplane $ 
controlplane $ ROLENAME=read-exec-pods-svc-ing
controlplane $ echo $ACCOUNT_NAME
kraken
controlplane $ 
controlplane $ echo $NAMESPACE
netology-svc-demo
controlplane $ 
controlplane $ echo $ROLENAME
read-exec-pods-svc-ing
```
* Создаем неймспейс

```shell script
kubectl create ns $NAMESPACE
```
## 2. Создаем конфиг для подключение к кластеру

Создадим сервисаккаунт

```shell script
$ kubectl create serviceaccount $ACCOUNT_NAME --namespace $NAMESPACE
```
 
Подготовим дополнительные переменные среды, запускаем команды последовательно

```shell script
$ TOKEN_NAME=$(kubectl get serviceAccounts $ACCOUNT_NAME --namespace $NAMESPACE  -o jsonpath="{.secrets[0].name}") 
$ TOKEN=$(kubectl describe secrets $TOKEN_NAME --namespace $NAMESPACE | grep 'token:' | rev | cut -d ' ' -f1 | rev)
$ CERTIFICATE_AUTHORITY_DATA=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].cluster.certificate-authority-data}")
$ SERVER_URL=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].cluster.server}")
$ CLUSTER_NAME=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].name}")
```

Запишем итоговый конфиг в файл
```shell script
$ cat <<EOF > $CLUSTER_NAME-$ACCOUNT_NAME-kube.conf
apiVersion: v1
kind: Config
users:
- name: $ACCOUNT_NAME
  user:
    token: $TOKEN
clusters:
- cluster:
    certificate-authority-data: $CERTIFICATE_AUTHORITY_DATA    
    server: $SERVER_URL
  name: $CLUSTER_NAME
contexts:
- context:
    cluster: $CLUSTER_NAME
    user: $ACCOUNT_NAME
  name: $CLUSTER_NAME-$ACCOUNT_NAME-context
current-context: $CLUSTER_NAME-$ACCOUNT_NAME-context
EOF
```

Проверим появился ли у нас доступ к нашему кластеру

```shell script
$ kubectl --kubeconfig=$CLUSTER_NAME-$ACCOUNT_NAME-kube.conf get po -n $NAMESPACE
```
Мы получим ошибку, потому что у нас нет роли и связки этой роли с сервисаккаунтом

> Error from server (Forbidden): pods is forbidden: User "system:serviceaccount:firstnamespace:test-service-account" cannot list resource "pods" in API group "" in the namespace "firstnamespace"

### Ход решения

* Создадим сервисаккаунт

```shell script
kubectl create serviceaccount $ACCOUNT_NAME --namespace $NAMESPACE
```
* Результат:

```
controlplane $ kubectl create serviceaccount $ACCOUNT_NAME --namespace $NAMESPACE
serviceaccount/kraken created
controlplane $ 
controlp
controlplane $ kubectl get serviceaccounts 
NAME      SECRETS   AGE
default   0         95d
controlplane $ 
controlplane $ kubectl -n $NAMESPACE get serviceaccounts 
NAME      SECRETS   AGE
default   0         2m59s
kraken    0         61s
```

* Подготовим дополнительные переменные среды, запускаем команды последовательно

```shell script
TOKEN_NAME=$(kubectl get serviceAccounts $ACCOUNT_NAME --namespace $NAMESPACE  -o jsonpath="{.secrets[0].name}") 
TOKEN=$(kubectl describe secrets $TOKEN_NAME --namespace $NAMESPACE | grep 'token:' | rev | cut -d ' ' -f1 | rev)
CERTIFICATE_AUTHORITY_DATA=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].cluster.certificate-authority-data}")
SERVER_URL=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].cluster.server}")
CLUSTER_NAME=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].name}")
```
* Результат: переменная TOKEN_NAME не создалась, т.к. не созданы секреты и не ттокена

```
controlplane $ TOKEN_NAME=$(kubectl get serviceAccounts $ACCOUNT_NAME --namespace $NAMESPACE  -o jsonpath="{.secrets[0].name}") 
controlplane $ 
controlplane $ echo $TOKEN_NAME

controlplane $ kubectl get serviceAccounts $ACCOUNT_NAME --namespace $NAMESPACE
NAME     SECRETS   AGE
kraken   0         5m33s
controlplane $ 
```
* Нет секретов. Надо пойти в секреты и посмотреть. Если его нет, то надо создать

```
controlplane $ kubectl get serviceAccounts $ACCOUNT_NAME --namespace $NAMESPACE -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2022-08-12T03:04:24Z",
        "name": "kraken",
        "namespace": "netology-svc-demo",
        "resourceVersion": "8130",
        "uid": "b2ed47ac-2de0-461f-96a9-a0a74d3a11bd"
    }
}
controlplane $ 
controlplane $ 
controlplane $ kubectl get serviceAccounts $ACCOUNT_NAME --namespace $NAMESPACE -o jsonpath="{.secrets[0].name}"
controlplane $ 
controlplane $ kubectl get serviceaccounts -n $NAMESPACE kraken -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-08-12T03:04:24Z"
  name: kraken
  namespace: netology-svc-demo
  resourceVersion: "8130"
  uid: b2ed47ac-2de0-461f-96a9-a0a74d3a11bd
controlplane $ 
controlplane $ 
controlplane $ kubectl describe serviceaccounts -n $NAMESPACE kraken        
Name:                kraken
Namespace:           netology-svc-demo
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              <none>
Events:              <none>
controlplane $ 

```
* Создание секрета

```
openssl genrsa -out cert.key 4096 

openssl req -x509 -new -key cert.key -days 3650 -out cert.crt \
-subj '/C=RU/ST=Moscow/L=Moscow/CN=server.local'
kubectl create secret tls domain-cert --cert=cert.crt --key=cert.key
```



## 3. Создаем роль

```shell script
$ cat <<EOF > $ROLENAME-role.yaml ; kubectl apply -f $ROLENAME-role.yaml -n $NAMESPACE
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $NAMESPACE
  name: $ROLENAME
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log", "services", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch", "describe"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
- apiGroups: ["extensions"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
EOF
```

## 4. Создаем РольБиндинг и связываем нашу роль с сервисаккаунтом

```shell script
$ cat <<EOF > $ROLENAME-rolebinding.yaml ; kubectl apply -f $ROLENAME-rolebinding.yaml -n $NAMESPACE
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $ACCOUNT_NAME-$ROLENAME-rolebinding
  namespace: $NAMESPACE
subjects:
- kind: User
  name: system:serviceaccount:$NAMESPACE:$ACCOUNT_NAME # Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #this must be Role or ClusterRole
  name: $ROLENAME # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
EOF
```

## 5. Тестируем доступ в кластер

```shell script
$ kubectl --kubeconfig=$CLUSTER_NAME-$ACCOUNT_NAME-kube.conf get po -n $NAMESPACE
```

Готово!

---

# Создаем кластерную роль, доступ ко всем неймспейсам (админы)

## 1. Переменные среды

```shell script
$ ACCOUNT_NAME=vasya
$ ROLENAME=read-exec-pods-svc-ing-global
```

## 2. Создаем конфиг для подключение к кластеру

Создадим сервисаккаунт

```shell script
$ kubectl create serviceaccount $ACCOUNT_NAME
```
 
Подготовим дополнительные переменные среды, запускаем команды последовательно


```shell script
$ TOKEN_NAME=$(kubectl get serviceAccounts $ACCOUNT_NAME  -o jsonpath="{.secrets[0].name}")
$ TOKEN=$(kubectl describe secrets $TOKEN_NAME  | grep 'token:' | rev | cut -d ' ' -f1 | rev)
$ CERTIFICATE_AUTHORITY_DATA=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].cluster.certificate-authority-data}")
$ SERVER_URL=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].cluster.server}")
$ CLUSTER_NAME=$(kubectl config view --flatten --minify -o jsonpath="{.clusters[0].name}")
```
Запишем итоговый конфиг в файл
```shell script
cat <<EOF > $CLUSTER_NAME-$ACCOUNT_NAME-kube.conf
apiVersion: v1
kind: Config
users:
- name: $ACCOUNT_NAME
  user:
    token: $TOKEN
clusters:
- cluster:
    certificate-authority-data: $CERTIFICATE_AUTHORITY_DATA    
    server: $SERVER_URL
  name: $CLUSTER_NAME
contexts:
- context:
    cluster: $CLUSTER_NAME
    user: $ACCOUNT_NAME
  name: $CLUSTER_NAME-$ACCOUNT_NAME-context
current-context: $CLUSTER_NAME-$ACCOUNT_NAME-context
EOF
```

## 3. Создаем кластерную роль

```shell script
cat <<EOF > $ROLENAME-role.yaml ; kubectl apply -f $ROLENAME-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  namespace: $NAMESPACE
  name: $ROLENAME
rules:
- apiGroups: [""]
  resources: ["pods", "pods/log", "services", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch", "describe"]
- apiGroups: [""]
  resources: ["pods/exec"]
  verbs: ["create"]
- apiGroups: ["extensions"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
EOF
```

## 4. Создаем КластерРольБиндинг и связываем нашу кластерную роль с сервисаккаунтом

```shell script
$ cat <<EOF > $ROLENAME-rolebinding.yaml ; kubectl apply -f $ROLENAME-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $ACCOUNT_NAME-$ROLENAME-rolebinding
subjects:
- kind: User
  name: system:serviceaccount:default:$ACCOUNT_NAME # default it is namaspase
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole #this must be Role or ClusterRole
  name: $ROLENAME # this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
EOF
```


## 5. Тестируем доступ в кластер

```shell script
$ kubectl --kubeconfig=$CLUSTER_NAME-$ACCOUNT_NAME-kube.conf get po -A
```

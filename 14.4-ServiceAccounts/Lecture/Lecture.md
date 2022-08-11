## Лекция по теме "Сервис-аккаунты"

Сергей
Андрюнин

### 2Сергей Андрюнин
DevOps-инженер
RTLabs

### 3План занятия
1. Общие сведения о сервис-аккаунтах
2. Использование
3. Итоги
4. Домашнее задание

### 4Общие сведения о сервис-аккаунтах

### 5Общие сведения о сервис-аккаунтах
- предназначены для предоставления токена контейнеру,
который сможет получить доступ к API kubernetes;
- в каждом неймспейсе есть свой сервис-аккаунт default,
который создаётся с самим неймспейсом;
- у каждого сервис-аккаунта есть токен;
- токен сервис-аккаунта хранится в объекте secrets.

### 6Общие сведения о сервис-аккаунтах
Предназначены для предоставления токена контейнеру, который
сможет получить доступ к API kubernetes:
- пользовательский аккаунт отличается от сервис-аккаунта тем,
что сервис-аккаунт используется непосредственно сервисами;
- монтируется внутри контейнера в подкаталог

       /var/run/secrets/kubernetes.io/serviceaccount.
- В этом подкаталоге будет лежать три файла:
  - ca.crt
  - namespace
  - token
- Если мы найдем эти три файла, значит мы работаем в Kubernetes  
- По этому пути мы можем ходить и читать данные для предоставления их 
тем приложениям, которые взаимодействуют с кубрнетисом.
```
ontrolplane $ kubectl logs netology-14.5 
total 4
drwxrwxrwt 3 root root  140 Aug 11 07:59 .
drwxr-xr-x 3 root root 4096 Aug 11 07:59 ..
drwxr-xr-x 2 root root  100 Aug 11 07:59 ..2022_08_11_07_59_45.1666067405
lrwxrwxrwx 1 root root   32 Aug 11 07:59 ..data -> ..2022_08_11_07_59_45.1666067405
lrwxrwxrwx 1 root root   13 Aug 11 07:59 ca.crt -> ..data/ca.crt
lrwxrwxrwx 1 root root   16 Aug 11 07:59 namespace -> ..data/namespace
lrwxrwxrwx 1 root root   12 Aug 11 07:59 token -> ..data/token
```


### 7Использование

### 8Создание, просмотр и удаление
Создание:

    kubectl create serviceaccount netology

Просмотр:

    kubectl get serviceaccount netology

Удаление:

    kubectl delete serviceaccount netology

### 9Переменные среды

    # env | grep KUBE
    KUBERNETES_SERVICE_PORT_HTTPS=443
    KUBERNETES_SERVICE_PORT=443
    KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
    KUBERNETES_PORT_443_TCP_PROTO=tcp
    KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
    KUBERNETES_SERVICE_HOST=10.96.0.1
    KUBERNETES_PORT=tcp://10.96.0.1:443
    KUBERNETES_PORT_443_TCP_PORT=443

### 10Переменные для удобства
Доступ к API осуществляется через протокол HTTPS. Это накладывает
требование обязательной сертификации и наличия корневого
сертификата.
Т.к. в большинстве случаев сертификат является самоподписанным,
то kubernetes великодушно предоставляет нам корневой сертификат
в виде файла ca.crt

    K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
    SADIR=/var/run/secrets/kubernetes.io/serviceaccount
    TOKEN=$(cat $SADIR/token)
    CACERT=$SADIR/ca.crt
    NAMESPACE=$(cat $SADIR/namespace)

### 11Пример запроса

    curl -H "Authorization: Bearer $TOKEN" \
    --cacert $CACERT $K8S/api/v1/
    
### 12CRUD
- CREATE – создание;
- READ – чтение;
- UPDATE – обновление;
- DELETE – удаление.

### 13HTTP API REST
- CREATE – POST;
- READ – GET;
- UPDATE –PATCH/PUT;
- DELETE – DELETE.

### 14YAML ServiceAccount
```yml
---
apiVersion: v1
kind: ServiceAccount
metadata:
creationTimestamp: "2021-06-15T10:14:29Z"
name: netology
namespace: default
resourceVersion: "20692"
selfLink:
/api/v1/namespaces/default/serviceaccounts/netology
uid: ff39cc45-7c2d-4933-a992-915735bcb64a
secrets:
- name: netology-token-rpthf
```

### 15YAML Pod
```yml
---
apiVersion: v1
kind: Pod
metadata:
name: netology-14.4
spec:
containers:
- name: myapp
image: fedora:latest
command: ['ls', '-la',
'/var/run/secrets/kubernetes.io/serviceaccount']
serviceAccountName: netology
```

### 13Итоги
Сегодня мы изучили:
- что такое сервис аккаунты;
- как их создавать и использовать в kubernetes.

### 16Домашнее задание
Давайте посмотрим ваше домашнее задание.
- Вопросы по домашней работе задавайте в чате мессенджера .
- Задачи можно сдавать по частям.
- Зачёт по домашней работе проставляется после того, как приняты
все задачи.

### 17Задавайте вопросы и
пишите отзыв о лекции!
Сергей Андрюнин

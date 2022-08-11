## Ход выполнения ДЗ к занятию "14.4 Сервис-аккаунты"

## Задача 1: Работа с сервис-аккаунтами через утилиту kubectl в установленном minikube

Выполните приведённые команды в консоли. Получите вывод команд. Сохраните
задачу 1 как справочный материал.

### Как создать сервис-аккаунт?

```
kubectl create serviceaccount netology
```
#### Ответ:
```
controlplane $ kubectl create serviceaccount netology
serviceaccount/netology created
```

### Как просмотреть список сервис-акаунтов?

```
kubectl get serviceaccounts
kubectl get serviceaccount
```
#### Ответ:
```
controlplane $ 
controlplane $ kubectl get serviceaccounts 
NAME       SECRETS   AGE
default    0         94d
netology   0         20s
controlplane $ 
controlplane $ kubectl describe serviceaccounts netology 
Name:                netology
Namespace:           default
Labels:              <none>
Annotations:         <none>
Image pull secrets:  <none>
Mountable secrets:   <none>
Tokens:              <none>
Events:              <none>
```

### Как получить информацию в формате YAML и/или JSON?

```
kubectl get serviceaccount netology -o yaml
kubectl get serviceaccount default -o json
```
#### Ответ:
```
controlplane $ kubectl get serviceaccount netology -o yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-08-11T03:51:59Z"
  name: netology
  namespace: default
  resourceVersion: "22130"
  uid: ce997a02-91cc-4ad2-b8bb-4f3e64864e2f
```
```
controlplane $ kubectl get serviceaccount default -o json
{
    "apiVersion": "v1",
    "kind": "ServiceAccount",
    "metadata": {
        "creationTimestamp": "2022-05-08T19:32:41Z",
        "name": "default",
        "namespace": "default",
        "resourceVersion": "404",
        "uid": "838f4de4-1e99-43c0-81ac-35e48730d289"
    }
}
```

### Как выгрузить сервис-акаунты и сохранить его в файл?

```
kubectl get serviceaccounts -o json > serviceaccounts.json
kubectl get serviceaccount netology -o yaml > netology.yml
```
#### Ответ:
```
controlplane $ kubectl get serviceaccounts -o json > serviceaccounts.json
controlplane $ 
controlplane $ cat serviceaccounts.json 
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "v1",
            "kind": "ServiceAccount",
            "metadata": {
                "creationTimestamp": "2022-05-08T19:32:41Z",
                "name": "default",
                "namespace": "default",
                "resourceVersion": "404",
                "uid": "838f4de4-1e99-43c0-81ac-35e48730d289"
            }
        },
        {
            "apiVersion": "v1",
            "kind": "ServiceAccount",
            "metadata": {
                "creationTimestamp": "2022-08-11T03:51:59Z",
                "name": "netology",
                "namespace": "default",
                "resourceVersion": "22130",
                "uid": "ce997a02-91cc-4ad2-b8bb-4f3e64864e2f"
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
controlplane $ kubectl get serviceaccount netology -o yaml > netology.yml
controlplane $ 
controlplane $ cat netology.yml 
apiVersion: v1
kind: ServiceAccount
metadata:
  creationTimestamp: "2022-08-11T03:51:59Z"
  name: netology
  namespace: default
  resourceVersion: "22130"
  uid: ce997a02-91cc-4ad2-b8bb-4f3e64864e2f
```
### Как удалить сервис-акаунт?

```
kubectl delete serviceaccount netology
```
#### Ответ:
```
controlplane $ kubectl delete serviceaccount netology
serviceaccount "netology" deleted
```
### Как загрузить сервис-акаунт из файла?

```
kubectl apply -f netology.yml
```

#### Ответ:
```
controlplane $ kubectl apply -f netology.yml
serviceaccount/netology created
```

## Задача 2 (*): Работа с сервис-акаунтами внутри модуля

Выбрать любимый образ контейнера, подключить сервис-акаунты и проверить
доступность API Kubernetes

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Просмотреть переменные среды

```
env | grep KUBE
```

Получить значения переменных

```
K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
SADIR=/var/run/secrets/kubernetes.io/serviceaccount
TOKEN=$(cat $SADIR/token)
CACERT=$SADIR/ca.crt
NAMESPACE=$(cat $SADIR/namespace)
```

Подключаемся к API

```
curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
```

В случае с minikube может быть другой адрес и порт, который можно взять здесь

```
cat ~/.kube/config
```

или здесь

```
kubectl cluster-info
```
- [ЛР-3. Запуск пода с командами и просмотр результатов выполнения команд.](/14.4-ServiceAccounts/Labs/labs-3-how-start-pod-with-command.md)
---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, serviceaccounts) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

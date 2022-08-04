# Домашнее задание к занятию "14.2 Синхронизация секретов с внешними сервисами. Vault" - Захаров Сергей Николаевич

## Задача 1: Работа с модулем Vault

Запустить модуль Vault конфигураций через утилиту kubectl в установленном minikube

```
kubectl apply -f 14.2/vault-pod.yml
```

Получить значение внутреннего IP пода

```
kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
```

Примечание: jq - утилита для работы с JSON в командной строке

Запустить второй модуль для использования в качестве клиента

```
kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
```

Установить дополнительные пакеты

```
dnf -y install pip
pip install hvac
```

Запустить интепретатор Python и выполнить следующий код, предварительно
поменяв IP и токен

```
import hvac
client = hvac.Client(
    url='http://10.10.133.71:8200',
    token='aiphohTaa0eeHei'
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```


### Ход решения Задачи 1.

* vault-pod.yaml

```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: 14.2-netology-vault
spec:
  containers:
  - name: vault
    image: vault
    ports:
    - containerPort: 8200
      protocol: TCP
    env:
    - name: VAULT_DEV_ROOT_TOKEN_ID
      value: "aiphohTaa0eeHei"
    - name: VAULT_DEV_LISTEN_ADDRESS
      value: 0.0.0.0:8200
```

```
controlplane $ kubectl apply -f vault-pod.yaml
pod/14.2-netology-vault created
```

#### Получить значение внутреннего IP пода

```
controlplane $ kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"192.168.1.4"}]
```

##### Берем IP адрес из вывода предыдущей команды [{"ip":"192.168.1.4"}], значенеи токена из манифеста пода и вставляем в код Python-скрипта. Это позволит
скрипту подключиться к Vault хранилищу и взаимодействовать с ним.

```py
import hvac                         # импортируем бибилиотеку hvac
client = hvac.Client(               # описывем параметры подключения клиента 
    url='http://192.168.1.4:8200',      # ip адрес
    token='aiphohTaa0eeHei'             # токен
)
client.is_authenticated()

# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
    path='hvac',
    secret=dict(netology='Big secret!!!'),
)

# Читаем секрет
client.secrets.kv.v2.read_secret_version(
    path='hvac',
)
```

#### Запустить второй модуль для использования в качестве клиента

```
controlplane $ kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1# 
```

#### Установить дополнительные пакеты в модуль (в открывшемся термиинале Fedore)

```
sh-5.1# dnf -y install pip
Fedora 36 - x86_64                                                                                                               21 MB/s |  81 MB     00:03    
Fedora 36 openh264 (From Cisco) - x86_64                                                                                        1.8 kB/s | 2.5 kB     00:01    
Fedora Modular 36 - x86_64                                                                                                      3.6 MB/s | 2.4 MB     00:00 
*
*
*
Installed:
  libxcrypt-compat-4.4.28-1.fc36.x86_64                 python3-pip-21.3.1-2.fc36.noarch                 python3-setuptools-59.6.0-2.fc36.noarch                

Complete!
sh-5.1# pip install hvac
Collecting hvac
  Downloading hvac-0.11.2-py2.py3-none-any.whl (148 kB)
     |████████████████████████████████| 148 kB 5.4 MB/s  
*
*
*
Installing collected packages: urllib3, idna, charset-normalizer, certifi, six, requests, hvac
Successfully installed certifi-2022.6.15 charset-normalizer-2.1.0 hvac-0.11.2 idna-3.3 requests-2.28.1 six-1.16.0 urllib3-1.26.11
```

#### Запускаем интепретатор Python и выполняем Python-скрипт

```
sh-5.1# 
sh-5.1# python3 
Python 3.10.4 (main, Mar 25 2022, 00:00:00) [GCC 12.0.1 20220308 (Red Hat 12.0.1-0)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
>>> import hvac
>>> client = hvac.Client(
...     url='http://192.168.1.4:8200',
...     token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
True
>>> 
>>> # Пишем секрет
>>> client.secrets.kv.v2.create_or_update_secret(
...     path='hvac',
...     secret=dict(netology='Big secret!!!'),
... )
{'request_id': '4af8d21d-9f5e-3ddb-7afd-e7794d5cec56', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-08-02T19:02:08.919290446Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 
>>> # Читаем секрет
>>> client.secrets.kv.v2.read_secret_version(
...     path='hvac',
... )
{'request_id': '480d12ce-753d-ce58-2750-015f5dccee2a', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-08-02T19:02:08.919290446Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 
```
### Ответ: доступ к Vault хранилищу получен. Секрет можно записать и потом прочитать. Создано защмщенное хранилище секретов.




## Задача 2 (*): Работа с секретами внутри модуля

* На основе образа fedora создать модуль;
* Создать секрет, в котором будет указан токен;
* Подключить секрет к модулю;
* Запустить модуль и проверить доступность сервиса Vault.




### 1. На основе образа fedora создать модуль
#### Готовим Dockerfile
* Dockerfile
```
FROM fedora:latest
CMD sleep 3600
```
#### Создаем свой образ из Dockerfile
```
docker build -t zakharovnpa/k8s-fedore:03.08.22 .
```
#### Используемые манифесты для создания тестовой среды
* vault-pod.yaml

```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: 14.2-netology-vault
spec:
  containers:
  - name: vault
    image: vault
    ports:
    - containerPort: 8200
      protocol: TCP
    env:
    - name: VAULT_DEV_ROOT_TOKEN_ID
      value: "aiphohTaa0eeHei"
    - name: VAULT_DEV_LISTEN_ADDRESS
      value: 0.0.0.0:8200
```
* fedore-pod.yaml
```yml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: one-fedora-pod 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: bb-app
  template:
    metadata:
      labels:
        app: bb-app
    spec:
      containers:
        - image: zakharovnpa/k8s-fedora:03.08.22
          imagePullPolicy: IfNotPresent
          name: one-fedora
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-secret-volume
        - image: zakharovnpa/k8s-fedora:03.08.22
          imagePullPolicy: IfNotPresent
          name: two-fedora
          volumeMounts:
            - mountPath: /static
              name: my-secret-volume
      volumes:
        - name: my-secret-volume
          secret:
            secretName: user-token
            
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: fedora-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30092
  selector:
    app: sbb-pod
         
```

### 2. Создаем секрет, в котором будет указан токен

```
controlplane $ touch user-token.txt
controlplane $ 
controlplane $ echo ‘aiphohTaa0eeHei’ > user-token.txt
controlplane $ 
controlplane $ kubectl create secret generic user-token --from-file=./user-token.txt
secret/user-token created
```
```
controlplane $ kubectl get secrets -o yaml 
```
```yml
apiVersion: v1
items:
- apiVersion: v1
  data:
    user-token.txt: 4oCYYWlwaG9oVGFhMGVlSGVp4oCZCg==
  kind: Secret
  metadata:
    creationTimestamp: "2022-08-04T10:31:28Z"
    name: user-token
    namespace: default
    resourceVersion: "3146"
    uid: e741dfa0-03d6-4e6e-a99d-8b66ad5c4e28
  type: Opaque
kind: List
metadata:
  resourceVersion: ""
```

### 3. Подключить секрет к модулю

* Добавлены строки в манифест пода с fedore
```
      volumes:
        - name: my-secret-volume
          secret:
            secretName: user-token
```


### 4. Запустить модуль и проверить доступность сервиса Vault.
* Будет запущено два пода - fedora и vault
* из пода fedora должен быть доступ к сервису vault. Проверим это с помощью Python-скрипта.
```
controlplane $ kubectl get secrets 
NAME         TYPE     DATA   AGE
user-token   Opaque   1      2m11s
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/one-fedora-pod created
service/fedora-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS              RESTARTS   AGE
one-fedora-pod-899997876-kq6kt   0/2     ContainerCreating   0          4s
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS    RESTARTS   AGE
one-fedora-pod-899997876-kq6kt   2/2     Running   0          8s
controlplane $ 
controlplane $ kubectl apply -f vault-pod.yaml 
pod/14.2-netology-vault created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS    RESTARTS   AGE
14.2-netology-vault              1/1     Running   0          7s
one-fedora-pod-899997876-kq6kt   2/2     Running   0          114s
controlplane $ 
```

#### Берем ip адрес из вывода `kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'` и ставим в `url='http://192.168.1.6:8200',`
```
import hvac
# Подключение и проверка
client = hvac.Client(
url='http://192.168.0.6:8200',
token='aiphohTaa0eeHei'
)
client.is_authenticated()
# Пишем секрет
client.secrets.kv.v2.create_or_update_secret(
path='hvac',
secret=dict(netology='Big secret!!!'),
)
# Читаем секрет
client.secrets.kv.v2.read_secret_version(
path='hvac',
)
```
#### Подключаемся у поду fedora и доустанавливаем необходимый софт
* dnf
```
kubectl exec one-fedora-pod-899997876-kq6kt -it bash -c one-fedora 
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# dnf -y install pip
*
*
Installed:
  libxcrypt-compat-4.4.28-1.fc36.x86_64                 python3-pip-21.3.1-2.fc36.noarch                 python3-setuptools-59.6.0-2.fc36.noarch                

Complete!
```
* hvac
```
[root@one-fedora-pod-899997876-kq6kt /]# pip install hvac
Collecting hvac
  Downloading hvac-0.11.2-py2.py3-none-any.whl (148 kB)
     |████████████████████████████████| 148 kB 6.7 MB/s    
     
*
*
Installing collected packages: urllib3, idna, charset-normalizer, certifi, six, requests, hvac
Successfully installed certifi-2022.6.15 charset-normalizer-2.1.0 hvac-0.11.2 idna-3.3 requests-2.28.1 six-1.16.0 urllib3-1.26.11
```
#### Запускаем в поде fedora скрипт. 
```
[root@one-fedora-pod-899997876-kq6kt /]# python3
Python 3.10.4 (main, Mar 25 2022, 00:00:00) [GCC 12.0.1 20220308 (Red Hat 12.0.1-0)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
>>> 
>>> import hvac
>>> # Подключение и проверка
>>> client = hvac.Client(
... url='http://192.168.0.6:8200',
... token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
True
>>> # Пишем секрет
>>> client.secrets.kv.v2.create_or_update_secret(
... path='hvac',
... secret=dict(netology='Big secret!!!'),
... )
{'request_id': '764b987f-b8f7-27ba-dd0f-015bbc8b0354', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-08-04T12:24:01.022781242Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> # Читаем секрет
>>> client.secrets.kv.v2.read_secret_version(
... path='hvac',
... )
{'request_id': '4a5c9326-bd69-0e10-362e-3e05b7633050', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-08-04T12:24:01.022781242Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 
```
![screen-fedore-vault-connect](/14.2-Synchronization-services/Files/screen-fedore-vault-connect.png)

### Ответ: доступ к сервису Vault есть.


---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

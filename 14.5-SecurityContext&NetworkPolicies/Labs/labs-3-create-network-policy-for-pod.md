### ЛР по ДЗ 14.5 Security Context

* Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978
```

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.


- Среда для запуска K8S - сайт [killercoda.com](https://killercoda.com/playgrounds/scenario/kubernetes). Авторизация через УЗ GitHub.

### Ход решения:

- Описание задания:
  - Создайте два модуля (в разных неймспейс).  
  - Для первого модуля разрешите доступ к внешнему миру и ко второму контейнеру. 
  - Для второго модуля разрешите связь только с первым контейнером. 
  - Проверьте корректность настроек.

- Легенда выполнения задания:
![legend-network-policy](/14.5-SecurityContext&NetworkPolicies/Files/legend-network-policy.png)

1. Создаем два неймспейс - "type-a" и "type-b"
```
controlplane $ kubectl create ns type-a
namespace/type-a created
controlplane $ 
controlplane $ kubectl create ns type-b
namespace/type-b created
controlplane $ 
controlplane $ kubectl get ns
NAME              STATUS   AGE
default           Active   24d
kube-node-lease   Active   24d
kube-public       Active   24d
kube-system       Active   24d
type-a            Active   6s
type-b            Active   2s
```
- Скрипт
```
kubectl create ns type-a type-b
```

2. В каждом NS создаем по 1 поду на основе одного образа
```yml
apiVersion: v1
kind: Pod
metadata:
  name: privilegedpod
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - "3600"
    securityContext:
      privileged: true

```
- Скрипт
```
date && \
mkdir -p My-Project && cd My-Project && \
touch ta.yml tb.yml example-network-policy.yml
echo "
---
apiVersion: v1
kind: Pod
metadata:
  name: ta
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - "3600"
 #   securityContext:
 #    privileged: true
" > ta.yml && \
echo "
---
apiVersion: v1
kind: Pod
metadata:
  name: tb
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - "3600"
 #   securityContext:
 #    privileged: true
" > tb.yml && \
echo "
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: test-network-policy
  namespace: default
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - ipBlock:
        cidr: 172.17.0.0/16
        except:
        - 172.17.1.0/24
    - namespaceSelector:
        matchLabels:
          project: myproject
    - podSelector:
        matchLabels:
          role: frontend
    ports:
    - protocol: TCP
      port: 6379
  egress:
  - to:
    - ipBlock:
        cidr: 10.0.0.0/24
    ports:
    - protocol: TCP
      port: 5978
" > example-network-policy.yml


```

3. 

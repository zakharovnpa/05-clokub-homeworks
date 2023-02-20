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
* Под ta
```yml
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
   # securityContext:
   #   privileged: true

```
* Под tb
```yml
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
  #  securityContext:
  #    privileged: true

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
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - \"3600\"
 #   securityContext:
 #    privileged: true
" > ta.yml && \
echo "
---
apiVersion: v1
kind: Pod
metadata:
  name: tb
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - \"3600\"
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
" > example-network-policy.yml && \
echo "
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Ingress  
" > np-ta.yml && \
echo "
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta 
  policyTypes:  
    - Ingress  
" > np-tb.yml && \
sleep 2 && \
cat ta.yml && \
sleep 2 && \
cat tb.yml && \
sleep 2 && \
cat example-network-policy.yml && \
sleep 2 && \
cat np-ta.yml && \
sleep 2 && \
cat np-tb.yml && \
kubectl apply -f ta.yml && \
kubectl apply -f tb.yml && \
kubectl apply -f np-ta.yml && \
kubectl apply -f np-tb.yml && \
kubectl get pod && \
kubectl get networkpolicy && \
date


```
- Политики сетевого доступа
* для
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend        # Название политики
  namespace: default    # Используется только в namespace default
spec:                   # Описание политики 
  podSelector:          # По отношению к какому поду применяется политика
    matchLabels:        # Условие - по совпадению Labels, указанного на следующей строке
      app: frontend     # Условие для совпадения - название пода содержит слово frontend
  policyTypes:          # Какой будет тип сетевой политики
    - Ingress           # Входящий тип, т.е. контролруются входящие соединения

```
* для пода ta
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Ingress  

```
* для пода tb
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta
  policyTypes:  
    - Ingress  

```

* для пода ta
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta       # Имя политики
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: ta
  policyTypes:
    - Ingress
  ingress:        # Для входящих соединений
    - from:       # От (и далее описано что для frontend)
      - podSelector:
          matchLabels:
            app: tb
      ports:                  # Описание портов и протоколов
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443

```

* для пода tb
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb       # Имя политики
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: tb
  policyTypes:
    - Ingress
  ingress:        # Для входящих соединений
    - from:       # От (и далее описано что для frontend)
      - podSelector:
          matchLabels:
            app: ta
      ports:                  # Описание портов и протоколов
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443

```

3. Попытка ответа на вопрос

##    Ответ:

### Ход решения:

1. Создам два модуля ta и tb.  
* Под ta.yml
```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: ta  
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - "3600"

```
* Под tb.yml
```yml
---
apiVersion: v1
kind: Pod
metadata:
  name: tb  
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - "3600"

```


2. Для первого модуля разрешаем доступ к внешнему миру и ко второму контейнеру, используя NetworkPolicy. 

* Для пода ta политика np-ta.yml
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Ingress  
```
*
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta 
  policyTypes:  
    - Egress 
    - Ingress
  ingress: 
    - from:
      - podSelector:
          matchLabels:
            app: tb
```
3. Для второго модуля разрешаем связь только с первым контейнером. 

* Для пода tb политика np-tb.yml
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta
  policyTypes:  
    - Ingress  
```
* 
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb
  policyTypes:  
    - Egress 
    - Ingress
  ingress: 
    - from:
      - podSelector:
          matchLabels:
            app: ta
```

4. Проверяем корректность настроек.



### Компоненты

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
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - \"3600\"
 #   securityContext:
 #    privileged: true
" > ta.yml && \
echo "
---
apiVersion: v1
kind: Pod
metadata:
  name: tb
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - \"3600\"
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
" > example-network-policy.yml && \
echo "
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Ingress  
" > np-ta.yml && \
echo "
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta 
  policyTypes:  
    - Ingress  
" > np-tb.yml && \
sleep 2 && \
cat ta.yml && \
sleep 2 && \
cat tb.yml && \
sleep 2 && \
cat example-network-policy.yml && \
sleep 2 && \
cat np-ta.yml && \
sleep 2 && \
cat np-tb.yml && \
kubectl apply -f ta.yml && \
kubectl apply -f tb.yml && \
kubectl apply -f np-ta.yml && \
kubectl apply -f np-tb.yml && \
kubectl get pod && \
kubectl get networkpolicy && \
date


```
- Политики сетевого доступа
* для
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: frontend        # Название политики
  namespace: default    # Используется только в namespace default
spec:                   # Описание политики 
  podSelector:          # По отношению к какому поду применяется политика
    matchLabels:        # Условие - по совпадению Labels, указанного на следующей строке
      app: frontend     # Условие для совпадения - название пода содержит слово frontend
  policyTypes:          # Какой будет тип сетевой политики
    - Ingress           # Входящий тип, т.е. контролруются входящие соединения

```
* для пода ta
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Ingress  

```
* для пода tb
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta
  policyTypes:  
    - Ingress  

```

* для пода ta
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta       # Имя политики
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: ta
  policyTypes:
    - Ingress
  ingress:        # Для входящих соединений
    - from:       # От (и далее описано что для frontend)
      - podSelector:
          matchLabels:
            app: tb
      ports:                  # Описание портов и протоколов
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443

```

* для пода tb
```yml
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb       # Имя политики
  namespace: default
spec:
  podSelector:
    matchLabels:
      app: tb
  policyTypes:
    - Ingress
  ingress:        # Для входящих соединений
    - from:       # От (и далее описано что для frontend)
      - podSelector:
          matchLabels:
            app: ta
      ports:                  # Описание портов и протоколов
        - protocol: TCP
          port: 80
        - protocol: TCP
          port: 443

```






- Logs 2

```
ontrolplane $ date && \
> mkdir -p My-Project && cd My-Project && \
> touch ta.yml tb.yml example-network-policy.yml
Mon Feb 20 16:46:53 UTC 2023
controlplane $ echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: ta  
>   namespace: default
> spec:
>   containers:
>   - image: busybox
>     name: busybox
>     args:
>       - sleep
>       - \"3600\"
>  #   securityContext:
>  #    privileged: true
> " > ta.yml && \
> echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: tb
>   namespace: default
> spec:
>   containers:
>   - image: busybox
>     name: busybox
>     args:
>       - sleep
>       - \"3600\"
>  #   securityContext:
>  #    privileged: true
> " > tb.yml && \
> echo "
> ---
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: test-network-policy
>   namespace: default
> spec:
>   podSelector:
>     matchLabels:
>       role: db
>   policyTypes:
>   - Ingress
>   - Egress
>   ingress:
>   - from:
>     - ipBlock:
>         cidr: 172.17.0.0/16
>         except:
>         - 172.17.1.0/24
>     - namespaceSelector:
>         matchLabels:
>           project: myproject
>     - podSelector:
>         matchLabels:
>           role: frontend
>     ports:
>     - protocol: TCP
>       port: 6379
>   egress:
>   - to:
>     - ipBlock:
>         cidr: 10.0.0.0/24
>     ports:
>     - protocol: TCP
>       port: 5978
> " > example-network-policy.yml && \
> echo "
> ---
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: ta 
>   namespace: default
> spec:                  
>   podSelector:         
>     matchLabels:     
>       app: tb 
>   policyTypes:  
>     - Ingress  
> " > np-ta.yml && \
> echo "
> ---
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: tb
>   namespace: default
> spec:                  
>   podSelector:         
>     matchLabels:     
>       app: ta 
>   policyTypes:  
>     - Ingress  
> " > np-tb.yml && \
> sleep 2 && \
> cat ta.yml && \
> sleep 2 && \
> cat tb.yml && \
> sleep 2 && \
> cat example-network-policy.yml && \
> sleep 2 && \
> cat np-ta.yml && \
> sleep 2 && \
> cat np-tb.yml && \
> kubectl apply -f ta.yml && \
> kubectl apply -f tb.yml && \
> kubectl apply -f np-ta.yml && \
> kubectl apply -f np-tb.yml && \
> kubectl get pod && \
> kubectl get networkpolicy && \
> date

---
apiVersion: v1
kind: Pod
metadata:
  name: ta  
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - "3600"
 #   securityContext:
 #    privileged: true


---
apiVersion: v1
kind: Pod
metadata:
  name: tb
  namespace: default
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - "3600"
 #   securityContext:
 #    privileged: true


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


---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Ingress  


---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta 
  policyTypes:  
    - Ingress  

pod/ta created
pod/tb created
networkpolicy.networking.k8s.io/ta created
networkpolicy.networking.k8s.io/tb created
NAME   READY   STATUS              RESTARTS   AGE
ta     0/1     ContainerCreating   0          0s
tb     0/1     ContainerCreating   0          0s
NAME   POD-SELECTOR   AGE
ta     app=tb         0s
tb     app=ta         0s
Mon Feb 20 16:47:04 UTC 2023
controlplane $ 
controlp
controlplane $ kubectl ge po
error: unknown command "ge" for "kubectl"

Did you mean this?
        set
        get
        cp
controlplane $ kubectl get po
NAME   READY   STATUS    RESTARTS   AGE
ta     1/1     Running   0          20s
tb     1/1     Running   0          20s
controlplane $ 
controlplane $ ping ta
ping: ta: Name or service not known
controlplane $ 
controlplane $ 
controlplane $ kubectl exec ta -- ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: seq=0 ttl=110 time=1.543 ms
64 bytes from 8.8.8.8: seq=1 ttl=110 time=1.540 ms
^C
controlplane $ 
controlplane $ kubectl exec ta -- ping ya.ru  
PING ya.ru (77.88.55.242): 56 data bytes
64 bytes from 77.88.55.242: seq=0 ttl=241 time=43.702 ms
64 bytes from 77.88.55.242: seq=1 ttl=241 time=43.721 ms
^C
controlplane $ kubectl exec ta -- ping tb   
ping: bad address 'tb'
command terminated with exit code 1
controlplane $ 
controlplane $ ls -l
total 20
-rw-r--r-- 1 root root 608 Feb 20 16:46 example-network-policy.yml
-rw-r--r-- 1 root root 220 Feb 20 16:46 np-ta.yml
-rw-r--r-- 1 root root 219 Feb 20 16:46 np-tb.yml
-rw-r--r-- 1 root root 216 Feb 20 16:46 ta.yml
-rw-r--r-- 1 root root 214 Feb 20 16:46 tb.yml
controlplane $ 
controlplane $ cat np-ta.yml 

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Ingress  

controlplane $ 
controlplane $ cat np-tb.yml 

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta 
  policyTypes:  
    - Ingress  

controlplane $ 
controlplane $ vi np-ta.yml 
controlplane $ 
controlplane $ vi np-tb.yml 
controlplane $ 
controlplane $ kubectl apply -f np-ta.yml 
networkpolicy.networking.k8s.io/ta configured
controlplane $ 
controlplane $ kubectl apply -f np-tb.yml 
networkpolicy.networking.k8s.io/tb configured
controlplane $ 
controlplane $ 
controlplane $ kubectl get networkpolicies.                  
NAME   POD-SELECTOR   AGE
ta     app=tb         8m19s
tb     app=ta         8m19s
controlplane $ 
controlplane $ kubectl exec ta -- ping tb
ping: bad address 'tb'
command terminated with exit code 1
controlplane $ 
controlplane $ kubectl exec ta -- ping ta
PING ta (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=64 time=0.046 ms
64 bytes from 192.168.1.3: seq=1 ttl=64 time=0.058 ms
64 bytes from 192.168.1.3: seq=2 ttl=64 time=0.055 ms
^C
controlplane $ 
controlplane $ 
controlplane $ kubectl delete networkpolicies   
error: resource(s) were provided, but no name was specified
controlplane $ 
controlplane $ kubectl delete ta             
error: the server doesn't have a resource type "ta"
controlplane $ 
controlplane $ kubectl delete np-ta
error: the server doesn't have a resource type "np-ta"
controlplane $ 
controlplane $ kubectl delete networkpolicies ?
Error from server (NotFound): networkpolicies.networking.k8s.io "?" not found
controlplane $ 
controlplane $ kubectl delete networkpolicies np-ta
Error from server (NotFound): networkpolicies.networking.k8s.io "np-ta" not found
controlplane $ 
controlplane $ kubectl delete networkpolicies ta   
networkpolicy.networking.k8s.io "ta" deleted
controlplane $ 
controlplane $ kubectl delete networkpolicies tb
networkpolicy.networking.k8s.io "tb" deleted
controlplane $ 
controlplane $ kubectl exec ta -- ping tb
ping: bad address 'tb'
command terminated with exit code 1
controlplane $ 
controlplane $ kubectl exec ta -- ping ta
PING ta (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=64 time=0.059 ms
64 bytes from 192.168.1.3: seq=1 ttl=64 time=0.065 ms
^C
controlplane $ 
controlplane $ vi np-ta.yml 
controlplane $ 
controlplane $ vi np-tb.yml 
controlplane $ 
controlplane $ kubectl apply -f np-ta.yml 
networkpolicy.networking.k8s.io/np-ta created
controlplane $ 
controlplane $ kubectl apply -f np-tb.yml 
networkpolicy.networking.k8s.io/np-tb created
controlplane $ 
controlplane $ 
controlplane $ kubectl get networkpolicies.
NAME    POD-SELECTOR   AGE
np-ta   app=ta         18s
np-tb   app=tb         14s
controlplane $ 
controlplane $ 
controlplane $ kubectl get networkpolicies np-ta
NAME    POD-SELECTOR   AGE
np-ta   app=ta         28s
controlplane $ 
controlplane $ kubectl describe networkpolicies np-ta
Name:         np-ta
Namespace:    default
Created on:   2023-02-20 17:00:57 +0000 UTC
Labels:       <none>
Annotations:  <none>
Spec:
  PodSelector:     app=ta
  Not affecting ingress traffic
  Allowing egress traffic:
    <none> (Selected pods are isolated for egress connectivity)
  Policy Types: Egress
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl exec ta -- ping tb
ping: bad address 'tb'
command terminated with exit code 1
controlplane $ 
controlplane $ kubectl exec ta -- ping ta
PING ta (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=64 time=0.059 ms
64 bytes from 192.168.1.3: seq=1 ttl=64 time=0.127 ms
^C
controlplane $ 
controlplane $ kubectl exec ta -- ping ya.ru
PING ya.ru (77.88.55.242): 56 data bytes
64 bytes from 77.88.55.242: seq=0 ttl=241 time=43.718 ms
64 bytes from 77.88.55.242: seq=1 ttl=241 time=43.699 ms
^C
controlplane $ 
controlplane $ 
controlplane $ vi np-ta.yml 
controlplane $ 
controlplane $ cat np-ta.yml 

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-ta 
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: ta 
  policyTypes:  
    - Egress 
    - Ingress
  ingress: 
    - from:
      - podSelector:
          matchLabels:
            app: tb
controlplane $ 
controlplane $ vi np-tb.yml 
controlplane $ 
controlplane $ cat np-tb.yml 

---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np-tb
  namespace: default
spec:                  
  podSelector:         
    matchLabels:     
      app: tb 
  policyTypes:  
    - Egress  
    - Ingress
  ingress: 
    - from:
      - podSelector:
          matchLabels:
            app: ta
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f np-ta.yml 
networkpolicy.networking.k8s.io/np-ta configured
controlplane $ 
controlplane $ kubectl apply -f np-tb.yml 
networkpolicy.networking.k8s.io/np-tb configured
controlplane $ 
controlplane $ 
controlplane $ kubectl get networkpolicies.
NAME    POD-SELECTOR   AGE
np-ta   app=ta         8m23s
np-tb   app=tb         8m19s
controlplane $ 
controlplane $ kubectl exec ta -- ping ya.ru
PING ya.ru (5.255.255.242): 56 data bytes
64 bytes from 5.255.255.242: seq=0 ttl=241 time=45.327 ms
64 bytes from 5.255.255.242: seq=1 ttl=241 time=45.432 ms
64 bytes from 5.255.255.242: seq=2 ttl=241 time=45.490 ms
^C
controlplane $ 
controlplane $ kubectl exec tb -- ping ya.ru
PING ya.ru (77.88.55.242): 56 data bytes
64 bytes from 77.88.55.242: seq=0 ttl=241 time=43.623 ms
64 bytes from 77.88.55.242: seq=1 ttl=241 time=43.701 ms
^C
controlplane $ 
controlplane $ kubectl exec ta -- ping ta
PING ta (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=64 time=0.082 ms
64 bytes from 192.168.1.3: seq=1 ttl=64 time=0.100 ms
^C
controlplane $ 
controlplane $ kubectl exec ta -- ping tb
ping: bad address 'tb'
command terminated with exit code 1
controlplane $ 
controlplane $ vi np-ta.yml 
controlplane $ 
controlplane $ kubectl get svc -A
NAMESPACE     NAME         TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP                  25d
kube-system   kube-dns     ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP,9153/TCP   25d
controlplane $ 
controlplane $ 
```
- Logs 1
```
Initialising Kubernetes... done

controlplane $ 
controlplane $ date && \
> mkdir -p My-Project && cd My-Project && \
> touch ta.yml tb.yml example-network-policy.yml
Sun Feb 19 18:40:34 UTC 2023
controlplane $ echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: ta
> spec:
>   containers:
>   - image: busybox
>     name: busybox
>     args:
>       - sleep
>       - "3600"
>  #   securityContext:
>  #    privileged: true
> " > ta.yml && \
> echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: tb
> spec:
>   containers:
>   - image: busybox
>     name: busybox
>     args:
>       - sleep
>       - "3600"
>  #   securityContext:
>  #    privileged: true
> " > tb.yml && \
> echo "
> ---
> apiVersion: networking.k8s.io/v1
> kind: NetworkPolicy
> metadata:
>   name: test-network-policy
>   namespace: default
> spec:
>   podSelector:
>     matchLabels:
>       role: db
>   policyTypes:
>   - Ingress
>   - Egress
>   ingress:
>   - from:
>     - ipBlock:
>         cidr: 172.17.0.0/16
>         except:
>         - 172.17.1.0/24
>     - namespaceSelector:
>         matchLabels:
>           project: myproject
>     - podSelector:
>         matchLabels:
>           role: frontend
>     ports:
>     - protocol: TCP
>       port: 6379
>   egress:
>   - to:
>     - ipBlock:
>         cidr: 10.0.0.0/24
>     ports:
>     - protocol: TCP
>       port: 5978
> " > example-network-policy.yml
controlplane $ 
controlplane $ 
controlplane $ ls -l
total 12
-rw-r--r-- 1 root root 608 Feb 19 18:40 example-network-policy.yml
-rw-r--r-- 1 root root 191 Feb 19 18:40 ta.yml
-rw-r--r-- 1 root root 191 Feb 19 18:40 tb.yml
controlplane $ 
controlplane $ cat ta.yml 

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
      - 3600
 #   securityContext:
 #    privileged: true

controlplane $ 
controlplane $ cat tb.yml 

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
      - 3600
 #   securityContext:
 #    privileged: true

controlplane $ 
controlplane $ cat example-network-policy.yml 

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

controlplane $ 
controlplane $ kubextl create ns type-a type-b

Command 'kubextl' not found, did you mean:

  command 'kubectl' from snap kubectl (1.26.1)

See 'snap info <snapname>' for additional versions.

controlplane $ 
controlplane $ kubectl create ns type-a type-b
error: exactly one NAME is required, got 2
See 'kubectl create namespace -h' for help and examples
controlplane $ kubectl create ns type-a       
namespace/type-a created
controlplane $ 
controlplane $ 
controlplane $ kubectl create ns type-b
namespace/type-b created
controlplane $ 
controlplane $ 
controlplane $ cubectl get ns

Command 'cubectl' not found, did you mean:

  command 'kubectl' from snap kubectl (1.26.1)

See 'snap info <snapname>' for additional versions.

controlplane $ kubectl get ns
NAME              STATUS   AGE
default           Active   24d
kube-node-lease   Active   24d
kube-public       Active   24d
kube-system       Active   24d
type-a            Active   32s
type-b            Active   29s
controlplane $ 
controlplane $ kubectl -h   
kubectl controls the Kubernetes cluster manager.

 Find more information at: https://kubernetes.io/docs/reference/kubectl/

Basic Commands (Beginner):
  create          Create a resource from a file or from stdin
  expose          Take a replication controller, service, deployment or pod and expose it as a new Kubernetes service
  run             Run a particular image on the cluster
  set             Set specific features on objects

Basic Commands (Intermediate):
  explain         Get documentation for a resource
  get             Display one or many resources
  edit            Edit a resource on the server
  delete          Delete resources by file names, stdin, resources and names, or by resources and label selector

Deploy Commands:
  rollout         Manage the rollout of a resource
  scale           Set a new size for a deployment, replica set, or replication controller
  autoscale       Auto-scale a deployment, replica set, stateful set, or replication controller

Cluster Management Commands:
  certificate     Modify certificate resources.
  cluster-info    Display cluster information
  top             Display resource (CPU/memory) usage
  cordon          Mark node as unschedulable
  uncordon        Mark node as schedulable
  drain           Drain node in preparation for maintenance
  taint           Update the taints on one or more nodes

Troubleshooting and Debugging Commands:
  describe        Show details of a specific resource or group of resources
  logs            Print the logs for a container in a pod
  attach          Attach to a running container
  exec            Execute a command in a container
  port-forward    Forward one or more local ports to a pod
  proxy           Run a proxy to the Kubernetes API server
  cp              Copy files and directories to and from containers
  auth            Inspect authorization
  debug           Create debugging sessions for troubleshooting workloads and nodes
  events          List events

Advanced Commands:
  diff            Diff the live version against a would-be applied version
  apply           Apply a configuration to a resource by file name or stdin
  patch           Update fields of a resource
  replace         Replace a resource by file name or stdin
  wait            Experimental: Wait for a specific condition on one or many resources
  kustomize       Build a kustomization target from a directory or URL.

Settings Commands:
  label           Update the labels on a resource
  annotate        Update the annotations on a resource
  completion      Output shell completion code for the specified shell (bash, zsh, fish, or powershell)

Other Commands:
  alpha           Commands for features in alpha
  api-resources   Print the supported API resources on the server
  api-versions    Print the supported API versions on the server, in the form of "group/version"
  config          Modify kubeconfig files
  plugin          Provides utilities for interacting with plugins
  version         Print the client and server version information

Usage:
  kubectl [flags] [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
controlplane $ 
controlplane $ kubectl set -h     
Configure application resources.

 These commands help you make changes to existing application resources.

Available Commands:
  env              Update environment variables on a pod template
  image            Update the image of a pod template
  resources        Update resource requests/limits on objects with pod templates
  selector         Set the selector on a resource
  serviceaccount   Update the service account of a resource
  subject          Update the user, group, or service account in a role binding or cluster role binding

Usage:
  kubectl set SUBCOMMAND [options]

Use "kubectl <command> --help" for more information about a given command.
Use "kubectl options" for a list of global command-line options (applies to all commands).
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ vi ta.yml 
controlplane $ 
controlplane $ vi tb.yml 
controlplane $ 
controlplane $ kubectl apply -f ta.yml 
Error from server (BadRequest): error when creating "ta.yml": Pod in version "v1" cannot be handled as a Pod: json: cannot unmarshal number into Go struct field Container.spec.containers.args of type string
controlplane $ 
controlplane $ kubectl get pod
No resources found in default namespace.
controlplane $ 
controlplane $ kubectl -n type-a apply -f ta.yml 
Error from server (BadRequest): error when creating "ta.yml": Pod in version "v1" cannot be handled as a Pod: json: cannot unmarshal number into Go struct field Container.spec.containers.args of type string
controlplane $ 
controlplane $ cat ta.yml 

---
apiVersion: v1
kind: Pod
metadata:
  name: ta
  namspace: type-a
spec:
  containers:
  - image: busybox
    name: busybox
    args:
      - sleep
      - 3600
 #   securityContext:
 #    privileged: true

controlplane $ 
controlplane $ vi ta.yml 
controlplane $ 
controlplane $ kubectl -n type-a apply -f ta.yml 
Error from server (BadRequest): error when creating "ta.yml": Pod in version "v1" cannot be handled as a Pod: strict decoding error: unknown field "metadata.namspace"
controlplane $ 
controlplane $ vi ta.yml 
controlplane $ 
controlplane $ kubectl -n type-a apply -f ta.yml 
pod/ta created
controlplane $ 
controlplane $ vi tb.yml 
controlplane $ 
controlplane $ kubectl -n type-b apply -f tb.yml 
pod/tb created
controlplane $ 
controlplane $ kubectl get pod
No resources found in default namespace.
controlplane $ 
```
```
controlplane $ kubectl get pod
No resources found in default namespace.
controlplane $ 
controlplane $ kubectl get pod -n type-a
NAME   READY   STATUS    RESTARTS   AGE
ta     1/1     Running   0          3m5s
controlplane $ 
controlplane $ kubectl get pod -n type-b
NAME   READY   STATUS    RESTARTS   AGE
tb     1/1     Running   0          53s
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl -n type-a describe pod ta 
Name:             ta
Namespace:        type-a
Priority:         0
Service Account:  default
Node:             node01/172.30.2.2
Start Time:       Sun, 19 Feb 2023 19:02:25 +0000
Labels:           <none>
Annotations:      cni.projectcalico.org/containerID: ae2680bb82aae0da77b5fb09a29ca3dba4797fca28fab3a27001137d31cec6d2
                  cni.projectcalico.org/podIP: 192.168.1.3/32
                  cni.projectcalico.org/podIPs: 192.168.1.3/32
Status:           Running
IP:               192.168.1.3
IPs:
  IP:  192.168.1.3
Containers:
  busybox:
    Container ID:  containerd://460c4bee0a223f9e33b494d4b0f0c2df920c6a095a50f94cf66a9811111d781b
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:7b3ccabffc97de872a30dfd234fd972a66d247c8cfc69b0550f276481852627c
    Port:          <none>
    Host Port:     <none>
    Args:
      sleep
      3600
    State:          Running
      Started:      Sun, 19 Feb 2023 19:02:28 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-22thx (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-22thx:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  8m44s  default-scheduler  Successfully assigned type-a/ta to node01
  Normal  Pulling    8m43s  kubelet            Pulling image "busybox"
  Normal  Pulled     8m41s  kubelet            Successfully pulled image "busybox" in 1.845012882s (1.845016147s including waiting)
  Normal  Created    8m41s  kubelet            Created container busybox
  Normal  Started    8m41s  kubelet            Started container busybox
controlplane $ 
controlplane $ kubectl -n type-b describe pod tb 
Name:             tb
Namespace:        type-b
Priority:         0
Service Account:  default
Node:             node01/172.30.2.2
Start Time:       Sun, 19 Feb 2023 19:04:43 +0000
Labels:           <none>
Annotations:      cni.projectcalico.org/containerID: 1e145458e4f264d8525d6e538f4d649ff998f2a31c2001cf067d8d6827fde94e
                  cni.projectcalico.org/podIP: 192.168.1.4/32
                  cni.projectcalico.org/podIPs: 192.168.1.4/32
Status:           Running
IP:               192.168.1.4
IPs:
  IP:  192.168.1.4
Containers:
  busybox:
    Container ID:  containerd://8ae818ddf356658cd768eb2245b340e39746850775ab3b00718d2534e66f2035
    Image:         busybox
    Image ID:      docker.io/library/busybox@sha256:7b3ccabffc97de872a30dfd234fd972a66d247c8cfc69b0550f276481852627c
    Port:          <none>
    Host Port:     <none>
    Args:
      sleep
      3600
    State:          Running
      Started:      Sun, 19 Feb 2023 19:04:46 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-d7bht (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-d7bht:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  6m45s  default-scheduler  Successfully assigned type-b/tb to node01
  Normal  Pulling    6m44s  kubelet            Pulling image "busybox"
  Normal  Pulled     6m42s  kubelet            Successfully pulled image "busybox" in 1.732941955s (1.732947211s including waiting)
  Normal  Created    6m42s  kubelet            Created container busybox
  Normal  Started    6m42s  kubelet            Started container busybox
controlplane $ 
controlplane $ 
controlplane $ kubectl exec -n type-a pods/ta -- curl ya.ru  
error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "ab21e41efd61732fe043ed0d66fc95d69c2f86af08d2b71c985f6a2ef3430d7e": OCI runtime exec failed: exec failed: unable to start container process: exec: "curl": executable file not found in $PATH: unknown
controlplane $ 
controlplane $ kubectl exec -n type-a pods/ta -- ping ya.ru
PING ya.ru (77.88.55.242): 56 data bytes
64 bytes from 77.88.55.242: seq=0 ttl=239 time=45.195 ms
64 bytes from 77.88.55.242: seq=1 ttl=239 time=45.229 ms
64 bytes from 77.88.55.242: seq=2 ttl=239 time=45.231 ms
64 bytes from 77.88.55.242: seq=3 ttl=239 time=45.174 ms
^C
controlplane $ 
controlplane $ 
controlplane $ kubectl exec -n type-a pods/ta -- ping 192.168.1.4
PING 192.168.1.4 (192.168.1.4): 56 data bytes
64 bytes from 192.168.1.4: seq=0 ttl=63 time=0.125 ms
64 bytes from 192.168.1.4: seq=1 ttl=63 time=0.075 ms
64 bytes from 192.168.1.4: seq=2 ttl=63 time=0.058 ms
64 bytes from 192.168.1.4: seq=3 ttl=63 time=0.065 ms
^C
controlplane $ 
controlplane $ kubectl exec -n type-a pods/ta -- ping 192.168.1.3
PING 192.168.1.3 (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=64 time=0.053 ms
64 bytes from 192.168.1.3: seq=1 ttl=64 time=0.057 ms
64 bytes from 192.168.1.3: seq=2 ttl=64 time=0.055 ms
^C
controlplane $ 
controlplane $ 
controlplane $ kubectl exec -n type-b pods/tb -- ping 192.168.1.3
PING 192.168.1.3 (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=63 time=0.064 ms
64 bytes from 192.168.1.3: seq=1 ttl=63 time=0.063 ms
64 bytes from 192.168.1.3: seq=2 ttl=63 time=0.074 ms
^C
controlplane $ 
controlplane $ kubectl exec -n type-b pods/tb -- ping 192.168.1.4
PING 192.168.1.4 (192.168.1.4): 56 data bytes
64 bytes from 192.168.1.4: seq=0 ttl=64 time=0.041 ms
64 bytes from 192.168.1.4: seq=1 ttl=64 time=0.052 ms
^C
controlplane $ 
```
```
controlplane $ kubectl exec -n type-b pods/tb -- ping ta         
ping: bad address 'ta'
command terminated with exit code 1
controlplane $ 
controlplane $ kubectl exec -n type-b pods/tb -- ping tb
PING tb (192.168.1.4): 56 data bytes
64 bytes from 192.168.1.4: seq=0 ttl=64 time=0.068 ms
64 bytes from 192.168.1.4: seq=1 ttl=64 time=0.059 ms
64 bytes from 192.168.1.4: seq=2 ttl=64 time=0.070 ms
^C
controlplane $ 
controlplane $ kubectl exec -n type-a pods/ta -- ping ta
PING ta (192.168.1.3): 56 data bytes
64 bytes from 192.168.1.3: seq=0 ttl=64 time=0.060 ms
64 bytes from 192.168.1.3: seq=1 ttl=64 time=0.093 ms
^C
controlplane $ 
controlplane $ kubectl exec -n type-a pods/ta -- ping tb
ping: bad address 'tb'
command terminated with exit code 1
controlplane $ 
controlplane $ kubectl exec -n type-a pods/ta -- ping tb
```

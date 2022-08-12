## Ход выполнения ДЗ по теме "14.5 SecurityContext, NetworkPolicies"

## Задача 1: Рассмотрите пример 14.5/example-security-context.yml

Создайте модуль

```
kubectl apply -f 14.5/example-security-context.yml
```

Проверьте установленные настройки внутри контейнера

```
kubectl logs security-context-demo
uid=1000 gid=3000 groups=3000
```

### Ход решения

```
Initialising Kubernetes... done

controlplane $ date && \
> touch example-security-context.yml example-network-policy.yml
Fri Aug 12 07:47:24 UTC 2022
controlplane $ echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: security-context-demo
> spec:
>   containers:
>   - name: sec-ctx-demo
>     image: fedora:latest
>     command: [ "id" ]
>     # command: [ "sh", "-c", "sleep 1h" ]
>     securityContext:
>       runAsUser: 1000
>       runAsGroup: 3000
> " > example-security-context.yml && \
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
> sleep 3 && \
> cat example-network-policy.yml && \
> sleep 3 && \
> cat example-security-context.yml && \
> date


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
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ id ]
    # command: [ sh, -c, sleep 1h ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000

Fri Aug 12 07:47:30 UTC 2022
controlplane $ 
controlplane $ 
controlplane $ kubectl apply -f example-security-context.yml
pod/security-context-demo created
controlplane $ 
controlplane $ kubectl get pod
NAME                    READY   STATUS             RESTARTS      AGE
security-context-demo   0/1     CrashLoopBackOff   2 (18s ago)   43s
controlplane $ 
controlplane $ kubectl logs security-context-demo 
uid=1000 gid=3000 groups=3000
controlplane $ 
```

## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

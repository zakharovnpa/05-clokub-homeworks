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
1. Создаем два неймспейс - "type-a" и "type-b"
2. В каждом NS создаем по 1 поду

![legend-network-policy](/14.5-SecurityContext&NetworkPolicies/Files/legend-network-policy.png)

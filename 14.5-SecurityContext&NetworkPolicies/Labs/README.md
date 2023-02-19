## Лабораторные работы

- [ЛР-1. Создание стартового скрипта для разверачивания рабочей среды](/14.5-SecurityContext&NetworkPolicies/Labs/labs-1-create-start-script.md)
- Среда для запуска K8S - сайт [killercoda.com](https://killercoda.com/playgrounds/scenario/kubernetes). Автоизация через УЗ GitHub

```
date && \
mkdir -p My-Project && cd My-Project && \
touch example-security-context.yml example-network-policy.yml
echo "
---
apiVersion: v1
kind: Pod
metadata:
  name: security-context-demo
spec:
  containers:
  - name: sec-ctx-demo
    image: fedora:latest
    command: [ "id" ]
    # command: [ "sh", "-c", "sleep 1h" ]
    securityContext:
      runAsUser: 1000
      runAsGroup: 3000
" > example-security-context.yml && \
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
sleep 3 && \
cat example-network-policy.yml && \
sleep 3 && \
cat example-security-context.yml && \
date

```

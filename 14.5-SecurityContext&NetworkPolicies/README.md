# Домашнее задание к занятию "14.5 SecurityContext, NetworkPolicies" - Захаров Сергей Николаевич

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
##  Ответ:

1. На основе файла `example-security-context.yml`, данного в этом ДЗ
* example-security-context.yml
```yml
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
    command: [ "sh", "-c", "sleep 1h" ]
    securityContext:    # создаем правила SecurityContext для контейнера 
      runAsUser: 1000   # идентификатор пользователя контейнера
      runAsGroup: 3000  # идентификаторы группы контейнера
```

2. Создаем под, и проверяем запуском команды `id` в созданном контейнере от какого пользователя и от какой группы запущен контенйер.
Полная команда в кластере будет такой: `kkubectl exec security-context-demo -- id`
3. Вывод команды и результат: `uid=1000 gid=3000 groups=3000`
4. Скриншот выполнения команд в среде K8S [killercoda.com](https://killercoda.com/playgrounds/scenario/kubernetes)

![kubectl-exec-security-context-demo--id](/14.5-SecurityContext&NetworkPolicies/Files/kubectl-exec-security-context-demo--id.png)




## Задача 2 (*): Рассмотрите пример 14.5/example-network-policy.yml

Создайте два модуля. Для первого модуля разрешите доступ к внешнему миру
и ко второму контейнеру. Для второго модуля разрешите связь только с
первым контейнером. Проверьте корректность настроек.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

В качестве решения прикрепите к ДЗ конфиг файлы для деплоя. Прикрепите скриншоты вывода команды kubectl со списком запущенных объектов каждого типа (pods, deployments, statefulset, service) или скриншот из самого Kubernetes, что сервисы подняты и работают, а также вывод из CLI.

---

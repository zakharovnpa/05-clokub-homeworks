## ЛР-2 по Задаче 2 (*): Работа с секретами внутри модуля

### Задача 2 (*): Работа с секретами внутри модуля

#### Задача:
1. На основе образа fedora создать модуль;
2. Создать секрет, в котором будет указан токен;
3. Подключить секрет к модулю;
4. Запустить модуль и проверить доступность сервиса Vault.




### 1. На основе образа fedora создать модуль

#### Скрипт для развертывания окружения
```
date && \
mkdir -p My-Project && cd My-Project && \
touch username.txt password.txt secret-fedore-pod.yaml fedore-pod.yaml && \
echo ‘admin’ > username.txt && \
echo ‘password’ > password.txt && \
echo "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: sbb-app
  name: secret-fedore-pod 
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sbb-app
  template:
    metadata:
      labels:
        app: sbb-app
    spec:
      containers:
        - image: fedore
          imagePullPolicy: IfNotPresent
          name: one-fedore
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-secret-volume
        - image: fedore
          imagePullPolicy: IfNotPresent
          name: two-fedore
          volumeMounts:
            - mountPath: /tmp/cache
              name: my-secret-volume
      volumes:
        - name: my-secret-volume
          secret:
            secretName: user-cred
            
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: fedore-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30092
  selector:
    app: sbb-pod
" > secret-fedore-pod.yaml && \
echo "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: fedore-pod 
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
        - image: fedore
          imagePullPolicy: IfNotPresent
          name: one-fedore
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-volume
        - image: fedore
          imagePullPolicy: IfNotPresent
          name: two-fedore
          volumeMounts:
            - mountPath: /tmp/cache
              name: my-volume
      volumes:
        - name: my-volume
          emptyDir: {}
          
---
# Config Service
apiVersion: v1
kind: Service
metadata:
  name: fedore-pod
  labels:
    app: bb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30091
  selector:
    app: bb-pod
" > fedore-pod.yaml
```
```
kubectl create secret generic user-cred --from-file=./username.txt --from-file=./password.txt && \
clear && \
echo "Script working!" && \
sleep 10 && \
kubectl apply -f busybox-pod.yaml && \
sleep 3 && \
kubectl apply -f secret-busybox-pod.yaml && \
sleep 10 && \
kubectl get secrets && \
sleep 3 && \
kubectl get deployment && \
sleep 3 && \
kubectl get svc && \
sleep 3 && \
kubectl get pod
```


### 2. Создать секрет, в котором будет указан токен


### 3. Подключить секрет к модулю



### 4. Запустить модуль и проверить доступность сервиса Vault.


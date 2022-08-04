## ЛР-1. Создание стартового скрипта для создания окружения

```
date && \
mkdir -p My-Project && cd My-Project && \
touch username.txt password.txt secret-busybox-pod.yaml busybox-pod.yaml && \
echo ‘admin’ > username.txt && \
echo ‘password’ > password.txt && \
echo "" > secret-busybox-pod.yaml && \
echo "" > busybox-pod.yaml && \
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

mkdir -p My-Project && cd My-Project && \
touch username.txt password.txt secret-busybox-pod.yaml busybox-pod.yaml && \
echo ‘admin’ > username.txt && \
echo ‘password’ > password.txt && \
echo "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: sbb-app
  name: secret-busybox-pod 
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
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: one-busybox
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-secret-volume
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: two-busybox
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
  name: busybox-pod
  labels:
    app: sbb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30092
  selector:
    app: sbb-pod
" > secret-busybox-pod.yaml && \
echo "
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: bb-app
  name: busybox-pod 
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
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: one-busybox
          ports:
          - containerPort: 80
          volumeMounts:
            - mountPath: /static
              name: my-volume
        - image: zakharovnpa/k8s-busybox:02.08.22
          imagePullPolicy: IfNotPresent
          name: two-busybox
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
  name: busybox-pod
  labels:
    app: bb
spec:
  type: NodePort
  ports:
  - port: 80
    nodePort: 30091
  selector:
    app: bb-pod
" > busybox-pod.yaml && \
kubectl create secret generic user-cred --from-file=./username.txt --from-file=./password.txt && \
clear && \
sleep 10 && \
kubectl apply -f busybox-pod.yaml && \
kubectl apply -f secret-busybox-pod.yaml && \
sleep 10 && \
kubectl get pod,secrets

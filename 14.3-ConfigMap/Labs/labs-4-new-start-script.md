### ЛР-4. Создание нового стартового скрипта с рабочей конфигурацией пода.

```sh
date && \
mkdir -p My-Project/templates && cd My-Project && \
touch nginx.conf myapp-pod.yml generator.py templates/nginx.vhosts.jinja && \
echo "
server {
    listen 80;
    server_name  netology.ru www.netology.ru;
    access_log  /var/log/nginx/domains/netology.ru-access.log  main;
    error_log   /var/log/nginx/domains/netology.ru-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://10.10.10.10:8080/;
    }
}
" > nginx.conf && \
echo "
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: myapp
    image: fedora:latest
    env:
      - name: SPECIAL_LEVEL_KEY
        valueFrom:
          configMapKeyRef:
            name: nginx-config
            key: nginx.conf
    envFrom:
      - configMapRef:
          name: nginx-config
    volumeMounts:
      - name: config
        mountPath: /etc/nginx/conf.d
        readOnly: true
  volumes:
  - name: config
    configMap:
      name: nginx-config
" > myapp-pod.yml && \
echo "
#!/usr/bin/env python3

from jinja2 import Environment, FileSystemLoader

env = Environment(
    loader=FileSystemLoader('templates')
)
template = env.get_template('nginx.vhosts.jinja')

domains = [{'domain': 'netology.ru',
     'ip': '10.10.10.10'}]

for item in domains:
    config=template.render(
        domain=item['domain'], ip=item['ip']
    )
    print(config)
" > generator.py && \
echo "
server {
    listen 80;
    server_name  {{ domain }} www.{{ domain }};
    access_log  /var/log/nginx/domains/{{ domain }}-access.log  main;
    error_log   /var/log/nginx/domains/{{ domain }}-error.log info;
    location / {
        include proxy_params;
        proxy_pass http://{{ ip }}:8080/;
    }
}
" > templates/nginx.vhosts.jinja && \
echo "cat templates/nginx.vhosts.jinja" && \
sleep 2 && \
cat templates/nginx.vhosts.jinja && \
echo "cat generator.py" && \
sleep 2 && \
cat generator.py && \
echo "cat myapp-pod.yml" && \
sleep 2 && \
cat myapp-pod.yml && \
echo "cat nginx.conf" && \
sleep 2 && \
cat nginx.conf && \
kubectl create configmap nginx-config --from-file=nginx.conf
slep 10 && \
kubectl apply -f myapp-pod.yml && \
slep 10 && \
kubectl get pod && \
controlplane $ kubectl exec netology-14.3 -it -- bash -c env | grep server_name
```

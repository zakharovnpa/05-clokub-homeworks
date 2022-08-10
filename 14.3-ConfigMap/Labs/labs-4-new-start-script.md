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
    image: zakharovnpa/k8s-fedora:03.08.22
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
kubectl create configmap nginx-config --from-file=nginx.conf && \
sleep 10 && \
kubectl apply -f myapp-pod.yml && \
sleep 10 && \
kubectl get pod && \
kubectl exec netology-14.3 -it -- bash -c env | grep server_name && \
date
```
### Результат работы скрипта
```
Initialising Kubernetes... done

controlplane $ date && \
> mkdir -p My-Project/templates && cd My-Project && \
> touch nginx.conf myapp-pod.yml generator.py templates/nginx.vhosts.jinja && \
> echo "
> server {
>     listen 80;
>     server_name  netology.ru www.netology.ru;
>     access_log  /var/log/nginx/domains/netology.ru-access.log  main;
>     error_log   /var/log/nginx/domains/netology.ru-error.log info;
>     location / {
>         include proxy_params;
>         proxy_pass http://10.10.10.10:8080/;
>     }
> }
> " > nginx.conf && \
> echo "
> ---
> apiVersion: v1
> kind: Pod
> metadata:
>   name: netology-14.3
> spec:
>   containers:
>   - name: myapp
>     image: zakharovnpa/k8s-fedora:03.08.22
>     env:
>       - name: SPECIAL_LEVEL_KEY
>         valueFrom:
>           configMapKeyRef:
>             name: nginx-config
>             key: nginx.conf
>     envFrom:
>       - configMapRef:
>           name: nginx-config
>     volumeMounts:
>       - name: config
>         mountPath: /etc/nginx/conf.d
>         readOnly: true
>   volumes:
>   - name: config
>     configMap:
>       name: nginx-config
> " > myapp-pod.yml && \
> echo "
> #!/usr/bin/env python3
bash: !/usr/bin/env: event not found
> 
> from jinja2 import Environment, FileSystemLoader
> 
> env = Environment(
>     loader=FileSystemLoader('templates')
> )
> template = env.get_template('nginx.vhosts.jinja')
> 
> domains = [{'domain': 'netology.ru',
>      'ip': '10.10.10.10'}]
> 
> for item in domains:
>     config=template.render(
>         domain=item['domain'], ip=item['ip']
>     )
>     print(config)
> " > generator.py && \
> echo "
> server {
>     listen 80;
>     server_name  {{ domain }} www.{{ domain }};
>     access_log  /var/log/nginx/domains/{{ domain }}-access.log  main;
>     error_log   /var/log/nginx/domains/{{ domain }}-error.log info;
>     location / {
>         include proxy_params;
>         proxy_pass http://{{ ip }}:8080/;
>     }
> }
> " > templates/nginx.vhosts.jinja && \
> echo "cat templates/nginx.vhosts.jinja" && \
> sleep 2 && \
> cat templates/nginx.vhosts.jinja && \
> echo "cat generator.py" && \
> sleep 2 && \
> cat generator.py && \
> echo "cat myapp-pod.yml" && \
> sleep 2 && \
> cat myapp-pod.yml && \
> echo "cat nginx.conf" && \
> sleep 2 && \
> cat nginx.conf && \
> kubectl create configmap nginx-config --from-file=nginx.conf && \
> sleep 10 && \
> kubectl apply -f myapp-pod.yml && \
> sleep 10 && \
> kubectl get pod && \
> kubectl exec netology-14.3 -it -- bash -c env | grep server_name && \
> date
Wed Aug 10 08:02:06 UTC 2022
cat templates/nginx.vhosts.jinja

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

cat generator.py


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

cat myapp-pod.yml

---
apiVersion: v1
kind: Pod
metadata:
  name: netology-14.3
spec:
  containers:
  - name: myapp
    image: zakharovnpa/k8s-fedora:03.08.22
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

cat nginx.conf

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

configmap/nginx-config created
pod/netology-14.3 created
NAME            READY   STATUS    RESTARTS   AGE
netology-14.3   1/1     Running   0          10s
    server_name  netology.ru www.netology.ru;
    server_name  netology.ru www.netology.ru;
Wed Aug 10 08:02:35 UTC 2022
```

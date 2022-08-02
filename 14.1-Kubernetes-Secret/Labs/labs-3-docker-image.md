## ЛР-3. "Подготовка образа для задачи 2 *."

> Цель: создать образ, в котором будут прописаны переменные окружения для работы с секртеами Kubernetes
> 

#### Подготовка параметрв авторизации

```
controlplane $ echo 'admin' | base64
YWRtaW4K
controlplane $ 
controlplane $ echo 'password' | base64
cGFzc3dvcmQK
```
#### Dockerfile

* Вносим в образ переменные окружения с содержимым параметров аторизации
```
FROM busybox

ENV SUPER_USER=YWRtaW4K 

ENV PASS_W=cGFzc3dvcmQK

CMD sleep 3600
```




### Пример тестовой успешной сборки. Переменные читаются
```
ubuntu $ docker build -t zakharovnpa/k8s-busybox:01.08.22-2 .
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM busybox
 ---> 7a80323521cc
Step 2/4 : ENV SUPER_USER=YWRtaW4K
 ---> Running in b84f1a11fea8
Removing intermediate container b84f1a11fea8
 ---> 9b7341205b87
Step 3/4 : ENV PASS_W=cGFzc3dvcmQK
 ---> Running in 52cb4b8cc779
Removing intermediate container 52cb4b8cc779
 ---> cb37f87ab2a8
Step 4/4 : CMD sleep 3600
 ---> Running in ee37e96ef693
Removing intermediate container ee37e96ef693
 ---> 1eeed354ecd2
Successfully built 1eeed354ecd2
Successfully tagged zakharovnpa/k8s-busybox:01.08.22-2
```

```
ubuntu $ docker run -d zakharovnpa/k8s-busybox:01.08.22-2
1ea7b181c700a07c73943a224bb9282d8dd4e9d2125280d94d8d1b8c15ecf335
```

```
ubuntu $ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED         STATUS         PORTS     NAMES
1ea7b181c700   zakharovnpa/k8s-busybox:01.08.22-2   "/bin/sh -c 'sleep 3…"   6 seconds ago   Up 5 seconds             stoic_kalam
5963abcc0850   zakharovnpa/k8s-busybox:02.08.22     "/bin/sh -c 'sleep 3…"   5 minutes ago   Up 5 minutes             goofy_haslett
```

```
ubuntu $ docker exec -it stoic_kalam sh
/ # 
/ # env
HOSTNAME=1ea7b181c700
SHLVL=1
HOME=/root
TERM=xterm
PASS_W=cGFzc3dvcmQK
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
SUPER_USER=YWRtaW4K
/ # echo $SUPER_USER
YWRtaW4K
/ # 
/ # echo $PASS_W
cGFzc3dvcmQK
/ # 
/ # exit
```

```
ubuntu $ cat Dockerfile 
FROM busybox

ENV SUPER_USER=YWRtaW4K 

ENV PASS_W=cGFzc3dvcmQK

CMD sleep 3600
```
### Практическое создание образа и загрузка в реджистри
```
root@PC-Ubuntu:~/learning-kubernetis/secret# docker build -t zakharovnpa/k8s-busybox:02.08.22 .
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM busybox
latest: Pulling from library/busybox
50783e0dfb64: Pull complete 
Digest: sha256:ef320ff10026a50cf5f0213d35537ce0041ac1d96e9b7800bafd8bc9eff6c693
Status: Downloaded newer image for busybox:latest
 ---> 7a80323521cc
Step 2/4 : ENV SUPER_USER=YWRtaW4K
 ---> Running in ea905215a69c
Removing intermediate container ea905215a69c
 ---> f8d3dcc59b7b
Step 3/4 : ENV PASS_W=cGFzc3dvcmQK
 ---> Running in 88fa2ab2329e
Removing intermediate container 88fa2ab2329e
 ---> 89cef3d06bfa
Step 4/4 : CMD sleep 3600
 ---> Running in 66c3b1eaab52
Removing intermediate container 66c3b1eaab52
 ---> 9a661c880882
Successfully built 9a661c880882
Successfully tagged zakharovnpa/k8s-busybox:02.08.22
root@PC-Ubuntu:~/learning-kubernetis/secret# 
root@PC-Ubuntu:~/learning-kubernetis/secret# docker image list | grep busybox
zakharovnpa/k8s-busybox                                             02.08.22          9a661c880882   About a minute ago   1.24MB
busybox                                                             latest            7a80323521cc   3 days ago           1.24MB
root@PC-Ubuntu:~/learning-kubernetis/secret# 
root@PC-Ubuntu:~/learning-kubernetis/secret# docker push zakharovnpa/k8s-busybox:02.08.22
The push refers to repository [docker.io/zakharovnpa/k8s-busybox]
084326605ab6: Mounted from library/busybox 
02.08.22: digest: sha256:ca18e2401ab009f346871abbb543c3f50dbe372f100fdc2f835d92379365c25d size: 527
```

### Пример неуспешной сборки. Переменные не читаются. Причина - неверный знак " : ". Должен быть " = ". 
```
ubuntu $ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
ubuntu $ 
ubuntu $ ls
My-Project  filesystem
ubuntu $ 
ubuntu $ cd My-
bash: cd: My-: No such file or directory
ubuntu $ 
ubuntu $ pwd
/root
ubuntu $ 
ubuntu $ cd My-Project/
ubuntu $ 
ubuntu $ ls
Dockerfile
ubuntu $ 
ubuntu $ cat Dockerfile 
FROM busybox

ENV SUPER_USER: YWRtaW4K   # неверно. Должно быть так: SUPER_USER=YWRtaW4K

ENV PASS_W: cGFzc3dvcmQK   # неверно. Должно быть так: PASS_W=cGFzc3dvcmQK

CMD sleep 3600
ubuntu $ 
ubuntu $ docker image ls
REPOSITORY                TAG        IMAGE ID       CREATED          SIZE
zakharovnpa/k8s-busybox   02.08.22   785751c4fe4e   15 minutes ago   1.24MB
busybox                   latest     7a80323521cc   3 days ago       1.24MB
ubuntu $ 
ubuntu $ docker build -t zakharovnpa/k8s-busybox:01.08.22 .
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM busybox
 ---> 7a80323521cc
Step 2/4 : ENV SUPER_USER: YWRtaW4K
 ---> Using cache
 ---> 1b6b4dc582f0
Step 3/4 : ENV PASS_W: cGFzc3dvcmQK
 ---> Using cache
 ---> 12ca28eedbfa
Step 4/4 : CMD sleep 3600
 ---> Using cache
 ---> 785751c4fe4e
Successfully built 785751c4fe4e
Successfully tagged zakharovnpa/k8s-busybox:01.08.22
ubuntu $ 
ubuntu $ docker image ls
REPOSITORY                TAG        IMAGE ID       CREATED          SIZE
zakharovnpa/k8s-busybox   01.08.22   785751c4fe4e   16 minutes ago   1.24MB
zakharovnpa/k8s-busybox   02.08.22   785751c4fe4e   16 minutes ago   1.24MB
busybox                   latest     7a80323521cc   3 days ago       1.24MB
ubuntu $ 
ubuntu $ docker run -d zakharovnpa/k8s-busybox:02.08.22
5963abcc085080cb78b9d9934b098e6b31ba5a53d2e64311ac271410a8fc4ee9
ubuntu $ 
ubuntu $ docker ps
CONTAINER ID   IMAGE                              COMMAND                  CREATED          STATUS          PORTS     NAMES
5963abcc0850   zakharovnpa/k8s-busybox:02.08.22   "/bin/sh -c 'sleep 3…"   13 seconds ago   Up 12 seconds             goofy_haslett
ubuntu $ 
ubuntu $ docker exec -it goofy_haslett sh
/ # 
/ # env
HOSTNAME=5963abcc0850
SHLVL=1
HOME=/root
SUPER_USER:=YWRtaW4K
TERM=xterm
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
PWD=/
PASS_W:=cGFzc3dvcmQK
/ # 
/ # echo $SUPER_USER    # переменная не считывается

/ # 
/ # echo $SUPER_USER:    # переменная не считывается
:
/ # 
/ # echo $SUPER_USER    # переменная не считывается

/ # echo $PASS_W    # переменная не считывается

/ # 
/ # exit
ubuntu $ 
```

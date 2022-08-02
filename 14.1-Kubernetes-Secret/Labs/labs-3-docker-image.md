## ЛР-3. "Подготовка образа для задачи 2*."
* Tab 1
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

ENV SUPER_USER: YWRtaW4K 

ENV PASS_W: cGFzc3dvcmQK

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
/ # echo $SUPER_USER

/ # 
/ # echo $SUPER_USER:
:
/ # 
/ # echo $SUPER_USER

/ # echo $PASS_W

/ # 
/ # exit
ubuntu $ 
```

* Tab 1
```
ubuntu $ vi Dockerfile 
ubuntu $ 
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
ubuntu $ 
ubuntu $ 
ubuntu $ docker run -d zakharovnpa/k8s-busybox:01.08.22-2
1ea7b181c700a07c73943a224bb9282d8dd4e9d2125280d94d8d1b8c15ecf335
ubuntu $ 
ubuntu $ docker ps
CONTAINER ID   IMAGE                                COMMAND                  CREATED         STATUS         PORTS     NAMES
1ea7b181c700   zakharovnpa/k8s-busybox:01.08.22-2   "/bin/sh -c 'sleep 3…"   6 seconds ago   Up 5 seconds             stoic_kalam
5963abcc0850   zakharovnpa/k8s-busybox:02.08.22     "/bin/sh -c 'sleep 3…"   5 minutes ago   Up 5 minutes             goofy_haslett
ubuntu $ 
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
ubuntu $ 
ubuntu $ cat Do
cat: Do: No such file or directory
ubuntu $ cat Dockerfile 
FROM busybox

ENV SUPER_USER=YWRtaW4K 

ENV PASS_W=cGFzc3dvcmQK

CMD sleep 3600
ubuntu $ 
ubuntu $ 
```

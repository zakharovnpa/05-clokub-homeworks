### Logs
* Tab 1

```
Initialising Kubernetes... done

controlplane $ mkdir -p My-Project
controlplane $ 
controlplane $ cd My-Project/
controlplane $ 
controlplane $ touch user-token.txt
controlplane $ 
controlplane $ echo ‘aiphohTaa0eeHei’ > user-token.txt
controlplane $ 
controlplane $ kubectl create secret generic user-token --from-file=./user-token.txt
secret/user-token created
controlplane $ 
controlplane $ controlplane $ kubectl get secrets -o yaml
controlplane: command not found
controlplane $ 
controlplane $ kubectl get secrets -o yaml
apiVersion: v1
items:
- apiVersion: v1
  data:
    user-token.txt: 4oCYYWlwaG9oVGFhMGVlSGVp4oCZCg==
  kind: Secret
  metadata:
    creationTimestamp: "2022-08-04T12:13:57Z"
    name: user-token
    namespace: default
    resourceVersion: "2893"
    uid: 4420c704-7919-41c9-b736-1a7c23b749ac
  type: Opaque
kind: List
metadata:
  resourceVersion: ""
controlplane $ 
controlplane $ 
controlplane $ vim fedore-pod.yaml
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl ge tpo
error: unknown command "ge" for "kubectl"

Did you mean this?
        set
        get
        cp
controlplane $ 
controlplane $ kubectl get po
No resources found in default namespace.
controlplane $ 
controlplane $ kubectl get secrets 
NAME         TYPE     DATA   AGE
user-token   Opaque   1      2m11s
controlplane $ 
controlplane $ kubectl apply -f fedore-pod.yaml 
deployment.apps/one-fedora-pod created
service/fedora-pod created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS              RESTARTS   AGE
one-fedora-pod-899997876-kq6kt   0/2     ContainerCreating   0          4s
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS    RESTARTS   AGE
one-fedora-pod-899997876-kq6kt   2/2     Running   0          8s
controlplane $ 
controlplane $ 
controlplane $ vim vault-pod.yaml
controlplane $ 
controlplane $ kubectl apply -f vault-pod.yaml 
pod/14.2-netology-vault created
controlplane $ 
controlplane $ 
controlplane $ kubectl get po
NAME                             READY   STATUS    RESTARTS   AGE
14.2-netology-vault              1/1     Running   0          7s
one-fedora-pod-899997876-kq6kt   2/2     Running   0          114s
controlplane $ 
controlplane $ 
controlplane $ kubectl describe pod 14.2-netology-vault
Name:         14.2-netology-vault
Namespace:    default
Priority:     0
Node:         controlplane/172.30.1.2
Start Time:   Thu, 04 Aug 2022 12:18:08 +0000
Labels:       <none>
Annotations:  cni.projectcalico.org/containerID: 3416123796145e337151377be3ebcb35b12b2ae906e6f3c4f8a35cd068594894
              cni.projectcalico.org/podIP: 192.168.0.6/32
              cni.projectcalico.org/podIPs: 192.168.0.6/32
Status:       Running
IP:           192.168.0.6
IPs:
  IP:  192.168.0.6
Containers:
  vault:
    Container ID:   containerd://810dd1f63c930de08094608c6153d0896fab5a327d2761c0e14abb47ae4fa09c
    Image:          vault
    Image ID:       docker.io/library/vault@sha256:2ad46009703d3557c821ff50e26f4b107ac83ea4aeb5f8cec1e78a28685cf866
    Port:           8200/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Thu, 04 Aug 2022 12:18:12 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      VAULT_DEV_ROOT_TOKEN_ID:   aiphohTaa0eeHei
      VAULT_DEV_LISTEN_ADDRESS:  0.0.0.0:8200
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-l2g8p (ro)
Conditions:
  Type              Status
  Initialized       True 
  Ready             True 
  ContainersReady   True 
  PodScheduled      True 
Volumes:
  kube-api-access-l2g8p:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason     Age   From               Message
  ----    ------     ----  ----               -------
  Normal  Scheduled  67s   default-scheduler  Successfully assigned default/14.2-netology-vault to controlplane
  Normal  Pulling    67s   kubelet            Pulling image "vault"
  Normal  Pulled     63s   kubelet            Successfully pulled image "vault" in 3.992736763s
  Normal  Created    63s   kubelet            Created container vault
  Normal  Started    63s   kubelet            Started container vault
controlplane $ 
controlplane $                                         
controlplane $ 
controlplane $ 
controlplane $ kubectl get pod 14.2-netology-vault -o json | jq -c '.status.podIPs'
[{"ip":"192.168.0.6"}]
controlplane $ 
controlplane $ kubectl exec one-fedora-pod-899997876-kq6kt -it bash -c one-fedora 
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# dnf -y install pip
Fedora 36 - x86_64                                                                                                               27 MB/s |  81 MB     00:03    
Fedora 36 openh264 (From Cisco) - x86_64                                                                                        2.3 kB/s | 2.5 kB     00:01    
Fedora Modular 36 - x86_64                                                                                                      3.5 MB/s | 2.4 MB     00:00    
Fedora 36 - x86_64 - Updates                                                                                                     29 MB/s |  25 MB     00:00    
Fedora Modular 36 - x86_64 - Updates                                                                                            2.2 MB/s | 2.4 MB     00:01    
Dependencies resolved.
================================================================================================================================================================
 Package                                      Architecture                     Version                                   Repository                        Size
================================================================================================================================================================
Installing:
 python3-pip                                  noarch                           21.3.1-2.fc36                             fedora                           1.8 M
Installing weak dependencies:
 libxcrypt-compat                             x86_64                           4.4.28-1.fc36                             fedora                            90 k
 python3-setuptools                           noarch                           59.6.0-2.fc36                             fedora                           936 k

Transaction Summary
================================================================================================================================================================
Install  3 Packages

Total download size: 2.8 M
Installed size: 14 M
Downloading Packages:
(1/3): libxcrypt-compat-4.4.28-1.fc36.x86_64.rpm                                                                                798 kB/s |  90 kB     00:00    
(2/3): python3-setuptools-59.6.0-2.fc36.noarch.rpm                                                                              4.3 MB/s | 936 kB     00:00    
(3/3): python3-pip-21.3.1-2.fc36.noarch.rpm                                                                                     7.3 MB/s | 1.8 MB     00:00    
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                           3.7 MB/s | 2.8 MB     00:00     
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                        1/1 
  Installing       : python3-setuptools-59.6.0-2.fc36.noarch                                                                                                1/3 
  Installing       : libxcrypt-compat-4.4.28-1.fc36.x86_64                                                                                                  2/3 
  Installing       : python3-pip-21.3.1-2.fc36.noarch                                                                                                       3/3 
  Running scriptlet: python3-pip-21.3.1-2.fc36.noarch                                                                                                       3/3 
  Verifying        : libxcrypt-compat-4.4.28-1.fc36.x86_64                                                                                                  1/3 
  Verifying        : python3-pip-21.3.1-2.fc36.noarch                                                                                                       2/3 
  Verifying        : python3-setuptools-59.6.0-2.fc36.noarch                                                                                                3/3 

Installed:
  libxcrypt-compat-4.4.28-1.fc36.x86_64                 python3-pip-21.3.1-2.fc36.noarch                 python3-setuptools-59.6.0-2.fc36.noarch                

Complete!
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# pip install hvac
Collecting hvac
  Downloading hvac-0.11.2-py2.py3-none-any.whl (148 kB)
     |████████████████████████████████| 148 kB 6.7 MB/s            
Collecting requests>=2.21.0
  Downloading requests-2.28.1-py3-none-any.whl (62 kB)
     |████████████████████████████████| 62 kB 855 kB/s             
Collecting six>=1.5.0
  Downloading six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting certifi>=2017.4.17
  Downloading certifi-2022.6.15-py3-none-any.whl (160 kB)
     |████████████████████████████████| 160 kB 16.0 MB/s            
Collecting charset-normalizer<3,>=2
  Downloading charset_normalizer-2.1.0-py3-none-any.whl (39 kB)
Collecting urllib3<1.27,>=1.21.1
  Downloading urllib3-1.26.11-py2.py3-none-any.whl (139 kB)
     |████████████████████████████████| 139 kB 16.2 MB/s            
Collecting idna<4,>=2.5
  Downloading idna-3.3-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 4.9 MB/s             
Installing collected packages: urllib3, idna, charset-normalizer, certifi, six, requests, hvac
Successfully installed certifi-2022.6.15 charset-normalizer-2.1.0 hvac-0.11.2 idna-3.3 requests-2.28.1 six-1.16.0 urllib3-1.26.11
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# Python3
bash: Python3: command not found
[root@one-fedora-pod-899997876-kq6kt /]# 
[root@one-fedora-pod-899997876-kq6kt /]# python3
Python 3.10.4 (main, Mar 25 2022, 00:00:00) [GCC 12.0.1 20220308 (Red Hat 12.0.1-0)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
>>> 
>>> import hvac
>>> # Подключение и проверка
>>> client = hvac.Client(
... url='http://192.168.0.6:8200',
... token='aiphohTaa0eeHei'
... )
>>> client.is_authenticated()
True
>>> # Пишем секрет
>>> client.secrets.kv.v2.create_or_update_secret(
... path='hvac',
... secret=dict(netology='Big secret!!!'),
... )
{'request_id': '764b987f-b8f7-27ba-dd0f-015bbc8b0354', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'created_time': '2022-08-04T12:24:01.022781242Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> # Читаем секрет
>>> client.secrets.kv.v2.read_secret_version(
... path='hvac',
... )
{'request_id': '4a5c9326-bd69-0e10-362e-3e05b7633050', 'lease_id': '', 'renewable': False, 'lease_duration': 0, 'data': {'data': {'netology': 'Big secret!!!'}, 'metadata': {'created_time': '2022-08-04T12:24:01.022781242Z', 'custom_metadata': None, 'deletion_time': '', 'destroyed': False, 'version': 1}}, 'wrap_info': None, 'warnings': None, 'auth': None}
>>> 
>>> 
>>> 
KeyboardInterrupt
>>> 
```

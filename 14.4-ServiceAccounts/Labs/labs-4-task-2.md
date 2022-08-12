## ЛР-4. Выполнение ДЗ. Задача 2(*)



```
Initialising Kubernetes... done

controlplane $ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeU1EVXdPREU1TXpFMU5sb1hEVE15TURVd05URTVNekUxTmxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTEh3Ck5NRjNvM254Q2o5MTJVNm5SY09nUUZWODJqMUtlYlYzblljdlhaTVdWWWhpcXE3TEczVEtHcW1LMFYwVUNhZ04KWnB4MFdBTENXa0hQdjlmSk00RzMvYkdUTVIzeTU5cGlEaXNBTmswUHgzNFE1ME5HQndjRzJGY1FPZHhsbkl1YwpieHpvZVZpMUJtQTd4aEhnaU9Qa2RhbndVWkJFS1ZVaUNoSytrNThZcEZHZkpQRnBpd1BTWTQrTVZhYlRVYUprCjVuUkNMcWhmam0zUW1LeDA2MXU2aEI4Ym1reTQrc2NxR2lYMVhDQUpyYjZNSHpDYkpLTFRwMk9xcTZJdEhBeUoKcjBjL29uTTQvNVUwZVpwSXRTSkNyNVhWUmRUZ2lqdk9uUDVtTU5kRG1PU2lDWTNsK1ZsQzdTRmtqYSs2TTNQbgpad3JTMGFqcWNNMzk3OC8rS2VrQ0F3RUFBYU5aTUZjd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZEcG41bzA4YVl3S2ZucUovdzFMaVkwbDg3MTdNQlVHQTFVZEVRUU8KTUF5Q0NtdDFZbVZ5Ym1WMFpYTXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBRVZYa1FLM05OMXNuQk93RWJZeQpQeTg3Y082dHRCN2Nnd09pNmYzeEtIQWJ0OXlObFg2VVJDYXlrTUR4OE9odFBQVERIOUNpUXlscFlSQUhOUVpGCkhlQ1R5Tmg3SDhGSHE2UVA1SEVleDAyTzFWMUNsVGVyUkRDVmo1b1JEa0djTHVyRnpObGE1Y2NkRDhGWElsS1oKbTZpRGszck9xTW41QzJjZFM4NHRtMjFPRzFiVnh1TDk2UTdOUGRKL05ERGJybTlsMENKUnhIdHBHOUVWQS9vcAowQUY5QWVFTE1HdEZsYWRjenBNYUUxM3JEeHZpMXd5VFZOOCswM3A4QWxuMFBYTTkzZER3VGZFRGw1NDlLbDNMCm1NbjdDclFHd3lKSVB0bWRWOUU3bmM3emZXNWFsOFdsYm40MUgyUjVRZG1kRllZQ0NvZXcxMnplN3A2RmdzOGEKaTNVPQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://172.30.1.2:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURJVENDQWdtZ0F3SUJBZ0lJQ3ZORFh5eVpaWEV3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TWpBMU1EZ3hPVE14TlRaYUZ3MHlNekExTURneE9UTXlNREJhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXZUUnYrYTNFRWI5ZlV1bCsKSEI5dUJhZVJJVDlKOUd3Q21TRXg3d3d2TDR2b0hwSmRnNWloRlU3MnByME1QSGNKR0lNWnlmV2pUOWU4RjFPdgp0bmtjdzBmYmNXek5zZHJlUWhlT0szT0tYK2Jja21iOUFuVkY2QVZFZUFLenBFNWhVRndaN1ZSSkQ1UmJDdlBvCjAyK3JiSUtEU0FRTkhTTHZWK1VGdlBPT0tlN1lmUmFrbGZKTEpaRTFtWGVuKzNrREhZayttOFhpZXJTU2lpa1MKSHg4QXA5enliR3N1UnBPdFdBd2JtT3gvVDdEaHE1NXhLQWxpcWRJcFFNQkliZUkxN1ZIYjhOQTFtclM2ZWZzYwpyZHdrOXg3aGt2TUdlaVNxb0NrVlBYMmZKODlSNGRYSmY2alJmcWRZZTFCT0h5VkFhamtPaDlOUjJ6ZDVBK2IrCjh3ZFhXd0lEQVFBQm8xWXdWREFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0RBWURWUjBUQVFIL0JBSXdBREFmQmdOVkhTTUVHREFXZ0JRNlorYU5QR21NQ241NmlmOE5TNG1OSmZPOQplekFOQmdrcWhraUc5dzBCQVFzRkFBT0NBUUVBWm11amJJbTZ0VjdKaTNoVURJRmp5YkFLS29jMHN0aFJ1YlZVCllHb2lFN1pNdzBrU3FIMkJHa2dUMEUwM1oxVkpJVjZTWVdlZnZVNzJvYVYyTmp6NzFYaXpqWlVFRVg3dkRZK1QKUkxsbC95b0ZEaDZscG5CUVVXN3pBODd3K3h1M3dVU0lyUU52UWNIMGpGNEhOT1dZMVZnb2c3UnEwTjVDWEh4UQpFRDMwVGYxUE5YM0ZZeHFONUR6bVc0bGw4Q3lrTDhrRGVEVWd5L24zUlBZNUJZUmZ1V1BDeTZzell2d2xIeTlTCjFvN0c1M2JlQ3ZvbXdnWHM4Z05CZ1d5RjMxVUM4TkJvYjdKV0gyTVJHNy9uRGR2TlZ1Skx0aVl0b2xGcmw0SUMKNW4vaStIYnpLbzh1S0RlbDdJSGkwMnQ5d05LbFUrYUFNaTN0TXUxdXhnSVQrVG1ubWc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcFFJQkFBS0NBUUVBdlRSdithM0VFYjlmVXVsK0hCOXVCYWVSSVQ5SjlHd0NtU0V4N3d3dkw0dm9IcEpkCmc1aWhGVTcycHIwTVBIY0pHSU1aeWZXalQ5ZThGMU92dG5rY3cwZmJjV3pOc2RyZVFoZU9LM09LWCtiY2ttYjkKQW5WRjZBVkVlQUt6cEU1aFVGd1o3VlJKRDVSYkN2UG8wMityYklLRFNBUU5IU0x2VitVRnZQT09LZTdZZlJhawpsZkpMSlpFMW1YZW4rM2tESFlrK204WGllclNTaWlrU0h4OEFwOXp5YkdzdVJwT3RXQXdibU94L1Q3RGhxNTV4CktBbGlxZElwUU1CSWJlSTE3VkhiOE5BMW1yUzZlZnNjcmR3azl4N2hrdk1HZWlTcW9Da1ZQWDJmSjg5UjRkWEoKZjZqUmZxZFllMUJPSHlWQWFqa09oOU5SMnpkNUErYis4d2RYV3dJREFRQUJBb0lCQUF6MDhsWWUyRForN0lBNQpEVEhQMVREOThLcGVNeXBSMnp1eFVrSVVpNGF1Qmc5UjVxV0Vaa09YVEx6T1pYQWVscmpmQVgwYkhUdnlnaWIyCnpDbXEwWlZ0N2xFdUtrZnJ2Unk1a0RyWmhyaGFqdkJYclN2bDdBdWZrTGpITnBZaDUvZ2cxb1d5Sis2eE1pcmwKMlNQaG1kT3NmR0VLSmZ2QTBMTXNNK0JrclcraGxYdVM4bDl0TnVNTGlFR0lTNCswcURtYVAzSDZhK0RqYU91dgp0YnVpWThKL2lRZDdsZ2huU2JkcDRONWtGV3VGQlZzNmkxaEdzclVMTTZ3VUR6Z0pQNHJaL0xMdnlhUUpFNHUvClVXUGFhcFlBckFmR0FyK3pEaEx0dXFNTjA1WGdIT2ZYZjc4UERXcmtWTnQrRXNVUEluZ1lkQUNxcEhJWVAwUXkKRUJLdXg0RUNnWUVBMThkTDJ1aWR1TmQ3VDZHalZqUnk4MkdFRFU0aDB4RUlBYU9XN2ZWaE5EV0l3T1MzdzRpRgpPcjBCY0VZVFY5TU1VSkozVVZVcjdKUFR0YWp2MlRNTlQrbit6ZDVJT05IbkljQkFqU3VMbEh0M0FvZDJNOUJRCmlSNlU5R3FwdTZIRkU1NGNHbnNzS1ZMUkRLV1Brd3V3UXNjczllM1pWWnE1bHorQm9YSXNqcmtDZ1lFQTRIa1QKZGdpZWw4UWk4WXN4SHFzczJuRi9iY0Q4UVBhNFU4M2twOW5nZzV5VVZhTFJPRkdhYTJEaUNqbDN2UzlpV1dsNAo0MjF4bVFKOXVlaVpmSytmL1ExR3duOVdjV0xqRVdDVTJVRFh1ZnduaHZLNnZWaTZQMGhTR1hwR0RHSEhkZkJzCklhTmJpOFNiY2JoaGRSUkMwbFJrWTlUcmpDNXRZRjk0dm00MTdMTUNnWUVBbWZXSWlTeGFoUzJ5dlZHK2dsNnYKK2pvRkI1MU5BeFZ1MmdTSVIwZEMwUWExaWJSbjdlczE3SUE1UzR1a2Q1Q05nOXZOcU1tVnFwcWJmMDJIdlRqdwo4YWtxOW1iNHJ4b055WVlzU00zZUxOYWZScjJ5dUN1Vm14Q29CWEVwcEVnN250QzhpcVNDRVFZWFJPZklkb25yCmZPb3lpVkxwTkd4T3FiMVZXQVZvQjNrQ2dZRUFzbC9FRlRGNFJRVjQ5eFF5cmpvNzVFSDRqdENpSTBWcTZEMWUKaS90WXEzMExhcGw5UkJHa2NkdUZBN2J5N1lUdjFEazU5UStOQzVldExNUW00NnZ6cUhTYVhBZ3dPdDNucm5GZgpGdHl1RUg3Tk1qRkVMeDZJc2F6WWdLSm5jNE5ucXRLb09uckRUbWVuVmxDOE1Qc3V0bENWamJjdWpqQitmZXlmCjJFTmYybjBDZ1lFQTF6ajI0L3dXTzJ5akxQalBlS1RUdU5MZ1IwRTdQWVN0bDYyQ3JrMUJtRHh4eERKeFYycFcKbkxHeWpBdTIrUFYzakVIL213TVo3YVozUXpQM1RUZnVlRFpvTG1pWDdDQVhWL1Z4Y3VqVkFKZm1ocUdaVDRIRgpNa0pwanZkSlVCSVJIMW54RnBIaTgrS1VES09MS3dYUkx6WXdIUlN4VDQ3VU5WU1lDdHg4S2hBPQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl cluster-info
Kubernetes control plane is running at https://172.30.1.2:6443
CoreDNS is running at https://172.30.1.2:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
controlplane $ 
controlplane $ 
controlplane $ 
controlplane $ kubectl run -i --tty fedora --image=fedora --restart=Never -- sh
If you don't see a command prompt, try pressing enter.
sh-5.1# 
sh-5.1# 
sh-5.1# env | grep KUBE
KUBERNETES_SERVICE_PORT_HTTPS=443
KUBERNETES_SERVICE_PORT=443
KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PROTO=tcp
KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
KUBERNETES_SERVICE_HOST=10.96.0.1
KUBERNETES_PORT=tcp://10.96.0.1:443
KUBERNETES_PORT_443_TCP_PORT=443
sh-5.1# 
sh-5.1# 
sh-5.1# K8S=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT
sh-5.1# 
sh-5.1# echo $K8S
https://10.96.0.1:443
sh-5.1# 
sh-5.1# SADIR=/var/run/secrets/kubernetes.io/serviceaccount
sh-5.1# 
sh-5.1# echo $SADIR
/var/run/secrets/kubernetes.io/serviceaccount
sh-5.1# 
sh-5.1# TOKEN=$(cat $SADIR/token)
sh-5.1# 
sh-5.1# echo $TOKEN
eyJhbGciOiJSUzI1NiIsImtpZCI6ImVBaDNDeElCdG9jU3BQNmZOVTB4N1MwWlBrVGY4d2F1M191SnY2S0hETTgifQ.eyJhdWQiOlsiaHR0cHM6Ly9rdWJlcm5ldGVzLmRlZmF1bHQuc3ZjLmNsdXN0ZXIubG9jYWwiXSwiZXhwIjoxNjkxODIxMTM4LCJpYXQiOjE2NjAyODUxMzgsImlzcyI6Imh0dHBzOi8va3ViZXJuZXRlcy5kZWZhdWx0LnN2Yy5jbHVzdGVyLmxvY2FsIiwia3ViZXJuZXRlcy5pbyI6eyJuYW1lc3BhY2UiOiJkZWZhdWx0IiwicG9kIjp7Im5hbWUiOiJmZWRvcmEiLCJ1aWQiOiI1YjI3ZmIyZC1hN2U4LTQ2OGYtYjdiMS1kMTI3ODQ4NTY4YzcifSwic2VydmljZWFjY291bnQiOnsibmFtZSI6ImRlZmF1bHQiLCJ1aWQiOiI4MzhmNGRlNC0xZTk5LTQzYzAtODFhYy0zNWU0ODczMGQyODkifSwid2FybmFmdGVyIjoxNjYwMjg4NzQ1fSwibmJmIjoxNjYwMjg1MTM4LCJzdWIiOiJzeXN0ZW06c2VydmljZWFjY291bnQ6ZGVmYXVsdDpkZWZhdWx0In0.j8wuKygWGvZSOOGZucXlmLqLT39JsyeFGonCWElQbmHSytW3Kk91XhMl5MqMAXLfKyMrHIVwCkO2PzAqyltoYLehngq6a3r6q1Pu2jTueP4wEN0FxdO-SukA1-fBJCPD0Pq16hsWFqZywgQAcdQtP0-DzWv2_sFriRjE-tP5ckoZbMPDQGnE9ZrFodPQ1R6dfaB8sl-sKAfL7vdtdgOlgBj7kfCWDSyWnoD1IVFSsYObP8GRkKiGbx9eCaVVWXU1mAnG_sSx-eACer4sZrUbF_3HXXTeI11OLNycHixUG_-Ss8lsbjuT9mM4w3hm8VaLDLkF0NFFITzZQhZ0j9DlQQ
sh-5.1# 
sh-5.1# CACERT=$SADIR/ca.crt
sh-5.1# 
sh-5.1# echo $CACERT
/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
sh-5.1# 
sh-5.1# NAMESPACE=$(cat $SADIR/namespace)
sh-5.1# 
sh-5.1# echo $NAMESPACE
default
sh-5.1# 
sh-5.1# $K8S/api/v1/
sh: https://10.96.0.1:443/api/v1/: No such file or directory
sh-5.1# 
sh-5.1# curl -H "Authorization: Bearer $TOKEN" --cacert $CACERT $K8S/api/v1/
{
  "kind": "APIResourceList",
  "groupVersion": "v1",
  "resources": [
    {
      "name": "bindings",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "componentstatuses",
      "singularName": "",
      "namespaced": false,
      "kind": "ComponentStatus",
      "verbs": [
        "get",
        "list"
      ],
      "shortNames": [
        "cs"
      ]
    },
    {
      "name": "configmaps",
      "singularName": "",
      "namespaced": true,
      "kind": "ConfigMap",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "cm"
      ],
      "storageVersionHash": "qFsyl6wFWjQ="
    },
    {
      "name": "endpoints",
      "singularName": "",
      "namespaced": true,
      "kind": "Endpoints",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ep"
      ],
      "storageVersionHash": "fWeeMqaN/OA="
    },
    {
      "name": "events",
      "singularName": "",
      "namespaced": true,
      "kind": "Event",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ev"
      ],
      "storageVersionHash": "r2yiGXH7wu8="
    },
    {
      "name": "limitranges",
      "singularName": "",
      "namespaced": true,
      "kind": "LimitRange",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "limits"
      ],
      "storageVersionHash": "EBKMFVe6cwo="
    },
    {
      "name": "namespaces",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "create",
        "delete",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "ns"
      ],
      "storageVersionHash": "Q3oi5N2YM8M="
    },
    {
      "name": "namespaces/finalize",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "update"
      ]
    },
    {
      "name": "namespaces/status",
      "singularName": "",
      "namespaced": false,
      "kind": "Namespace",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "nodes",
      "singularName": "",
      "namespaced": false,
      "kind": "Node",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "no"
      ],
      "storageVersionHash": "XwShjMxG9Fs="
    },
    {
      "name": "nodes/proxy",
      "singularName": "",
      "namespaced": false,
      "kind": "NodeProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "nodes/status",
      "singularName": "",
      "namespaced": false,
      "kind": "Node",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "persistentvolumeclaims",
      "singularName": "",
      "namespaced": true,
      "kind": "PersistentVolumeClaim",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "pvc"
      ],
      "storageVersionHash": "QWTyNDq0dC4="
    },
    {
      "name": "persistentvolumeclaims/status",
      "singularName": "",
      "namespaced": true,
      "kind": "PersistentVolumeClaim",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "persistentvolumes",
      "singularName": "",
      "namespaced": false,
      "kind": "PersistentVolume",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "pv"
      ],
      "storageVersionHash": "HN/zwEC+JgM="
    },
    {
      "name": "persistentvolumes/status",
      "singularName": "",
      "namespaced": false,
      "kind": "PersistentVolume",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "po"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "xPOwRZ+Yhw8="
    },
    {
      "name": "pods/attach",
      "singularName": "",
      "namespaced": true,
      "kind": "PodAttachOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/binding",
      "singularName": "",
      "namespaced": true,
      "kind": "Binding",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "pods/ephemeralcontainers",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods/eviction",
      "singularName": "",
      "namespaced": true,
      "group": "policy",
      "version": "v1",
      "kind": "Eviction",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "pods/exec",
      "singularName": "",
      "namespaced": true,
      "kind": "PodExecOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/log",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get"
      ]
    },
    {
      "name": "pods/portforward",
      "singularName": "",
      "namespaced": true,
      "kind": "PodPortForwardOptions",
      "verbs": [
        "create",
        "get"
      ]
    },
    {
      "name": "pods/proxy",
      "singularName": "",
      "namespaced": true,
      "kind": "PodProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "pods/status",
      "singularName": "",
      "namespaced": true,
      "kind": "Pod",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "podtemplates",
      "singularName": "",
      "namespaced": true,
      "kind": "PodTemplate",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "storageVersionHash": "LIXB2x4IFpk="
    },
    {
      "name": "replicationcontrollers",
      "singularName": "",
      "namespaced": true,
      "kind": "ReplicationController",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "rc"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "Jond2If31h0="
    },
    {
      "name": "replicationcontrollers/scale",
      "singularName": "",
      "namespaced": true,
      "group": "autoscaling",
      "version": "v1",
      "kind": "Scale",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "replicationcontrollers/status",
      "singularName": "",
      "namespaced": true,
      "kind": "ReplicationController",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "resourcequotas",
      "singularName": "",
      "namespaced": true,
      "kind": "ResourceQuota",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "quota"
      ],
      "storageVersionHash": "8uhSgffRX6w="
    },
    {
      "name": "resourcequotas/status",
      "singularName": "",
      "namespaced": true,
      "kind": "ResourceQuota",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "secrets",
      "singularName": "",
      "namespaced": true,
      "kind": "Secret",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "storageVersionHash": "S6u1pOWzb84="
    },
    {
      "name": "serviceaccounts",
      "singularName": "",
      "namespaced": true,
      "kind": "ServiceAccount",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "sa"
      ],
      "storageVersionHash": "pbx9ZvyFpBE="
    },
    {
      "name": "serviceaccounts/token",
      "singularName": "",
      "namespaced": true,
      "group": "authentication.k8s.io",
      "version": "v1",
      "kind": "TokenRequest",
      "verbs": [
        "create"
      ]
    },
    {
      "name": "services",
      "singularName": "",
      "namespaced": true,
      "kind": "Service",
      "verbs": [
        "create",
        "delete",
        "deletecollection",
        "get",
        "list",
        "patch",
        "update",
        "watch"
      ],
      "shortNames": [
        "svc"
      ],
      "categories": [
        "all"
      ],
      "storageVersionHash": "0/CO1lhkEBI="
    },
    {
      "name": "services/proxy",
      "singularName": "",
      "namespaced": true,
      "kind": "ServiceProxyOptions",
      "verbs": [
        "create",
        "delete",
        "get",
        "patch",
        "update"
      ]
    },
    {
      "name": "services/status",
      "singularName": "",
      "namespaced": true,
      "kind": "Service",
      "verbs": [
        "get",
        "patch",
        "update"
      ]
    }
  ]
}sh-5.1# 
sh-5.1# 
sh-5.1# 
sh-5.1# 
sh-5.1# 
sh-5.1# 
```

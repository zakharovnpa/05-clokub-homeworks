## Параметры инстансов, собранные утилитой `yc`

### Команды просмотра ресурсов
- yc compute instance list
- yc compute instance show `<ID instance>`
  
  
- `yc compute instance list`
  
```
+----------------------+----------+---------------+---------+----------------+----------------+
|          ID          |   NAME   |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP   |
+----------------------+----------+---------------+---------+----------------+----------------+
| epdflvg75uk87usfmkak | backend  | ru-central1-b | RUNNING |                | 192.168.20.11  |
| fhm4c91boanneufe60kt | a-123    | ru-central1-a | RUNNING | 51.250.92.218  | 10.128.0.11    |
| fhmgecbnao9g5s90f7jm | natgw    | ru-central1-a | RUNNING | 158.160.34.206 | 192.168.10.254 |
| fhmm57js01viubopn0qg | frontend | ru-central1-a | RUNNING | 158.160.32.3   | 192.168.10.11  |
+----------------------+----------+---------------+---------+----------------+----------------+
```
  
#### Параметры natgw
  
  * `yc compute instance show fhmgecbnao9g5s90f7jm`
```yml
id: fhmgecbnao9g5s90f7jm
folder_id: b1gd3hm4niaifoa8dahm
created_at: "2022-12-14T06:59:25Z"
name: natgw
zone_id: ru-central1-a
platform_id: standard-v1
resources:
  memory: "8589934592"
  cores: "4"
  core_fraction: "100"
status: RUNNING
boot_disk:
  mode: READ_WRITE
  device_name: fhm2f3943suggccb7cil
  auto_delete: true
  disk_id: fhm2f3943suggccb7cil
network_interfaces:
- index: "0"
  mac_address: d0:0d:10:73:17:75
  subnet_id: e9bj5g0hpplpn3gg4ahj
  primary_v4_address:
    address: 192.168.10.254
    one_to_one_nat:
      address: 158.160.34.206
      ip_version: IPV4
fqdn: natgw.netology.yc
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}
```
### Параметры frontend
  
- yc compute instance show fhmm57js01viubopn0qg
```yml
id: fhmm57js01viubopn0qg
folder_id: b1gd3hm4niaifoa8dahm
created_at: "2022-12-14T06:59:25Z"
name: frontend
zone_id: ru-central1-a
platform_id: standard-v1
resources:
  memory: "8589934592"
  cores: "4"
  core_fraction: "100"
status: RUNNING
boot_disk:
  mode: READ_WRITE
  device_name: fhmu360qn3sumag0uq7j
  auto_delete: true
  disk_id: fhmu360qn3sumag0uq7j
network_interfaces:
- index: "0"
  mac_address: d0:0d:16:29:e7:c0
  subnet_id: e9bj5g0hpplpn3gg4ahj
  primary_v4_address:
    address: 192.168.10.11
    one_to_one_nat:
      address: 158.160.32.3
      ip_version: IPV4
fqdn: frontend.netology.yc
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}
```
### Параметры backend
- yc compute instance show epdflvg75uk87usfmkak
```yml
id: epdflvg75uk87usfmkak
folder_id: b1gd3hm4niaifoa8dahm
created_at: "2022-12-14T07:00:49Z"
name: backend
zone_id: ru-central1-b
platform_id: standard-v1
resources:
  memory: "8589934592"
  cores: "4"
  core_fraction: "20"
status: RUNNING
boot_disk:
  mode: READ_WRITE
  device_name: epd7jkecrmeh0okd8t1o
  auto_delete: true
  disk_id: epd7jkecrmeh0okd8t1o
network_interfaces:
- index: "0"
  mac_address: d0:0d:fa:fe:07:2f
  subnet_id: e2lahnk300k301sp59pp
  primary_v4_address:
    address: 192.168.20.11
fqdn: backend.netology.yc
scheduling_policy: {}
network_settings:
  type: STANDARD
placement_policy: {}
```
### Параметры тестовго инстанса 123
- yc compute instance show fhm4c91boanneufe60kt
```yml
id: fhm4c91boanneufe60kt
folder_id: b1gd3hm4niaifoa8dahm
created_at: "2022-12-14T06:51:55Z"
name: a-123
description: a-123
zone_id: ru-central1-a
platform_id: standard-v3
resources:
  memory: "1073741824"
  cores: "2"
  core_fraction: "20"
status: RUNNING
boot_disk:
  mode: READ_WRITE
  device_name: fhmrj78523uuk1pas664
  auto_delete: true
  disk_id: fhmrj78523uuk1pas664
network_interfaces:
- index: "0"
  mac_address: d0:0d:46:24:2b:c2
  subnet_id: e9bi82druit5rcjcbn14
  primary_v4_address:
    address: 10.128.0.11
    one_to_one_nat:
      address: 51.250.92.218
      ip_version: IPV4
fqdn: a-123.ru-central1.internal
scheduling_policy:
  preemptible: true
network_settings:
  type: STANDARD
placement_policy: {}
```

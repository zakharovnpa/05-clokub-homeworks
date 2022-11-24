### Лекция по теме "15.1 Органзаця сети"


#### как настравать сеть в AWS - 00:47:30
- 00:48:50 - create VPC
  - IPv4 CIDR
  - routing table
- 00:50:20 - create Subnet
- 00:53:40 - включение настройки (Enable auto-assign public IPv4 address) для автоматического присвоения внешнего IP адреса создаваемым ВМ в этой подсети  
- 00:54:10 - создание InternetGW. Create internet gateway. И привязать его к VPC. Attach to VPC. Теперь будет доступ в Итернет
- 00:54:50 - создание NAT gateway. И прикручваем его к подсети Public. И даем NAT gateway публичный IP (Allocate Elastic IP)
- 00:56:40 - создание Network ACL. Смотрим настройки Inbound Rules. Должно быть все разрешено и должна быть првязка к подсетям
- 00:57:10 - создание Security Group

#### как настравать ВМ в AWS - 01:01:10
- Одну ВМ создать в Public подсети, а вторую ВМ - в Private и посмотрим как будет ходить трафик.
- 01:01:45 - чем отлчается InternetGW от NatGW. InternetGW - это амазоновская штука для разрешения трафка из Интренета в VPC. NatGW - это кода мы разрешаем нат в нтернет.
- 01:02:25 - создание ВМ frontend в подсети Public
- 01:09:00 - создание ВМ backend в подсети Private. Пркручиваем к Security group SSH, ICMP. 
- 01:10:20 - попытки подключеня к ВМ
- 01:12:00 - указание  дефолтового маршрута для InternetGW в Routing Table
- 01:13:30 - подключились к frontend
  - пингуем backend. Отвечает
  - переносм ключ ssh на ВМ frontend
- 10:16:20 - подключаемся с frontend на backend. 
- 10:17:20 - с backend нет доступа к Интернет
- 10:18:10 - пояснение ситуации. Нужно сделать так, чтобы трафк с backend ходил через NatGW. Для этого нужен маршрут на NatGW. 
ВМ frontend выходт в Итнернет через InternetGW свом белым адресом. У NatGW тоже есть свой белый адрес. Теперь нам нужен маршрут для хождения трафика
с backend в Итнернет через NatGW
- 01:19:40 - нужно создать отдельную таблцу маршрутизации, которую мы повесим на приватную подсеть.
- 01:20:30 - создание Routing table для NatGW
- 01:22:20 - результат. Есть выход в нтернет с ВМ backend через NatGW (и его ip)

#### как настравать сеть в Yandex.Cloud - 01:23:50
- 01:24:00 - создаем VPC. Первым делом необходимо создать сеть для VPC. 
- 01:24:04 - Создаем сеть для VPC. Здесь нет настройки блока ip адресов для VPC. Это будет в настройках подсети.
  - код для терраформа. Ресурс [yandex_vpc_network](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network#argument-reference)
```tf
resource "yandex_vpc_network" "netology-vpc" {
  name = "netology-vpc"
}
```
- Аргументы для блока [сетей](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network#argument-reference)
```sh
The following arguments are supported:

name - (Optional) Name of the network. Provided by the client when the network is created.

description - (Optional) An optional description of this resource. Provide this property when you create the resource.

folder_id - (Optional) ID of the folder that the resource belongs to. If it is not provided, the default provider folder is used.

labels - (Optional) Labels to apply to this network. A list of key/value pairs.
```
- 01:24:30 - создание подсети public
  - код для терраформа.  Ресурс [yandex_vpc_subnet](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
```tf
resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["192.168.10.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.netology-vpc.id}"
}
```
- Аргументы для блока [подсетей](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet#argument-reference)
```sh
The following arguments are supported:

network_id - (Required) ID of the network this subnet belongs to. Only networks that are in the distributed mode can have subnets.

v4_cidr_blocks - (Required) A list of blocks of internal IPv4 addresses that are owned by this subnet. Provide this property when you create the subnet. For example, 10.0.0.0/22 or 192.168.0.0/16. Blocks of addresses must be unique and non-overlapping within a network. Minimum subnet size is /28, and maximum subnet size is /16. Only IPv4 is supported.

zone - (Required) Name of the Yandex.Cloud zone for this subnet.

name - (Optional) Name of the subnet. Provided by the client when the subnet is created.

description - (Optional) An optional description of the subnet. Provide this property when you create the resource.

folder_id - (Optional) The ID of the folder to which the resource belongs. If omitted, the provider folder is used.

labels - (Optional) Labels to assign to this subnet. A list of key/value pairs.

route_table_id - (Optional) The ID of the route table to assign to this subnet. Assigned route table should belong to the same network as this subnet.

dhcp_options - (Optional) Options for DHCP client. The structure is documented below.

The dhcp_options block supports:

domain_name - (Optional) Domain name.
domain_name_servers - (Optional) Domain name server IP addresses.
ntp_servers - (Optional) NTP server IP addresses.
```

- 01:26:15 - включение доступа к Интернет через NatGW. Это будет отдельный инстанс. Пока не понятно как в коде терраформа отображается состояние этой настройки.
- 01:26:25 - создание подсети без сервиса DHCP
- 01:26:30 - создание подсети Private
  - код для терраформа.  Ресурс [yandex_vpc_subnet](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
```tf
resource "yandex_vpc_subnet" "private" {
  v4_cidr_blocks = ["192.168.0.0/24"]
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.netology-vpc.id}"
}
```
- 01:27:05 - создание таблицы маршрутизации. Временно отожено создание таблицы.

- 01:27:20 - создание ВМ `frontend`
  - код для терраформа.  Ресурс  [yandex_compute_instance](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)
```tf
resource "yandex_compute_instance" "frontend" {
  name        = "frontend"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "image_id"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.netology-vpc.id}"
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```
```tf
resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone       = "ru-central1-a"
  network_id = "${yandex_vpc_network.foo.id}"
}

```
  - [Argument Reference](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance#argument-reference)

- 01:28:50 - создание ВМ backend. Запрещаем получение публичного ipадреса
- 01:30:00 - для получения Security group (группа безопасности) их надо заказывать в Yandex.Cloud
  - создание правил для ГБ
- 01:33:10 - создание нового ключа ssh
- 01:35:40 - подключилсь к frontend. Есть доступ к Интернетbackend
 - проверка доступа к backend
- 01:36:30 - создание ключа ssh на frontend для подключеня ко второй ВМ backend
- 01:37:35 - проверка отсутствия доступа к Интернет с backend
- 01:37:50 - чтобы появился доступ в Интернет можно сделать в подсети Private включить NAT
- 01:38:25 - но нам в ДЗ нужно создать instance NAT так, чтобы у него появился белый IP
- 01:38:50 - и наcтроить таблицу маршрутизации и зарулить трафик на instance NAT и удостовериться, что у нас появился Интернет на backend

# ЛР-221204. Тестовый запуск создания ресурсов для выполнения ДЗ 15.1 "Создание сети"

# Директория Delta. Для тестовых запусков Terraform к ДЗ 15.1 в Нетологии

## Первоначальные идентификаторы ресурсов в `organization-serjent`, каталоге `netology-alfa` (b1gd3hm4niaifoa8dahm):
### Облачная сеть
* имя - default
* Идентификатор - enpv16nf8cqphqheb52l
* Описание - Auto-created network

### Подсети в сети `default`
* имя - default-ru-central1-a
  * Идентификатор - e9bi82druit5rcjcbn14
  * Зона - ru-central1-a
  * Сеть - default
  * IPv4 CIDR - 0.128.0.0/24

* имя - default-ru-central1-b
  * Идентификатор - e2logfha0f50tbft7o2q
  * Зона - ru-central1-b
  * Сеть - default
  * IPv4 CIDR - 10.129.0.0/24

* имя - default-ru-central1-c
  * Идентификатор - b0cij35sealdc9moltrp
  * Зона - ru-central1-c
  * Сеть - default
  * IPv4 CIDR - 10.130.0.0/24

## Как подключиться к ВМ, на которой есть наш ключ `id_rsa.pub`
### 1. На той ВМ, с которой нужно подключитьсмя по ssh (frontend) создаем файл `.ssh/key.pem`, сохраняем в нем значение из файла на нашей локальной машине `.ssh/id_rsa`
Этот же ключ использован для подключения к frontend, backend
### 2. `chmod 400 .ssh/id_rsa`
### 3. `ssh centos@192.168.20.11` - подключаемя с frontend на backend


## Описание назначения файлов в этой директории

* key.json
* network.tf - описание ресурсов сети и подсети.  
* node01.tf - instance 
* provider.tf - параметры пдключения к облачному провайдеру
* variables.tf - переменные
* output.tf - запись в переменные выходных параметров определенных ресурсов для использования в других ресурсах

### Сетевые сервисы
#### Сети. Ресурс `yandex_vpc_network` 

Указываем только название подсети (name = "net")
* Пример:
```tf
# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}
```
* network.tf - описание ресурсов сети.
```tf
#Network
resource "yandex_vpc_network" "netology-vpc" {
  name = "netology-vpc"
}
```

#### Подсети. Ресурс `yandex_vpc_subnet`
* Пример:
```tf
#Subnet
resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}
```
* publicsubet.tf - Подсеть с названием `public`, адерс сети 192.168.10.0/24, зона `ru-central1-a`
```tf
#Subnet public
resource "yandex_vpc_subnet" "default" {
  name = "public"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.10.0/24"]
}
```

* privatesubnet.tf - Подсеть с названием `private`, адрес сети 192.168.20.0/24, зона `ru-central1-b`
```tf
#Subnet private
resource "yandex_vpc_subnet" "default" {
  name = "private"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.20.0/24"]
}
```
#### Шлюз в сети. Ресурс `yandex_vpc_gateway`
* Пример:
```tf
resource "yandex_vpc_gateway" "default" {
  name = "foobar"
  shared_egress_gateway {}
}
```
* natgw.tf
```tf
#Instance natgw
resource "yandex_compute_instance" "natgw" {
  name                      = "natgw"
  zone                      = "ru-central1-a"
  hostname                  = "natgw.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.nat-gw}"
      name        = "root-natgw"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id      = "${yandex_vpc_subnet.subnet_pub.id}"
    nat            = true
    ip_address = "192.168.10.254"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

#### Таблица маршрутизации. Ресурс `yandex_vpc_route_table`
* Пример:
```tf
resource "yandex_vpc_route_table" "rt-a" {
  network_id = "${yandex_vpc_network.private.id}"

  static_route {
    destination_prefix = "10.2.0.0/16"
    next_hop_address   = "172.16.10.10"
  }

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = "${yandex_vpc_gateway.egress-gateway.id}"
  }
}
```

* routetable.tf
> Пояснение: при создании routing table в качестве nexthop указывать не адрес NAT_gw инстанса 192.168.10.254, а значение переменной от network ip interface того NAT-инстанса. AT-инстанс будет автоматически получать ип адрес от дхцп, и в роутинг-тайбл будет этот адрес подставляться.

```tf
#Route table
resource "yandex_vpc_route_table" "rt-a" {
  network_id = "${yandex_vpc_network.private.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = "${yandex_vpc_gateway.egress-gateway.id}"
  }
```

#### Группа безопасности. Ресурс `yandex_vpc_security_group`
* Пример
```tf
resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.lab-net.id}"

  labels = {
    my-label = "my-label-value"
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    port           = 8080
  }

  egress {
    protocol       = "ANY"
    description    = "rule2 description"
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    from_port      = 8090
    to_port        = 8099
  }

  egress {
    protocol       = "UDP"
    description    = "rule3 description"
    v4_cidr_blocks = ["10.0.1.0/24"]
    from_port      = 8090
    to_port        = 8099
  }
}
```

* securitygroup.tf
```tf
resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.lab-net.id}"

  labels = {
    my-label = "my-label-value"
  }

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    port           = 8080
  }

  egress {
    protocol       = "ANY"
    description    = "rule2 description"
    v4_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
    from_port      = 8090
    to_port        = 8099
  }

  egress {
    protocol       = "UDP"
    description    = "rule3 description"
    v4_cidr_blocks = ["10.0.1.0/24"]
    from_port      = 8090
    to_port        = 8099
  }
}
```


### Виртуальные машины. Ресурс `yandex_compute_image` 
* image.tf
> Пояснение: на основе готового образа Centos-7-base

* frontend.tf - ВМ для publicsubnet
> Пояснение: nat = true надо ставить и нат инстансу и ВМ, которая находится в паблик подсети.

```tf
#Instance frontend
resource "yandex_compute_instance" "frontend" {
  name                      = "frontend"
  zone                      = "ru-central1-a"
  hostname                  = "frontend.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-frontend"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_i   = "${yandex_vpc_subnet.default.id}"
    nat        = true
    ip_address = "192.168.10.11"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

* backend.tf - ВМ для privatesubnet.
```tf
#Instance backend
resource "yandex_compute_instance" "backend" {
  name                      = "backend"
  zone                      = "ru-central1-b"
  hostname                  = "backend.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-node01"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = "${yandex_vpc_subnet.default.id}"
#    nat        = true
    ip_address = "192.168.20.11"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

* natgw.tf - ВМ в качестве шлюза, позволяющая выйти в Интернет из подсети, не имеющей такого выхода.
> Пояснение: nat = true надо ставить и нат инстансу и ВМ, которая находится в паблик подсети.

```tf
#Instance natgw
resource "yandex_compute_instance" "natgw" {
  name                      = "natgw"
  zone                      = "ru-central1-b"
  hostname                  = "natgw.netology.yc"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.centos-7-base}"
      name        = "root-natgw"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id      = "${yandex_vpc_subnet.default.id}"
    nat            = true
    nat_ip_address = "192.168.10.254"
  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
```


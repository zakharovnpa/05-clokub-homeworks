# Домашнее задание к занятию "15.1. Организация сети" - Захаров Сергей Николаевич

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

#### Результат выполнения этого задания в виде кода terraform располагается в репозитории [clokub-terraform](https://github.com/zakharovnpa/clokub-terraform)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.

Ответ: Создана VPC. Выбираем зону `ru-central1-a`
* Экспорт переменных для подключения terraform к облаку
```sh
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```
* Основная конфигурация
```tf
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
/*
  service_account_key_file = "key.json" # не используется
  cloud_id  = var.yandex_cloud_id       # не используется
  folder_id = var.yandex_folder_id      # не используется
*/  
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "default" {
  name = "net"
}
```
- Переменные с ID образа ОС для создания виртуалок
```tf
# ID образа для развертывания инстанс frontend и backup
variable "centos-7-base" {
  default = "fd87ftkus6nii1k3epnu"
}
```
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.

Ответ: 
- Создаем подсеть с названием public, сетью 192.168.10.0/24
* Подсеть public
```tf
resource "yandex_vpc_subnet" "subnet_pub" {
  name = "public"                                 // название подсети
  zone           = "ru-central1-a"                // зона размещения
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.10.0/24"]           // блок адресов
}
```
- Создаем в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1
```tf
#Instance natgw
resource "yandex_compute_instance" "natgw" {
  name                      = "natgw"
  zone                      = "ru-central1-a"
  hostname                  = "natgw.netology.yc"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 1
    core_fraction = "20"
  }

  boot_disk {
    initialize_params {
      image_id    = var.nat-gw
      name        = "root-natgw"
      type        = "network-hdd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id      = yandex_vpc_subnet.subnet_pub.id
    security_group_ids = [yandex_vpc_security_group.natgw.id]  # привязка группы безопасности к интерфейсу инстанса
    nat            = true
    ip_address = "192.168.10.254"
  }

  scheduling_policy {
    preemptible = true  // Прерываемая ВМ

  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }

output "natgw_ip" {
  description = "IP address NAT-gw instance"
  value = yandex_compute_instance.natgw.network_interface.0.nat_ip_address
 
}
```
* Переменные с ID образа NAT инстанса
```tf
# ID образа для развертывания шлюза в Интернет с NAT
variable "nat-gw" {
  default = "fd80mrhj8fl2oe87o4e1"
}

```
- Создаем в этой публичной подсети виртуалку с именем public с публичным IP и локальным IP 192.168.10.11
```tf
#Instance frontend
resource "yandex_compute_instance" "frontend" {
  name                      = "frontend"
  zone                      = "ru-central1-a"
  hostname                  = "frontend.netology.yc"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 1
    core_fraction = "20"
  }

  boot_disk {
    initialize_params {
      image_id    = var.centos-7-base
      name        = "root-frontend"
      type        = "network-hdd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_pub.id
    nat        = true
    ip_address = "192.168.10.11"
  }

  scheduling_policy {
    preemptible = true  // Прерываемая ВМ

  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
```

- Подключаемся к виртуалке и убеждаемся, что есть доступ к интернету.

![screen-frontend-internet](/15.1-Networking/Files/screen-frontend-internet.png)


3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету
Ответ: 
- Создаем в vpc подсеть с названием private, сетью 192.168.20.0/24.
```tf
resource "yandex_vpc_subnet" "subnet_priv" {
  name = "private"                                 // название подсети
  zone           = "ru-central1-b"                  // зона размещения
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["192.168.20.0/24"]              // блок адресов
  route_table_id = yandex_vpc_route_table.rt-a.id  // Привязка таблицы маршрутизации к подсети private
}
```
- Создаем route table. Добавляем статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
```tf
resource "yandex_vpc_route_table" "rt-a" {
  network_id = "${yandex_vpc_network.default.id}"

  static_route {                          // статический маршрут
    
    destination_prefix = "0.0.0.0/0"      // для всех адресов
    next_hop_address   = yandex_compute_instance.natgw.network_interface.0.ip_address   // Адрес NAT инстанса
  }
}
```
- Создаем в этой приватной подсети виртуалку backend с внутренним IP
```tf
#Instance backend
resource "yandex_compute_instance" "backend" {
  name                      = "backend"
  zone                      = "ru-central1-b"
  hostname                  = "backend.netology.yc"
  platform_id               = "standard-v3"
  allow_stopping_for_update = true

  resources {
    cores  = 2
    memory = 1
    core_fraction = "20"
  }

  boot_disk {
    initialize_params {
      image_id    = var.centos-7-base
      name        = "root-backend"
      type        = "network-hdd"
      size        = "10"
    }
  }

  network_interface {
    subnet_id  = yandex_vpc_subnet.subnet_priv.id
    nat        = false
    ip_address = "192.168.20.11"
  }

  scheduling_policy {
    preemptible = true  // Прерываемая ВМ

  }

  metadata = {
    ssh-keys = "centos:${file("~/.ssh/id_rsa.pub")}"
  }
}
```
- подключаемся к backend через виртуалку frontend, созданную ранее и убеждаемся, что есть доступ к интернету

![screen-backend-internet](/15.1-Networking/Files/screen-backend-internet.png)

4. Создаем группу безопасности - Security group для ограничения сетевого доступа к инстансам и ресурсам
- В данной конфигурации для теста разрешены доступы по всем протоклоам и всем портам между сетями public и private, т.е только внутренний трафик
```tf
#Security group
resource "yandex_vpc_security_group" "natgw" {
  name        = "Security group for NAt-instance"
  description = "Traffic instance NAT"
  network_id  = "${yandex_vpc_network.default.id}"

  labels = {
    my-label = "my-label-value"
  }

  ingress {
    protocol       = "TCP"
    description    = "secure shell from Internet to natgw"
    v4_cidr_blocks = ["0.0.0.0/0"]      # для всех адресов
    port        = 22                    # for ssh
  }

  egress {
    protocol       = "ANY"                    # любые протоклоы
    description    = "from natgw to frontend and backup"
    v4_cidr_blocks = ["192.168.10.11/32", "192.168.20.11/32"]            # только для адресов fronend и backend
    port      = -1                            # все номера портов
  }
}
```

Resource terraform для ЯО
- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance)
---
## Задание 2*. AWS (необязательное к выполнению)

1. Создать VPC.
- Cоздать пустую VPC с подсетью 10.10.0.0/16.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 10.10.1.0/24
- Разрешить в данной subnet присвоение public IP по-умолчанию. 
- Создать Internet gateway 
- Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
- Создать security group с разрешающими правилами на SSH и ICMP. Привязать данную security-group на все создаваемые в данном ДЗ виртуалки
- Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться что есть доступ к интернету.
- Добавить NAT gateway в public subnet.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 10.10.2.0/24
- Создать отдельную таблицу маршрутизации и привязать ее к private-подсети
- Добавить Route, направляющий весь исходящий трафик private сети в NAT.
- Создать виртуалку в приватной сети.
- Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети и убедиться, что с виртуалки есть выход в интернет.

Ответ: задание 2 не выполнено

Resource terraform
- [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

## Ход выполнения ДЗ по теме "15.1. Организация сети"

Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако и дополнительной части в AWS по желанию. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 

Перед началом работ следует настроить доступ до облачных ресурсов из Terraform используя материалы прошлых лекций и [ДЗ](https://github.com/netology-code/virt-homeworks/tree/master/07-terraform-02-syntax ). А также заранее выбрать регион (в случае AWS) и зону.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.
- Создать в vpc subnet с названием public, сетью 192.168.10.0/24.
- Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1

> Пояснение: при создании routing table в качестве nexthop указывать не адрес 192.168.10.254, а значение переменной от network ip interface того NAT-инстанса. AT-инстанс будет автоматически получать ип адрес от дхцп, и в роутинг-тайбл будет этот адрес подставляться.

> Пояснение: Выполнить команду `curl ifconfig.co` чтобы было видно внешний ip адрес


- Создать в этой публичной подсети виртуалку с публичным IP и подключиться к ней, убедиться что есть доступ к интернету.
3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 192.168.20.0/24.
- Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс
- Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее и убедиться что есть доступ к интернету

> Пояснение: nat = true надо ставить и нат инстансу и ВМ, которая находится в паблик подсети.

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

Resource terraform
- [VPC](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc)
- [Subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet)
- [Internet Gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway)

# Ход выполнения ДЗ

## Документация на сайте Яндекс
- [Начало работы с Terraform](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart)


## Подключение зеркала Яндекс для работы Terraformв случае ошибки доступа:
```
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/clokub-terraform# terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider yandex-cloud/yandex: could not connect to registry.terraform.io: Failed to request discovery document: 403 Forbidden
╵
```
Статья [Настройте провайдер](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/terraform-quickstart#configure-provider)

- Создаем файл `vim ~/.terraformrc`
- Добавляем в него блок:
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
- Результат инициализации Terraform. Получили работающий Terraform без необходимости настройки VPN
```
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/clokub-terraform# terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.83.0...
- Installed yandex-cloud/yandex v0.83.0 (unauthenticated)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

## ЛР-221126_2200 по развертыванию тестовых ресурсов на основе старых конфигураций из других уроков.
- директория исполнения команд и расположения файлов Terraform `root@PC-Ubuntu:~/learning-terraform/yandex-cloud/Alfa#` 
- 
## ЛР-221203_0815 по развертыванию тестовых ресурсов на основе старых конфигураций из других уроков.
- директория исполнения команд и расположения файлов Terraform `root@PC-Ubuntu:~/learning-terraform/yandex-cloud/clokub-terraform#` 
### 1. Сделать подключение к облаку через Токен
- первоначальный файл `provider.tf` с настройками сервисного аккаунта (key.json)
```tf
# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"   # указание на файл с параметрами авторизации
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
}

```
- необходимо использовать Токен
- Добавьте аутентификационные данные в переменные окружения:
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

```
  * YC_TOKEN — [IAM-токен](https://cloud.yandex.ru/docs/iam/concepts/authorization/iam-token).
  * YC_CLOUD_ID — идентификатор облака.
  * YC_FOLDER_ID — идентификатор каталога.


- новый файл `provider.tf` с настройками для Токена

```tf

```



## В Terraform подготовить код для развертывания ресурсов в облаке:
- VPC
  - [yandex_vpc_gateway](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_gateway) 
- сеть
- подсеть public в регионе 1-a
- подсеть private в регионе 1-b
- image для создания instance frontend и backend
- instance frontend в подсети public 
- instance backend в подсети private
- instance NAT с возможностью получить белый IP
- Route table для заворачивания трафика с backend на NAT instanceи потом в Интернет
  - [yandex_vpc_route_table](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- Security group с разрешающими правилами на SSH и ICMP
  - [yandex_vpc_default_security_group](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_default_security_group)
  - [yandex_vpc_security_group](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group)
  - [yandex_vpc_security_group_rule](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule)


1. Создать VPC.
- Создать пустую VPC. Выбрать зону.
  - файл `main.tf`

```tf
# Provider
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
}
```

2. Публичная подсеть.
  2.1 - Создать в vpc subnet с названием public, сетью 10.10.1.0/24
  2.2 - Разрешить в данной subnet присвоение public IP по-умолчанию. 
    
* Используемый ресурс [yandex_vpc_subnet](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet)
- Пример кода для создания подсети:
```tf
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_subnet" "public" {
  v4_cidr_blocks = ["10.10.1.0/24"]
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.lab-net.id}"
}
```
  - файл `network.tf`
```tf
# Network
resource "yandex_vpc_network" "default" {
  name = "net"
}

resource "yandex_vpc_subnet" "default" {
  name = "subnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.default.id}"
  v4_cidr_blocks = ["192.168.101.0/24"]
}

```
2.3 - Создать Internet gateway. Это будет instance NAT
  
  
  
2.4 - Добавить в таблицу маршрутизации маршрут, направляющий весь исходящий трафик в Internet gateway.
* Используемый ресурс [yandex_vpc_route_table](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table)
- Пример кода для таблицы маршрутизации
```tf
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_gateway" "egress-gateway" {
  name = "egress-gateway"
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "lab-rt-a" {
  network_id = "${yandex_vpc_network.lab-net.id}"

  static_route {
    destination_prefix = "10.2.0.0/16"
    next_hop_address   = "172.16.10.10"   
  }

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = "${yandex_vpc_gateway.egress-gateway.id}"  # здесь вместо адреса используется переменная с именем интерфейса natgw
  }
}

```

2.5 - Создать security group с разрешающими правилами на SSH и ICMP. 
  - Привязать данную security-group на все создаваемые в данном ДЗ виртуалки
* Используемый ресурс [yandex_vpc_security_group](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group)
- Пример 

```tf
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}
```
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
 [yandex_vpc_default_security_group](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_default_security_group)
- Пример 
```tf
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_default_security_group" "default-sg" {
  description = "description for default security group"
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

* Используемый ресурс [yandex_vpc_security_group_rule](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group_rule)
- Пример

```tf
resource "yandex_vpc_network" "lab-net" {
  name = "lab-network"
}

resource "yandex_vpc_security_group" "group1" {
  name        = "My security group"
  description = "description for my security group"
  network_id  = "${yandex_vpc_network.lab-net.id}"

  labels = {
    my-label = "my-label-value"
  }
}

resource "yandex_vpc_security_group_rule" "rule1" {
  security_group_binding = yandex_vpc_security_group.group1.id
  direction              = "ingress"
  description            = "rule1 description"
  v4_cidr_blocks         = ["10.0.1.0/24", "10.0.2.0/24"]
  port                   = 8080
  protocol               = "TCP"
}

resource "yandex_vpc_security_group_rule" "rule2" {
  security_group_binding = yandex_vpc_security_group.group1.id
  direction              = "egress"
  description            = "rule2 description"
  v4_cidr_blocks         = ["10.0.1.0/24"]
  from_port              = 8090
  to_port                = 8099
  protocol               = "UDP"
}

```


2.6 - Создать в этой подсети виртуалку и убедиться, что инстанс имеет публичный IP. Подключиться к ней, убедиться что есть доступ к интернету.

- [yandex_compute_image](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_image)

```tf
resource "yandex_compute_image" "foo-image" {
  name       = "my-custom-image"
  source_url = "https://storage.yandexcloud.net/lucky-images/kube-it.img"
}

resource "yandex_compute_instance" "vm" {
  name = "vm-from-custom-image"

  # ...

  boot_disk {
    initialize_params {
      image_id = "${yandex_compute_image.foo-image.id}"
    }
  }
}
```
- [yandex_compute_instance](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) 

```tf
resource "yandex_compute_instance" "default" {
  name        = "test"
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
    subnet_id = "${yandex_vpc_subnet.foo.id}"
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone       = "ru-central1-a"
  network_id = "${yandex_vpc_network.foo.id}"
}
```

2.7 - Добавить NAT gateway в public subnet.
- [yandex_vpc_gateway](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/vpc_gateway)

3. Приватная подсеть.
- Создать в vpc subnet с названием private, сетью 10.10.2.0/24
- Создать отдельную таблицу маршрутизации и привязать ее к private-подсети
- Добавить Route, направляющий весь исходящий трафик private сети в NAT.
- Создать виртуалку в приватной сети.
- Подключиться к ней по SSH по приватному IP через виртуалку, созданную ранее в публичной подсети и убедиться, что с виртуалки есть выход в интернет.



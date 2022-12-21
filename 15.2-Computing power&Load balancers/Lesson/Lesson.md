## Ход выполнения ДЗ по теме 15.2 "Вычислительные мощности. Балансировщики нагрузки".

1. Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако, и дополнительной части в AWS (можно выполнить по желанию). 
2. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.
3. Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работ следует настроить доступ до облачных ресурсов из Terraform, используя материалы прошлых лекций и ДЗ.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

- Чистовая рабочая директория с готовыми файлами, загружаемыми в репозиторий [clokub-terraform](https://github.com/zakharovnpa/clokub-terraform.git)
```
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform#
```
- Черновая директория для подготовительных и тестовых работ:
```
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/Epsilon#
```

1. Создать bucket Object Storage и разместить там файл с картинкой:
- Создать bucket в Object Storage с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать файл доступным из Интернет.

Ответ:
- Создаем bucket в Object Storage с произвольным именем (например, zakharovnpa_221218);
- Ресурсы:
  - [yandex_iam_service_account_static_access_key](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key)
* Пример: Этот фрагмент кода создает статический ключ доступа к сервисному аккаунту.
```tf
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = "some_sa_id"
  description        = "static access key for object storage"
  pgp_key            = "keybase:keybaseusername"
}
```
* Рабочий код:
```tf
// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
#  service_account_id = yandex_iam_service_account.netology-serjent.id
  service_account_id = "aj.................bp"
  description        = "static access key for object storage"
}
```

  - [yandex_storage_bucket](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket)
* Пример. 
```tf
// Use keys to create bucket
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "tf-test-bucket"
}
```
* Рабочий код:
```tf
// Use keys to create bucket
resource "yandex_storage_bucket" "zakharovnpa-221218" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "zakharovnpa-221218"
  default_storage_class = "STANDARD"
  max_size = 1073741824     # 1Gb
}

```

  - [Bucket Default Storage Class](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket#bucket-default-storage-class)

  - [Simple Private Bucket](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket#simple-private-bucket)

- Загрузим в bucket файл с картинкой;
* Пример
```tf
resource "yandex_storage_object" "cute-cat-picture" {
  bucket = "cat-pictures"
  key    = "cute-cat"
  source = "/images/cats/cute-cat.jpg"
}
```
- Ресурсы:
  - [yandex_storage_object](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_object)

* yandex_storage_object.tf Рабочий код
```tf
# yandex_storage_object
resource "yandex_storage_object" "vint-av-72" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "zakharovnpa-221218"
  key    = "vint-av-72"
  source = "/root/learning-terraform/yandex-cloud/netology/clokub-terraform/Images/vint-av-72-8.png"
}
```

> При terraform destroy  терраформ не удаляет бакет, т.к. не удаляет объект а нем.


- Необязательное: Шифрование файла [Using SSE](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket)
* Пример
```tf
resource "yandex_kms_symmetric_key" "key-a" {
  name              = "example-symetric-key"
  description       = "description for key"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" // equal to 1 year
}

resource "yandex_storage_bucket" "test" {
  bucket = "mybucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
```

- Сделать файл доступным из Интернет.
  - открыть доступ по ссылке, которую создаст 
  - настроить хостинг. Ресурс [Static Website Hosting](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket#static-website-hosting)
* Пример
```tf
resource "yandex_storage_bucket" "test" {
  bucket = "storage-website-test.hashicorp.com"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "error.html"
    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }

}
```






2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на картинку из bucket:
- Создать Instance Group с 3 ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`;
- Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata); > Пояснение: раздел должен быть `user-data`
- Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket;
- Настроить проверку состояния ВМ. > Пояснение: настроить halthcheck

Ответ: 
> Создайте целевую группу. [Целевая группа](https://cloud.yandex.ru/docs/network-load-balancer/concepts/target-resources) объединяет облачные ресурсы, по которым сетевой балансировщик будет распределять трафик.
> Сетевой балансировщик распределяет нагрузку между облачными ресурсами, объединенными в целевые группы.

> Целевой ресурс определяется двумя параметрами: идентификатором подсети и внутренним IP-адресом ресурса. Целевые ресурсы одной группы должны находиться в одной облачной сети. В пределах одной зоны доступности все целевые ресурсы должны быть подключены к одной подсети. Максимальное количество ресурсов в целевой группе — 254.
Целевые ресурсы должны принимать трафик на порту с тем же номером, что указан в конфигурации обработчика.

> Подключенная целевая группа — это группа целевых ресурсов, подключенная к сетевому балансировщику. Целевую группу можно подключить к нескольким балансировщикам. При этом целевую группу нельзя подключать к портам с одинаковым номером на разных балансировщиках. Например, если группа подключена к одному балансировщику на порту 8080, то к другому балансировщику ее нужно подключить на порту 8081.
После подключения целевой группы балансировщик начнет проверять состояние целевых ресурсов и сможет распределять нагрузку между ними.

* Autoscaling
> [Работа с группой виртуальных машин с автоматическим масштабированием](https://cloud.yandex.ru/docs/tutorials/infrastructure-management/vm-autoscale)


- Создаем Instance Group с 3 ВМ и шаблоном LAMP. 
  - [yandex_compute_instance_group](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group)

```tf
resource "yandex_compute_instance_group" "group1" {
  name                = "test-ig"
  folder_id           = "${data.yandex_resourcemanager_folder.test_folder.id}"
  service_account_id  = "${yandex_iam_service_account.test_account.id}"
  deletion_protection = true
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "${data.yandex_compute_image.ubuntu.id}"
        size     = 4
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.my-inst-group-network.id}"
      subnet_ids = ["${yandex_vpc_subnet.my-inst-group-subnet.id}"]
    }
    labels = {
      label1 = "label1-value"
      label2 = "label2-value"
    }
    metadata = {
      foo      = "bar"
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
    network_settings {
      type = "STANDARD"
    }
  }

  variables = {
    test_key1 = "test_value1"
    test_key2 = "test_value2"
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 2
    max_creating    = 2
    max_expansion   = 2
    max_deleting    = 2
  }
}
```
- [yandex_lb_target_group](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/lb_target_group)


- Размещаем в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket
  - неизвестно как
  - сделать статический хостинг [Static Website Hosting](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket#static-website-hosting)

- Настраиваем проверку состояния ВМ (настроить halthcheck)


3. Подключить группу к сетевому балансировщику:
- Создать сетевой балансировщик;
- Проверить работоспособность, удалив одну или несколько ВМ.

Ответ:
> [Yandex Network Load Balancer](https://cloud.yandex.ru/docs/network-load-balancer/) — сервис, который помогает обеспечить отказоустойчивость приложений за счет равномерного распределения сетевой нагрузки по облачным ресурсам. 


- Создаем сетевой балансировщик;
- [yandex_lb_network_load_balancer](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer)

* Пример:
```tf
resource "yandex_lb_network_load_balancer" "foo" {
  name = "my-network-load-balancer"

  listener {
    name = "my-listener"
    port = 8080
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = "${yandex_lb_target_group.my-target-group.id}"

    healthcheck {
      name = "http"
      http_options {
        port = 8080
        path = "/ping"
      }
    }
  }
}
```

- Проверяем работоспособность, удалив одну или несколько ВМ.

4. *Создать Application Load Balancer с использованием Instance group и проверкой состояния.

> Пояснение: в бакете делать правила доступа не на весь бакет, а на каждый файл (обект) в отдельности.

> Пояснение: с помощью yandex comute instance group

> Пояснение: как вывести в  output ip сетевого балансировщика
- Пример из заключительной лекции по задачам курса на - 00:12:50. Вывод показан там же.
```tf
output "external_ip_address_nlb" {
    value = yandex_lb_network_load_balancer.my-network-load-balancer.listener.*.external_address.spec
}
```

Документация
- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group)
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer)
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer)
---
## Задание 2*. AWS (необязательное к выполнению)

Используя конфигурации, выполненные в рамках ДЗ на предыдущем занятии, добавить к Production like сети Autoscaling group из 3 EC2-инстансов с  автоматической установкой web-сервера в private домен.

1. Создать bucket S3 и разместить там файл с картинкой:
- Создать bucket в S3 с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать доступным из Интернета.
2. Сделать Launch configurations с использованием bootstrap скрипта с созданием веб-странички на которой будет ссылка на картинку в S3. 
3. Загрузить 3 ЕС2-инстанса и настроить LB с помощью Autoscaling Group.

Resource terraform
- [S3 bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)
- [Launch Template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template)
- [Autoscaling group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
- [Launch configuration](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration)

Пример bootstrap-скрипта:
```
#!/bin/bash
yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html
echo "<html><h1>My cool web-server</h1></html>" > index.html
```

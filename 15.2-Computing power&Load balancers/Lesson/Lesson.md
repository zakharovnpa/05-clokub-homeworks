## Ход выполнения ДЗ по теме 15.2 "Вычислительные мощности. Балансировщики нагрузки".

1. Домашнее задание будет состоять из обязательной части, которую необходимо выполнить на провайдере Яндекс.Облако, и дополнительной части в AWS (можно выполнить по желанию). 
2. Все домашние задания в 15 блоке связаны друг с другом и в конце представляют пример законченной инфраструктуры.
3. Все задания требуется выполнить с помощью Terraform, результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работ следует настроить доступ до облачных ресурсов из Terraform, используя материалы прошлых лекций и ДЗ.

---
## Задание 1. Яндекс.Облако (обязательное к выполнению)

1. Создать bucket Object Storage и разместить там файл с картинкой:
- Создать bucket в Object Storage с произвольным именем (например, _имя_студента_дата_);
- Положить в bucket файл с картинкой;
- Сделать файл доступным из Интернет.

Ответ:
- Создаем bucket в Object Storage с произвольным именем (например, zakharov_221216);
- Ресурсы:
  - [yandex_storage_bucket](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket)
  - [Bucket Default Storage Class](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket#bucket-default-storage-class)
```tf
resource "yandex_storage_bucket" "backet" {
  bucket = "my-policy-bucket"

  default_storage_class = "STANDARD"
}
```
  - [Simple Private Bucket](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket#simple-private-bucket)
```tf
locals {
  folder_id = "<folder-id>"
}

provider "yandex" {
  folder_id = local.folder_id
  zone      = "ru-central1-a"
}

// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "tf-test-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "tf-test-bucket"
}
```
- Загрузим в bucket файл с картинкой;
```tf
resource "yandex_storage_object" "cute-cat-picture" {
  bucket = "cat-pictures"
  key    = "cute-cat"
  source = "/images/cats/cute-cat.jpg"
}
```
- Шифрование файла [Using SSE](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket)

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


  - [yandex_storage_object](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_object)

2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и web-страничкой, содержащей ссылку на картинку из bucket:
- Создать Instance Group с 3 ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`;
- Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata); > Пояснение: раздел должен быть `user-data`
- 02:02:30 - про группу ВМ в лекции
- Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket;
- Настроить проверку состояния ВМ. > Пояснение: настроить halthcheck

Ответ: 
- Создаем Instance Group с 3 ВМ и шаблоном LAMP. В лекции группа называется Target group - 02:04:15
- Порядок создания:
  - таргет груп
  - балансировщик
  - обработчик (листенер)
  - helth check

- Про автоскейлинг групп - 02:14:10, 
  - про подключение шаблоа для создания групп ВМ, 
  - про интеграцию с Network balancer или Application balancer

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
- Размещаем в стартовой веб-странице шаблонной ВМ ссылку на картинку из bucket
  - неизвестно как
  - сделать статический хостинг [Static Website Hosting](https://registry.tfpla.net/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket#static-website-hosting)

- Настраиваем проверку состояния ВМ (настроить halthcheck)


3. Подключить группу к сетевому балансировщику:
- Создать сетевой балансировщик; -02:02:30
- Проверить работоспособность, удалив одну или несколько ВМ.


Ответ:

- Создаем сетевой балансировщик;


- Проверяем работоспособность, удалив одну или несколько ВМ.

4. *Создать Application Load Balancer с использованием Instance group и проверкой состояния.

> Пояснение: в бакете делать правила доступа не на весь бакет, а на каждый файл (обект) в отдельности.

> Пояснение: с помощью yandex comute instance group

> Пояснение: как вывести в  output ip сетевого балансировщика
- Пример из заключительной лекции по задачам курса на - 00:12:50. Вывод показан там же.

В лекции:
- 02:09:00 - создание группы ВМ backend
- создание http роуиера


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

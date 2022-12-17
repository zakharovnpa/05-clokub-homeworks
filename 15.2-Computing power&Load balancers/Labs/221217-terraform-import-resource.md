## ЛР по импортированию ресурсов в облаке, созданных вручную в веб-интерфейсе в код Terraform

### Концепция:

> Использована статья по[ импортированию ресурсов.](https://habr.com/ru/company/piter/blog/496820/#:~:text=%D0%9D%D0%B8%D0%B6%D0%B5%20%D0%BF%D0%BE%D0%BA%D0%B0%D0%B7%D0%B0%D0%BD%D0%B0%20%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4%D0%B0%20import%2C%20%D0%BF%D0%BE%D0%B7%D0%B2%D0%BE%D0%BB%D1%8F%D1%8E%D1%89%D0%B0%D1%8F%20%D1%81%D0%B8%D0%BD%D1%85%D1%80%D0%BE%D0%BD%D0%B8%D0%B7%D0%B8%D1%80%D0%BE%D0%B2%D0%B0%D1%82%D1%8C%20%D1%80%D0%B5%D1%81%D1%83%D1%80%D1%81%20aws_iam_user%2C%20%D0%BA%D0%BE%D1%82%D0%BE%D1%80%D1%8B%D0%B9%20%D0%B2%D1%8B%20%D0%B4%D0%BE%D0%B1%D0%B0%D0%B2%D0%B8%D0%BB%D0%B8%20%D0%B2%20%D1%81%D0%B2%D0%BE%D1%8E%20%D0%BA%D0%BE%D0%BD%D1%84%D0%B8%D0%B3%D1%83%D1%80%D0%B0%D1%86%D0%B8%D1%8E%20Terraform%20%D0%B2%D0%BC%D0%B5%D1%81%D1%82%D0%B5%20%D1%81%20%D0%BF%D0%BE%D0%BB%D1%8C%D0%B7%D0%BE%D0%B2%D0%B0%D1%82%D0%B5%D0%BB%D0%B5%D0%BC%20IAM%20%D0%B2%20%D0%B3%D0%BB%D0%B0%D0%B2%D0%B5%202%20(%D0%B5%D1%81%D1%82%D0%B5%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%BE%2C%20%D0%B2%D0%BC%D0%B5%D1%81%D1%82%D0%BE%20yevgeniy.brikman%20%D0%BD%D1%83%D0%B6%D0%BD%D0%BE%20%D0%BF%D0%BE%D0%B4%D1%81%D1%82%D0%B0%D0%B2%D0%B8%D1%82%D1%8C%20%D0%B2%D0%B0%D1%88%D0%B5%20%D0%B8%D0%BC%D1%8F)%3A)

1. Создать на сайте облачного провайдера необходимые ресурсы
2. В директории, где расположены файлы с кодом terraform и terraform.tfstate выполнить действия:
  - Выполнить `terraform state list`. Выйдет список ресурсов, созданных на основе файлов конфигурации.

```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform state list
yandex_compute_instance.backend
yandex_compute_instance.frontend
yandex_compute_instance.natgw
yandex_vpc_network.default
yandex_vpc_route_table.rt-a
yandex_vpc_security_group.natgw
yandex_vpc_subnet.subnet_priv
yandex_vpc_subnet.subnet_pub
```
  - Выполнить `terraform init`
  
```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform init

Initializing the backend...

Initializing provider plugins...
- Reusing previous version of yandex-cloud/yandex from the dependency lock file
- Using previously-installed yandex-cloud/yandex v0.83.0

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```
    
  - Выполнить `terraform refresh`
```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform refresh
yandex_vpc_network.default: Refreshing state... [id=enpik9i39odv3783iqp7]
yandex_vpc_subnet.subnet_pub: Refreshing state... [id=e9btsc5l5s397o94pgfn]
yandex_vpc_security_group.natgw: Refreshing state... [id=enpsqj1sua4pegdudlc7]
yandex_compute_instance.frontend: Refreshing state... [id=fhm2t3cfj5h7274trfpn]
yandex_compute_instance.natgw: Refreshing state... [id=fhmmhlp51tkhhajl9njd]
yandex_vpc_route_table.rt-a: Refreshing state... [id=enp00ieke5ug80ri0u9q]
yandex_vpc_subnet.subnet_priv: Refreshing state... [id=e2lue5319f8tf45bt408]
yandex_compute_instance.backend: Refreshing state... [id=epds6au8inmkavjutkda]

```
  - На сайте мышкой была создана ВМ с названием `zah-157`. Копируем ID этой ВМ и используем его в следующей команде:
  - Выполнить `terraform import yandex_compute_instance.zah-157 fhm8vvrf4i0mu25bhqka`

```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform import yandex_compute_instance.zah-157 fhm8vvrf4i0mu25bhqka
yandex_compute_instance.zah-157: Importing from ID "fhm8vvrf4i0mu25bhqka"...
yandex_compute_instance.zah-157: Import prepared!
  Prepared yandex_compute_instance for import
yandex_compute_instance.zah-157: Refreshing state... [id=fhm8vvrf4i0mu25bhqka]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.

```
  - Выполнить `terraform state list`. Убедиться, что новый ресурс импортировался в state

```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform state list
yandex_compute_instance.backend
yandex_compute_instance.frontend
yandex_compute_instance.natgw
yandex_compute_instance.zah-157  - новый ресурс
yandex_vpc_network.default
yandex_vpc_route_table.rt-a
yandex_vpc_security_group.natgw
yandex_vpc_subnet.subnet_priv
yandex_vpc_subnet.subnet_pub

```
  - Выполнить ` terraform state show yandex_compute_instance.zah-157`

```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform state show yandex_compute_instance.zah-157
# yandex_compute_instance.zah-157:
resource "yandex_compute_instance" "zah-157" {
    created_at                = "2022-12-17T15:05:33Z"
    folder_id                 = "b1gd3hm4niaifoa8dahm"
    fqdn                      = "zah-157.ru-central1.internal"
    hostname                  = "zah-157"
    id                        = "fhm8vvrf4i0mu25bhqka"
    labels                    = {}
    metadata                  = {
        "install-unified-agent" = "0"
        "ssh-keys"              = "ubuntu:ssh-rsa AAAAB3Nz.....E7+FMs= root@PC-Ubuntu"
        "user-data"             = <<-EOT
            #cloud-config
            datasource:
             Ec2:
              strict_id: false
            ssh_pwauth: no
            users:
            - name: ubuntu
              sudo: ALL=(ALL) NOPASSWD:ALL
              shell: /bin/bash
              ssh_authorized_keys:
              - ssh-rsa AAAAB3Nz....snbZBYfJE7+FMs= root@PC-Ubuntu
        EOT
    }
    name                      = "zah-157"
    network_acceleration_type = "standard"
    platform_id               = "standard-v3"
    status                    = "running"
    zone                      = "ru-central1-a"

    boot_disk {
        auto_delete = true
        device_name = "fhm24ln3aapo9omkqtmv"
        disk_id     = "fhm24ln3aapo9omkqtmv"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd864gbboths76r8gm5f"
            size       = 5
            type       = "network-hdd"
        }
    }

    network_interface {
        index              = 0
        ip_address         = "192.168.10.4"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:8f:ff:6f:24"
        nat                = false
        security_group_ids = []
        subnet_id          = "e9btsc5l5s397o94pgfn"
    }

    placement_policy {
        host_affinity_rules = []
    }

    resources {
        core_fraction = 20
        cores         = 2
        gpus          = 0
        memory        = 1
    }

    scheduling_policy {
        preemptible = true
    }

    timeouts {}
}

```
  - Копируем содержимое в файл с новым ресурсом `zah-157.tf`

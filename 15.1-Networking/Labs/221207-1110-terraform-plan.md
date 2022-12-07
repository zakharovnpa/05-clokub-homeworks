### Terraform show
```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform show
# yandex_compute_instance.backend:
resource "yandex_compute_instance" "backend" {
    allow_stopping_for_update = true
    created_at                = "2022-12-07T06:40:43Z"
    folder_id                 = "b1gd3hm4niaifoa8dahm"
    fqdn                      = "backend.netology.yc"
    hostname                  = "backend.netology.yc"
    id                        = "epdj7acu6v8e79opng0r"
    metadata                  = {
        "ssh-keys" = <<-EOT
            centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+9Ei9PdBgvkzoZaKFwoy9mDeug4UUkdibC3r9CRxn2ml0qka0W3JrldqzFj2sZ3N9g3W5LRcVFN0aw42hMxgTvN5OJrP46AnOtuF7JXp3rndq1zsKf1C6fxfV94erFBaJHxtYqRIgfcMxNrqCFs3t6aoc6Rvo6s80Pq+mxwbHUV3z/Rih4xUycnjzmwJOE28NTtRsysdRZoV7KaOTZ3nVgnrjlf/oQRgsyZXQYA6sW4rYMd6UjSXd3dB1N3kOZeyE8zaTjqKQwuwwL1d1JuKrefxrigt+DxAMwq6mIe7eu0SYBcjFAkhglTjuIblo0xrgxbL389MOW/fe2CLqygAb66QZlc85sj1SMuVASlwOliLKU8W7uEJT/1U4zQkAwuEPKZexSNGu0XMOKpByW2A9bPTcKJGRoOUZcRwTp9bVPxHTlfRRtheKVHm3eSzLEt0AN2hbTQmPapaKorcME8FWFr0PLG4Ic3VLwSOX/lWB1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu
        EOT
    }
    name                      = "backend"
    network_acceleration_type = "standard"
    platform_id               = "standard-v1"
    status                    = "running"
    zone                      = "ru-central1-b"

    boot_disk {
        auto_delete = true
        device_name = "epduntfjd7jjeaisioiv"
        disk_id     = "epduntfjd7jjeaisioiv"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd87ftkus6nii1k3epnu"
            name       = "root-backend"
            size       = 10
            type       = "network-ssd"
        }
    }

    network_interface {
        index              = 0
        ip_address         = "192.168.20.11"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:13:3a:99:e3"
        nat                = false
        security_group_ids = []
        subnet_id          = "e2likjto3s5e7je6olke"
    }

    placement_policy {
        host_affinity_rules = []
    }

    resources {
        core_fraction = 100
        cores         = 4
        gpus          = 0
        memory        = 8
    }

    scheduling_policy {
        preemptible = false
    }
}

# yandex_compute_instance.frontend:
resource "yandex_compute_instance" "frontend" {
    allow_stopping_for_update = true
    created_at                = "2022-12-07T06:40:44Z"
    folder_id                 = "b1gd3hm4niaifoa8dahm"
    fqdn                      = "frontend.netology.yc"
    hostname                  = "frontend.netology.yc"
    id                        = "fhmub2ugla2jqn4go76o"
    metadata                  = {
        "ssh-keys" = <<-EOT
            centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+9Ei9PdBgvkzoZaKFwoy9mDeug4UUkdibC3r9CRxn2ml0qka0W3JrldqzFj2sZ3N9g3W5LRcVFN0aw42hMxgTvN5OJrP46AnOtuF7JXp3rndq1zsKf1C6fxfV94erFBaJHxtYqRIgfcMxNrqCFs3t6aoc6Rvo6s80Pq+mxwbHUV3z/Rih4xUycnjzmwJOE28NTtRsysdRZoV7KaOTZ3nVgnrjlf/oQRgsyZXQYA6sW4rYMd6UjSXd3dB1N3kOZeyE8zaTjqKQwuwwL1d1JuKrefxrigt+DxAMwq6mIe7eu0SYBcjFAkhglTjuIblo0xrgxbL389MOW/fe2CLqygAb66QZlc85sj1SMuVASlwOliLKU8W7uEJT/1U4zQkAwuEPKZexSNGu0XMOKpByW2A9bPTcKJGRoOUZcRwTp9bVPxHTlfRRtheKVHm3eSzLEt0AN2hbTQmPapaKorcME8FWFr0PLG4Ic3VLwSOX/lWB1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu
        EOT
    }
    name                      = "frontend"
    network_acceleration_type = "standard"
    platform_id               = "standard-v1"
    status                    = "running"
    zone                      = "ru-central1-a"

    boot_disk {
        auto_delete = true
        device_name = "fhm0nljcq14dnqlp06me"
        disk_id     = "fhm0nljcq14dnqlp06me"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd87ftkus6nii1k3epnu"
            name       = "root-frontend"
            size       = 10
            type       = "network-ssd"
        }
    }

    network_interface {
        index              = 0
        ip_address         = "192.168.10.11"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:1e:58:bd:0a"
        nat                = true
        nat_ip_address     = "158.160.49.25"
        nat_ip_version     = "IPV4"
        security_group_ids = []
        subnet_id          = "e9b6jv2kcktlg95u6ri1"
    }

    placement_policy {
        host_affinity_rules = []
    }

    resources {
        core_fraction = 100
        cores         = 4
        gpus          = 0
        memory        = 8
    }

    scheduling_policy {
        preemptible = false
    }
}

# yandex_compute_instance.natgw:
resource "yandex_compute_instance" "natgw" {
    allow_stopping_for_update = true
    created_at                = "2022-12-07T06:40:44Z"
    folder_id                 = "b1gd3hm4niaifoa8dahm"
    fqdn                      = "natgw.netology.yc"
    hostname                  = "natgw.netology.yc"
    id                        = "fhm6ct2lq5bsdt5jbrl6"
    metadata                  = {
        "ssh-keys" = <<-EOT
            centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+9Ei9PdBgvkzoZaKFwoy9mDeug4UUkdibC3r9CRxn2ml0qka0W3JrldqzFj2sZ3N9g3W5LRcVFN0aw42hMxgTvN5OJrP46AnOtuF7JXp3rndq1zsKf1C6fxfV94erFBaJHxtYqRIgfcMxNrqCFs3t6aoc6Rvo6s80Pq+mxwbHUV3z/Rih4xUycnjzmwJOE28NTtRsysdRZoV7KaOTZ3nVgnrjlf/oQRgsyZXQYA6sW4rYMd6UjSXd3dB1N3kOZeyE8zaTjqKQwuwwL1d1JuKrefxrigt+DxAMwq6mIe7eu0SYBcjFAkhglTjuIblo0xrgxbL389MOW/fe2CLqygAb66QZlc85sj1SMuVASlwOliLKU8W7uEJT/1U4zQkAwuEPKZexSNGu0XMOKpByW2A9bPTcKJGRoOUZcRwTp9bVPxHTlfRRtheKVHm3eSzLEt0AN2hbTQmPapaKorcME8FWFr0PLG4Ic3VLwSOX/lWB1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu
        EOT
    }
    name                      = "natgw"
    network_acceleration_type = "standard"
    platform_id               = "standard-v1"
    status                    = "running"
    zone                      = "ru-central1-a"

    boot_disk {
        auto_delete = true
        device_name = "fhm4rel63er5hofhvq53"
        disk_id     = "fhm4rel63er5hofhvq53"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd8o8aph4t4pdisf1fio"
            name       = "root-natgw"
            size       = 10
            type       = "network-ssd"
        }
    }

    network_interface {
        index              = 0
        ip_address         = "192.168.10.254"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:66:74:55:d1"
        nat                = true
        nat_ip_address     = "158.160.48.101"
        nat_ip_version     = "IPV4"
        security_group_ids = []
        subnet_id          = "e9b6jv2kcktlg95u6ri1"
    }

    placement_policy {
        host_affinity_rules = []
    }

    resources {
        core_fraction = 100
        cores         = 4
        gpus          = 0
        memory        = 8
    }

    scheduling_policy {
        preemptible = false
    }
}

# yandex_vpc_network.default:
resource "yandex_vpc_network" "default" {
    created_at = "2022-12-07T06:40:41Z"
    folder_id  = "b1gd3hm4niaifoa8dahm"
    id         = "enp3deirg3ubc2ljnoa0"
    labels     = {}
    name       = "net"
    subnet_ids = []
}

# yandex_vpc_route_table.rt-a:
resource "yandex_vpc_route_table" "rt-a" {
    created_at = "2022-12-07T06:40:43Z"
    folder_id  = "b1gd3hm4niaifoa8dahm"
    id         = "enpbck66ga43i69daenj"
    labels     = {}
    network_id = "enp3deirg3ubc2ljnoa0"

    static_route {
        destination_prefix = "0.0.0.0/0"
        next_hop_address   = "192.168.10.254"
    }
}

# yandex_vpc_security_group.group1:
resource "yandex_vpc_security_group" "group1" {
    created_at  = "2022-12-07T06:40:43Z"
    description = "description for my security group"
    folder_id   = "b1gd3hm4niaifoa8dahm"
    id          = "enpof78iq91o88k5j4qh"
    labels      = {
        "my-label" = "my-label-value"
    }
    name        = "My security group"
    network_id  = "enp3deirg3ubc2ljnoa0"
    status      = "ACTIVE"

    ingress {
        description    = "rule1 description"
        from_port      = -1
        id             = "enp5k4185lq8jo8lkbb3"
        labels         = {}
        port           = -1
        protocol       = "ANY"
        to_port        = -1
        v4_cidr_blocks = [
            "192.168.10.0/24",
        ]
        v6_cidr_blocks = []
    }
}

# yandex_vpc_subnet.subnet_priv:
resource "yandex_vpc_subnet" "subnet_priv" {
    created_at     = "2022-12-07T06:40:42Z"
    folder_id      = "b1gd3hm4niaifoa8dahm"
    id             = "e2likjto3s5e7je6olke"
    labels         = {}
    name           = "private"
    network_id     = "enp3deirg3ubc2ljnoa0"
    v4_cidr_blocks = [
        "192.168.20.0/24",
    ]
    v6_cidr_blocks = []
    zone           = "ru-central1-b"
}

# yandex_vpc_subnet.subnet_pub:
resource "yandex_vpc_subnet" "subnet_pub" {
    created_at     = "2022-12-07T06:40:43Z"
    folder_id      = "b1gd3hm4niaifoa8dahm"
    id             = "e9b6jv2kcktlg95u6ri1"
    labels         = {}
    name           = "public"
    network_id     = "enp3deirg3ubc2ljnoa0"
    v4_cidr_blocks = [
        "192.168.10.0/24",
    ]
    v6_cidr_blocks = []
    zone           = "ru-central1-a"
}

```

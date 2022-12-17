## terraform show
```tf
root@PC-Ubuntu:~/learning-terraform/yandex-cloud/netology/clokub-terraform# terraform show 
# yandex_compute_instance.backend:
resource "yandex_compute_instance" "backend" {
    allow_stopping_for_update = true
    created_at                = "2022-12-17T02:31:57Z"
    folder_id                 = "b1gd3hm4niaifoa8dahm"
    fqdn                      = "backend.netology.yc"
    hostname                  = "backend.netology.yc"
    id                        = "epd7hacbbisp60picvap"
    metadata                  = {
        "ssh-keys" = <<-EOT
            centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+9Ei9PdBgvkzoZaKFwoy9mDeug4UUkdibC3r9CRxn2ml0qka0W3JrldqzFj2sZ3N9g3W5LRcVFN0aw42hMxgTvN5OJrP46AnOtuF7JXp3rndq1zsKf1C6fxfV94erFBaJHxtYqRIgfcMxNrqCFs3t6aoc6Rvo6s80Pq+mxwbHUV3z/Rih4xUycnjzmwJOE28NTtRsysdRZoV7KaOTZ3nVgnrjlf/oQRgsyZXQYA6sW4rYMd6UjSXd3dB1N3kOZeyE8zaTjqKQwuwwL1d1JuKrefxrigt+DxAMwq6mIe7eu0SYBcjFAkhglTjuIblo0xrgxbL389MOW/fe2CLqygAb66QZlc85sj1SMuVASlwOliLKU8W7uEJT/1U4zQkAwuEPKZexSNGu0XMOKpByW2A9bPTcKJGRoOUZcRwTp9bVPxHTlfRRtheKVHm3eSzLEt0AN2hbTQmPapaKorcME8FWFr0PLG4Ic3VLwSOX/lWB1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu
        EOT
    }
    name                      = "backend"
    network_acceleration_type = "standard"
    platform_id               = "standard-v3"
    status                    = "running"
    zone                      = "ru-central1-b"

    boot_disk {
        auto_delete = true
        device_name = "epdl0of4rsgq3f55ato9"
        disk_id     = "epdl0of4rsgq3f55ato9"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd87ftkus6nii1k3epnu"
            name       = "root-backend"
            size       = 10
            type       = "network-hdd"
        }
    }

    network_interface {
        index              = 0
        ip_address         = "192.168.20.11"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:78:a9:8b:5c"
        nat                = false
        security_group_ids = []
        subnet_id          = "e2lks51dcbgvp22ul7qu"
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
}

# yandex_compute_instance.frontend:
resource "yandex_compute_instance" "frontend" {
    allow_stopping_for_update = true
    created_at                = "2022-12-17T02:30:53Z"
    folder_id                 = "b1gd3hm4niaifoa8dahm"
    fqdn                      = "frontend.netology.yc"
    hostname                  = "frontend.netology.yc"
    id                        = "fhmh4h0cmgfcs1sglnku"
    metadata                  = {
        "ssh-keys" = <<-EOT
            centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+9Ei9PdBgvkzoZaKFwoy9mDeug4UUkdibC3r9CRxn2ml0qka0W3JrldqzFj2sZ3N9g3W5LRcVFN0aw42hMxgTvN5OJrP46AnOtuF7JXp3rndq1zsKf1C6fxfV94erFBaJHxtYqRIgfcMxNrqCFs3t6aoc6Rvo6s80Pq+mxwbHUV3z/Rih4xUycnjzmwJOE28NTtRsysdRZoV7KaOTZ3nVgnrjlf/oQRgsyZXQYA6sW4rYMd6UjSXd3dB1N3kOZeyE8zaTjqKQwuwwL1d1JuKrefxrigt+DxAMwq6mIe7eu0SYBcjFAkhglTjuIblo0xrgxbL389MOW/fe2CLqygAb66QZlc85sj1SMuVASlwOliLKU8W7uEJT/1U4zQkAwuEPKZexSNGu0XMOKpByW2A9bPTcKJGRoOUZcRwTp9bVPxHTlfRRtheKVHm3eSzLEt0AN2hbTQmPapaKorcME8FWFr0PLG4Ic3VLwSOX/lWB1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu
        EOT
    }
    name                      = "frontend"
    network_acceleration_type = "standard"
    platform_id               = "standard-v3"
    status                    = "running"
    zone                      = "ru-central1-a"

    boot_disk {
        auto_delete = true
        device_name = "fhmlib0c4g3kcteulkhu"
        disk_id     = "fhmlib0c4g3kcteulkhu"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd87ftkus6nii1k3epnu"
            name       = "root-frontend"
            size       = 10
            type       = "network-hdd"
        }
    }

    network_interface {
        index              = 0
        ip_address         = "192.168.10.11"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:11:24:40:cb"
        nat                = true
        nat_ip_address     = "158.160.39.242"
        nat_ip_version     = "IPV4"
        security_group_ids = []
        subnet_id          = "e9buq8u3d13fm3apr7mn"
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
}

# yandex_compute_instance.natgw:
resource "yandex_compute_instance" "natgw" {
    allow_stopping_for_update = true
    created_at                = "2022-12-17T02:30:52Z"
    folder_id                 = "b1gd3hm4niaifoa8dahm"
    fqdn                      = "natgw.netology.yc"
    hostname                  = "natgw.netology.yc"
    id                        = "fhmageaqj25qf6ldlpli"
    metadata                  = {
        "ssh-keys" = <<-EOT
            centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+9Ei9PdBgvkzoZaKFwoy9mDeug4UUkdibC3r9CRxn2ml0qka0W3JrldqzFj2sZ3N9g3W5LRcVFN0aw42hMxgTvN5OJrP46AnOtuF7JXp3rndq1zsKf1C6fxfV94erFBaJHxtYqRIgfcMxNrqCFs3t6aoc6Rvo6s80Pq+mxwbHUV3z/Rih4xUycnjzmwJOE28NTtRsysdRZoV7KaOTZ3nVgnrjlf/oQRgsyZXQYA6sW4rYMd6UjSXd3dB1N3kOZeyE8zaTjqKQwuwwL1d1JuKrefxrigt+DxAMwq6mIe7eu0SYBcjFAkhglTjuIblo0xrgxbL389MOW/fe2CLqygAb66QZlc85sj1SMuVASlwOliLKU8W7uEJT/1U4zQkAwuEPKZexSNGu0XMOKpByW2A9bPTcKJGRoOUZcRwTp9bVPxHTlfRRtheKVHm3eSzLEt0AN2hbTQmPapaKorcME8FWFr0PLG4Ic3VLwSOX/lWB1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu
        EOT
    }
    name                      = "natgw"
    network_acceleration_type = "standard"
    platform_id               = "standard-v3"
    status                    = "running"
    zone                      = "ru-central1-a"

    boot_disk {
        auto_delete = true
        device_name = "fhmpoflvj7r9p9o2b2jg"
        disk_id     = "fhmpoflvj7r9p9o2b2jg"
        mode        = "READ_WRITE"

        initialize_params {
            block_size = 4096
            image_id   = "fd80mrhj8fl2oe87o4e1"
            name       = "root-natgw"
            size       = 10
            type       = "network-hdd"
        }
    }

    network_interface {
        index              = 0
        ip_address         = "192.168.10.254"
        ipv4               = true
        ipv6               = false
        mac_address        = "d0:0d:a8:39:5a:98"
        nat                = true
        nat_ip_address     = "158.160.47.185"
        nat_ip_version     = "IPV4"
        security_group_ids = []
        subnet_id          = "e9buq8u3d13fm3apr7mn"
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
}

# yandex_vpc_network.default:
resource "yandex_vpc_network" "default" {
    created_at = "2022-12-17T02:30:50Z"
    folder_id  = "b1gd3hm4niaifoa8dahm"
    id         = "enpmj3h4t3jvnjmjla2j"
    labels     = {}
    name       = "net"
    subnet_ids = []
}

# yandex_vpc_route_table.rt-a:
resource "yandex_vpc_route_table" "rt-a" {
    created_at = "2022-12-17T02:31:55Z"
    folder_id  = "b1gd3hm4niaifoa8dahm"
    id         = "enpdfeda5pkqc68ghgdg"
    labels     = {}
    network_id = "enpmj3h4t3jvnjmjla2j"

    static_route {
        destination_prefix = "0.0.0.0/0"
        next_hop_address   = "192.168.10.254"
    }
}

# yandex_vpc_security_group.natgw:
resource "yandex_vpc_security_group" "natgw" {
    created_at  = "2022-12-17T02:30:51Z"
    description = "Traffic instance NAT"
    folder_id   = "b1gd3hm4niaifoa8dahm"
    id          = "enpd42o6ckuec9i9olc6"
    labels      = {
        "my-label" = "my-label-value"
    }
    name        = "Security group for NAt-instance"
    network_id  = "enpmj3h4t3jvnjmjla2j"
    status      = "ACTIVE"

    egress {
        description    = "from natgw to frontend and backup"
        from_port      = -1
        id             = "enpjbkrv8u69t62ppf6v"
        labels         = {}
        port           = -1
        protocol       = "ANY"
        to_port        = -1
        v4_cidr_blocks = [
            "192.168.10.0/24",
            "192.168.20.0/24",
        ]
        v6_cidr_blocks = []
    }

    ingress {
        description    = "from frontend and backup to natgw"
        from_port      = -1
        id             = "enpp2pkso05p1vki5dt2"
        labels         = {}
        port           = -1
        protocol       = "ANY"
        to_port        = -1
        v4_cidr_blocks = [
            "192.168.10.0/24",
            "192.168.20.0/24",
        ]
        v6_cidr_blocks = []
    }
}

# yandex_vpc_subnet.subnet_priv:
resource "yandex_vpc_subnet" "subnet_priv" {
    created_at     = "2022-12-17T02:31:56Z"
    folder_id      = "b1gd3hm4niaifoa8dahm"
    id             = "e2lks51dcbgvp22ul7qu"
    labels         = {}
    name           = "private"
    network_id     = "enpmj3h4t3jvnjmjla2j"
    route_table_id = "enpdfeda5pkqc68ghgdg"
    v4_cidr_blocks = [
        "192.168.20.0/24",
    ]
    v6_cidr_blocks = []
    zone           = "ru-central1-b"
}

# yandex_vpc_subnet.subnet_pub:
resource "yandex_vpc_subnet" "subnet_pub" {
    created_at     = "2022-12-17T02:30:51Z"
    folder_id      = "b1gd3hm4niaifoa8dahm"
    id             = "e9buq8u3d13fm3apr7mn"
    labels         = {}
    name           = "public"
    network_id     = "enpmj3h4t3jvnjmjla2j"
    v4_cidr_blocks = [
        "192.168.10.0/24",
    ]
    v6_cidr_blocks = []
    zone           = "ru-central1-a"
}

```
## yc vpc security-group list
```
+----------------------+--------------------------------+----------------------+----------------------+
|          ID          |              NAME              |     DESCRIPTION      |      NETWORK-ID      |
+----------------------+--------------------------------+----------------------+----------------------+
| enpd42o6ckuec9i9olc6 | Security group for             | Traffic instance NAT | enpmj3h4t3jvnjmjla2j |
|                      | NAt-instance                   |                      |                      |
+----------------------+--------------------------------+----------------------+----------------------+

```
## yc vpc security-group show
```tf
id: enpd42o6ckuec9i9olc6
folder_id: b1gd3hm4niaifoa8dahm
created_at: "2022-12-17T02:30:51Z"
name: Security group for NAt-instance
description: Traffic instance NAT
labels:
  my-label: my-label-value
network_id: enpmj3h4t3jvnjmjla2j
status: ACTIVE
rules:
- id: enpjbkrv8u69t62ppf6v
  description: from natgw to frontend and backup
  direction: EGRESS
  protocol_name: ANY
  protocol_number: "-1"
  cidr_blocks:
    v4_cidr_blocks:
    - 192.168.10.0/24
    - 192.168.20.0/24
- id: enpp2pkso05p1vki5dt2
  description: from frontend and backup to natgw
  direction: INGRESS
  protocol_name: ANY
  protocol_number: "-1"
  cidr_blocks:
    v4_cidr_blocks:
    - 192.168.10.0/24
    - 192.168.20.0/24


```

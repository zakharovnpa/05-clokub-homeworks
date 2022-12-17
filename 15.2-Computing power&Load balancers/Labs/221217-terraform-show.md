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
## terraform show -json | python3 -m json.tool
```json
{
    "format_version": "1.0",
    "terraform_version": "1.1.6",
    "values": {
        "root_module": {
            "resources": [
                {
                    "address": "yandex_compute_instance.backend",
                    "mode": "managed",
                    "type": "yandex_compute_instance",
                    "name": "backend",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 1,
                    "values": {
                        "allow_recreate": null,
                        "allow_stopping_for_update": true,
                        "boot_disk": [
                            {
                                "auto_delete": true,
                                "device_name": "epdaclgt6bv220nv6s3n",
                                "disk_id": "epdaclgt6bv220nv6s3n",
                                "initialize_params": [
                                    {
                                        "block_size": 4096,
                                        "description": "",
                                        "image_id": "fd87ftkus6nii1k3epnu",
                                        "name": "root-backend",
                                        "size": 10,
                                        "snapshot_id": "",
                                        "type": "network-hdd"
                                    }
                                ],
                                "mode": "READ_WRITE"
                            }
                        ],
                        "created_at": "2022-12-17T06:08:39Z",
                        "description": "",
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "fqdn": "backend.netology.yc",
                        "hostname": "backend.netology.yc",
                        "id": "epdl0s5tgnluaaa97m88",
                        "labels": null,
                        "local_disk": [],
                        "metadata": {
                            "ssh-keys": "centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABA....zsnbZBYfJE7+FMs= root@PC-Ubuntu\n"
                        },
                        "name": "backend",
                        "network_acceleration_type": "standard",
                        "network_interface": [
                            {
                                "dns_record": [],
                                "index": 0,
                                "ip_address": "192.168.20.11",
                                "ipv4": true,
                                "ipv6": false,
                                "ipv6_address": "",
                                "ipv6_dns_record": [],
                                "mac_address": "d0:0d:15:07:0b:d8",
                                "nat": false,
                                "nat_dns_record": [],
                                "nat_ip_address": "",
                                "nat_ip_version": "",
                                "security_group_ids": [],
                                "subnet_id": "e2lsc6l0ruhf43c69p4o"
                            }
                        ],
                        "placement_policy": [
                            {
                                "host_affinity_rules": [],
                                "placement_group_id": ""
                            }
                        ],
                        "platform_id": "standard-v3",
                        "resources": [
                            {
                                "core_fraction": 20,
                                "cores": 2,
                                "gpus": 0,
                                "memory": 1
                            }
                        ],
                        "scheduling_policy": [
                            {
                                "preemptible": true
                            }
                        ],
                        "secondary_disk": [],
                        "service_account_id": "",
                        "status": "running",
                        "timeouts": null,
                        "zone": "ru-central1-b"
                    },
                    "sensitive_values": {
                        "boot_disk": [
                            {
                                "initialize_params": [
                                    {}
                                ]
                            }
                        ],
                        "local_disk": [],
                        "metadata": {},
                        "network_interface": [
                            {
                                "dns_record": [],
                                "ipv6_dns_record": [],
                                "nat_dns_record": [],
                                "security_group_ids": []
                            }
                        ],
                        "placement_policy": [
                            {
                                "host_affinity_rules": []
                            }
                        ],
                        "resources": [
                            {}
                        ],
                        "scheduling_policy": [
                            {}
                        ],
                        "secondary_disk": []
                    },
                    "depends_on": [
                        "yandex_compute_instance.natgw",
                        "yandex_vpc_network.default",
                        "yandex_vpc_route_table.rt-a",
                        "yandex_vpc_security_group.natgw",
                        "yandex_vpc_subnet.subnet_priv",
                        "yandex_vpc_subnet.subnet_pub"
                    ]
                },
                {
                    "address": "yandex_compute_instance.frontend",
                    "mode": "managed",
                    "type": "yandex_compute_instance",
                    "name": "frontend",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 1,
                    "values": {
                        "allow_recreate": null,
                        "allow_stopping_for_update": true,
                        "boot_disk": [
                            {
                                "auto_delete": true,
                                "device_name": "fhm7pkh150q7hns9mc24",
                                "disk_id": "fhm7pkh150q7hns9mc24",
                                "initialize_params": [
                                    {
                                        "block_size": 4096,
                                        "description": "",
                                        "image_id": "fd87ftkus6nii1k3epnu",
                                        "name": "root-frontend",
                                        "size": 10,
                                        "snapshot_id": "",
                                        "type": "network-hdd"
                                    }
                                ],
                                "mode": "READ_WRITE"
                            }
                        ],
                        "created_at": "2022-12-17T06:07:37Z",
                        "description": "",
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "fqdn": "frontend.netology.yc",
                        "hostname": "frontend.netology.yc",
                        "id": "fhmio2m4er7esdhu8uud",
                        "labels": null,
                        "local_disk": [],
                        "metadata": {
                            "ssh-keys": "centos:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+9Ei9Pd......lWB1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu\n"
                        },
                        "name": "frontend",
                        "network_acceleration_type": "standard",
                        "network_interface": [
                            {
                                "dns_record": [],
                                "index": 0,
                                "ip_address": "192.168.10.11",
                                "ipv4": true,
                                "ipv6": false,
                                "ipv6_address": "",
                                "ipv6_dns_record": [],
                                "mac_address": "d0:0d:12:c0:ac:47",
                                "nat": true,
                                "nat_dns_record": [],
                                "nat_ip_address": "62.84.115.88",
                                "nat_ip_version": "IPV4",
                                "security_group_ids": [],
                                "subnet_id": "e9ble3ad78mhkphcethr"
                            }
                        ],
                        "placement_policy": [
                            {
                                "host_affinity_rules": [],
                                "placement_group_id": ""
                            }
                        ],
                        "platform_id": "standard-v3",
                        "resources": [
                            {
                                "core_fraction": 20,
                                "cores": 2,
                                "gpus": 0,
                                "memory": 1
                            }
                        ],
                        "scheduling_policy": [
                            {
                                "preemptible": true
                            }
                        ],
                        "secondary_disk": [],
                        "service_account_id": "",
                        "status": "running",
                        "timeouts": null,
                        "zone": "ru-central1-a"
                    },
                    "sensitive_values": {
                        "boot_disk": [
                            {
                                "initialize_params": [
                                    {}
                                ]
                            }
                        ],
                        "local_disk": [],
                        "metadata": {},
                        "network_interface": [
                            {
                                "dns_record": [],
                                "ipv6_dns_record": [],
                                "nat_dns_record": [],
                                "security_group_ids": []
                            }
                        ],
                        "placement_policy": [
                            {
                                "host_affinity_rules": []
                            }
                        ],
                        "resources": [
                            {}
                        ],
                        "scheduling_policy": [
                            {}
                        ],
                        "secondary_disk": []
                    },
                    "depends_on": [
                        "yandex_vpc_network.default",
                        "yandex_vpc_subnet.subnet_pub"
                    ]
                },
                {
                    "address": "yandex_compute_instance.natgw",
                    "mode": "managed",
                    "type": "yandex_compute_instance",
                    "name": "natgw",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 1,
                    "values": {
                        "allow_recreate": null,
                        "allow_stopping_for_update": true,
                        "boot_disk": [
                            {
                                "auto_delete": true,
                                "device_name": "fhmh4orn4ka3b5pbjo9h",
                                "disk_id": "fhmh4orn4ka3b5pbjo9h",
                                "initialize_params": [
                                    {
                                        "block_size": 4096,
                                        "description": "",
                                        "image_id": "fd80mrhj8fl2oe87o4e1",
                                        "name": "root-natgw",
                                        "size": 10,
                                        "snapshot_id": "",
                                        "type": "network-hdd"
                                    }
                                ],
                                "mode": "READ_WRITE"
                            }
                        ],
                        "created_at": "2022-12-17T06:07:38Z",
                        "description": "",
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "fqdn": "natgw.netology.yc",
                        "hostname": "natgw.netology.yc",
                        "id": "fhmenjnt5bap1rhu44ge",
                        "labels": null,
                        "local_disk": [],
                        "metadata": {
                            "ssh-keys": "centos:ssh-rsa AAAAB3Nza........B1Gq5Va+ozsnbZBYfJE7+FMs= root@PC-Ubuntu\n"
                        },
                        "name": "natgw",
                        "network_acceleration_type": "standard",
                        "network_interface": [
                            {
                                "dns_record": [],
                                "index": 0,
                                "ip_address": "192.168.10.254",
                                "ipv4": true,
                                "ipv6": false,
                                "ipv6_address": "",
                                "ipv6_dns_record": [],
                                "mac_address": "d0:0d:eb:ce:fd:2a",
                                "nat": true,
                                "nat_dns_record": [],
                                "nat_ip_address": "158.160.52.194",
                                "nat_ip_version": "IPV4",
                                "security_group_ids": [
                                    "enp506fjc4vg55og0i4j"
                                ],
                                "subnet_id": "e9ble3ad78mhkphcethr"
                            }
                        ],
                        "placement_policy": [
                            {
                                "host_affinity_rules": [],
                                "placement_group_id": ""
                            }
                        ],
                        "platform_id": "standard-v3",
                        "resources": [
                            {
                                "core_fraction": 20,
                                "cores": 2,
                                "gpus": 0,
                                "memory": 1
                            }
                        ],
                        "scheduling_policy": [
                            {
                                "preemptible": true
                            }
                        ],
                        "secondary_disk": [],
                        "service_account_id": "",
                        "status": "running",
                        "timeouts": null,
                        "zone": "ru-central1-a"
                    },
                    "sensitive_values": {
                        "boot_disk": [
                            {
                                "initialize_params": [
                                    {}
                                ]
                            }
                        ],
                        "local_disk": [],
                        "metadata": {},
                        "network_interface": [
                            {
                                "dns_record": [],
                                "ipv6_dns_record": [],
                                "nat_dns_record": [],
                                "security_group_ids": [
                                    false
                                ]
                            }
                        ],
                        "placement_policy": [
                            {
                                "host_affinity_rules": []
                            }
                        ],
                        "resources": [
                            {}
                        ],
                        "scheduling_policy": [
                            {}
                        ],
                        "secondary_disk": []
                    },
                    "depends_on": [
                        "yandex_vpc_network.default",
                        "yandex_vpc_security_group.natgw",
                        "yandex_vpc_subnet.subnet_pub"
                    ]
                },
                {
                    "address": "yandex_vpc_network.default",
                    "mode": "managed",
                    "type": "yandex_vpc_network",
                    "name": "default",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 0,
                    "values": {
                        "created_at": "2022-12-17T06:07:35Z",
                        "default_security_group_id": "",
                        "description": "",
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "id": "enpe1hv59r7acr9sokvk",
                        "labels": {},
                        "name": "net",
                        "subnet_ids": [],
                        "timeouts": null
                    },
                    "sensitive_values": {
                        "labels": {},
                        "subnet_ids": []
                    }
                },
                {
                    "address": "yandex_vpc_route_table.rt-a",
                    "mode": "managed",
                    "type": "yandex_vpc_route_table",
                    "name": "rt-a",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 0,
                    "values": {
                        "created_at": "2022-12-17T06:08:37Z",
                        "description": "",
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "id": "enpi9e74mop7506r2s50",
                        "labels": {},
                        "name": "",
                        "network_id": "enpe1hv59r7acr9sokvk",
                        "static_route": [
                            {
                                "destination_prefix": "0.0.0.0/0",
                                "gateway_id": "",
                                "next_hop_address": "192.168.10.254"
                            }
                        ],
                        "timeouts": null
                    },
                    "sensitive_values": {
                        "labels": {},
                        "static_route": [
                            {}
                        ]
                    },
                    "depends_on": [
                        "yandex_compute_instance.natgw",
                        "yandex_vpc_network.default",
                        "yandex_vpc_security_group.natgw",
                        "yandex_vpc_subnet.subnet_pub"
                    ]
                },
                {
                    "address": "yandex_vpc_security_group.natgw",
                    "mode": "managed",
                    "type": "yandex_vpc_security_group",
                    "name": "natgw",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 0,
                    "values": {
                        "created_at": "2022-12-17T06:07:37Z",
                        "description": "Traffic instance NAT",
                        "egress": [
                            {
                                "description": "from natgw to frontend and backup",
                                "from_port": -1,
                                "id": "enpr8p8jc5f8jv1qp6uc",
                                "labels": {},
                                "port": -1,
                                "predefined_target": "",
                                "protocol": "ANY",
                                "security_group_id": "",
                                "to_port": -1,
                                "v4_cidr_blocks": [
                                    "192.168.10.11/32",
                                    "192.168.20.11/32"
                                ],
                                "v6_cidr_blocks": []
                            }
                        ],
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "id": "enp506fjc4vg55og0i4j",
                        "ingress": [
                            {
                                "description": "secure shell from Internet to natgw",
                                "from_port": -1,
                                "id": "enp9314g8pg13hfsfhho",
                                "labels": {},
                                "port": 22,
                                "predefined_target": "",
                                "protocol": "TCP",
                                "security_group_id": "",
                                "to_port": -1,
                                "v4_cidr_blocks": [
                                    "0.0.0.0/0"
                                ],
                                "v6_cidr_blocks": []
                            }
                        ],
                        "labels": {
                            "my-label": "my-label-value"
                        },
                        "name": "Security group for NAt-instance",
                        "network_id": "enpe1hv59r7acr9sokvk",
                        "status": "ACTIVE",
                        "timeouts": null
                    },
                    "sensitive_values": {
                        "egress": [
                            {
                                "labels": {},
                                "v4_cidr_blocks": [
                                    false,
                                    false
                                ],
                                "v6_cidr_blocks": []
                            }
                        ],
                        "ingress": [
                            {
                                "labels": {},
                                "v4_cidr_blocks": [
                                    false
                                ],
                                "v6_cidr_blocks": []
                            }
                        ],
                        "labels": {}
                    },
                    "depends_on": [
                        "yandex_vpc_network.default"
                    ]
                },
                {
                    "address": "yandex_vpc_subnet.subnet_priv",
                    "mode": "managed",
                    "type": "yandex_vpc_subnet",
                    "name": "subnet_priv",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 0,
                    "values": {
                        "created_at": "2022-12-17T06:08:38Z",
                        "description": "",
                        "dhcp_options": [],
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "id": "e2lsc6l0ruhf43c69p4o",
                        "labels": {},
                        "name": "private",
                        "network_id": "enpe1hv59r7acr9sokvk",
                        "route_table_id": "enpi9e74mop7506r2s50",
                        "timeouts": null,
                        "v4_cidr_blocks": [
                            "192.168.20.0/24"
                        ],
                        "v6_cidr_blocks": [],
                        "zone": "ru-central1-b"
                    },
                    "sensitive_values": {
                        "dhcp_options": [],
                        "labels": {},
                        "v4_cidr_blocks": [
                            false
                        ],
                        "v6_cidr_blocks": []
                    },
                    "depends_on": [
                        "yandex_compute_instance.natgw",
                        "yandex_vpc_network.default",
                        "yandex_vpc_route_table.rt-a",
                        "yandex_vpc_security_group.natgw",
                        "yandex_vpc_subnet.subnet_pub"
                    ]
                },
                {
                    "address": "yandex_vpc_subnet.subnet_pub",
                    "mode": "managed",
                    "type": "yandex_vpc_subnet",
                    "name": "subnet_pub",
                    "provider_name": "registry.terraform.io/yandex-cloud/yandex",
                    "schema_version": 0,
                    "values": {
                        "created_at": "2022-12-17T06:07:36Z",
                        "description": "",
                        "dhcp_options": [],
                        "folder_id": "b1gd3hm4niaifoa8dahm",
                        "id": "e9ble3ad78mhkphcethr",
                        "labels": {},
                        "name": "public",
                        "network_id": "enpe1hv59r7acr9sokvk",
                        "route_table_id": "",
                        "timeouts": null,
                        "v4_cidr_blocks": [
                            "192.168.10.0/24"
                        ],
                        "v6_cidr_blocks": [],
                        "zone": "ru-central1-a"
                    },
                    "sensitive_values": {
                        "dhcp_options": [],
                        "labels": {},
                        "v4_cidr_blocks": [
                            false
                        ],
                        "v6_cidr_blocks": []
                    },
                    "depends_on": [
                        "yandex_vpc_network.default"
                    ]
                }
            ]
        }
    }
}

```

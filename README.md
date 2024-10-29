# Homelab Proxmox VM Cluster Terraform Module

Terraform module which creates a group of Proxmox VMs, registers them with AWX, and creates a PowerDNS A record for each VM.

The module is built on top of my [terraform-homelab-pve-vm](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm) module, which creates a single Proxmox VM.

This module is designed to be used with the technology stack I utilize in my homelab. It assumes you are using the following technologies:

- [Proxmox](https://www.proxmox.com/en/)
  - Hypervisor
- [AWX](https://github.com/ansible/awx)
  - Ansible Automation Platform
  - Upstream project for Ansible Tower
- [PowerDNS](https://www.powerdns.com/)
  - DNS Server

The main goal of this module was to streamline the creation of nearly identical VMs that would be used to deploy some type of clustered based application (k8s, HA DNS, ...). There are variables that allow you to customize each VM independently to some extent, but the main focus is on creating a group of VMs that are nearly identical. Just like my single VM module, it is not designed to be used by others as it is highly opinionated and tailored to my specific use case; however, it may be useful as a reference for others.

## Opinionated Decisions

As mentioned above this module is highly opinionated and tailored to my specific use case. To see a non-exhaustive list of opinionated decisions made in this module, see the [Opinionated Decisions section](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm?tab=readme-ov-file#opinionated-decisions) in the single vm module that this module is based off.

## Requirements

### Terraform

This module requires Terraform 1.9.8 or later. It may be compatible with earlier versions but only has been tested with 1.9.8.

### Providers

The table below lists the providers required by this module.

| Name     | Source           | Version     |
| -------- | ---------------- | ----------- |
| proxmox  | telmate/proxmox  | = 3.0.1-rc4 |
| powerdns | pan-net/powerdns | = 1.5.0     |
| awx      | denouche/awx     | = 0.19.0    |

You most configure the above providers (URLs, credentials, ...) in your terraform configuration.

_See the [versions.tf](https://github.com/Johnny-Knighten/terraform-homelab-pve-vm/blob/main/versions.tf) in the single vm module for more up to date details._

## Variables

### Cluster Variables

| Name         | Description                  | Type   | Default | Required |
| ------------ | ---------------------------- | ------ | ------- | :------: |
| `node_count` | The number of vms to create. | number | 1       |    no    |

### PVE Variables

#### Proxmox and Metadata Variables

| Name                          | Description                                                                           | Type           | Default        | Required |
| ----------------------------- | ------------------------------------------------------------------------------------- | -------------- | -------------- | :------: |
| `pve_auto_increment_id`       | whether or not to auto increment the VM IDs                                           | `bool`         | `true`         |    no    |
| `pve_auto_increment_id_start` | starting number to use for auto incrementing VM IDs, otherwise uses next available ID | `number`       | `null`         |    no    |
| `pve_id_list`                 | list of VM IDs to use for each VM, if not using auto incrementing                     | `list(string)` | `[]`           |    no    |
| `pve_auto_increment_names`    | whether or not to auto increment node names (node-0, node-1, etc)                     | `bool`         | `true`         |    no    |
| `pve_base_name`               | base name to use for auto generated node names, if using auto increment               | `string`       | `"node"`       |    no    |
| `pve_name_list`               | list of node names to use for each VM, if not using auto incrementing                 | `list(string)` | `[] `          |    no    |
| `pve_use_same_node`           | whether or not to assign all VMs to the same PVE node                                 | `bool`         | `true`         |    no    |
| `pve_node`                    | name of the ProxMox node to create all VMs on, if `pve_use_same_node` == `true`       | `string`       | `primary`      |    no    |
| `pve_node_assignments`        | list of nodes to deploy for each VM, if not deploying all to same node                | `list(string)` | `[]`           |    no    |
| `pve_same_descrip`            | whether or not to use a unique description for each VM                                | `bool`         | `true`         |    no    |
| `pve_desc`                    | description to use for all VMs, if using `pve_same_descrip` == `true`                 | `string`       | `cluster node` |    no    |
| `pve_desc_list`               | list of descriptions to use for each VM, if not using same description for all vms    | `list(string)` | `[]`           |    no    |

#### Cloning and Template Variables

| Name             | Description                                                    | Type     | Default                                     | Required |
| ---------------- | -------------------------------------------------------------- | -------- | ------------------------------------------- | :------: |
| `pve_is_clone`   | flag to determine if each VM is a clone or not (based off iso) | `bool`   | `true`                                      |    no    |
| `pve_template`   | name of the template to clone each VM from                     | `string` | `ubuntu-server-22-04-base-template-homelab` |    no    |
| `pve_full_clone` | whether or not to do a full clone of the template              | `bool`   | `true`                                      |    no    |
| `pve_iso`        | name of the iso to use for each VM, if not cloning             | `string` | `""`                                        |    no    |

#### Boot Options

| Name                  | Description                                                                                               | Type     | Default | Required |
| --------------------- | --------------------------------------------------------------------------------------------------------- | -------- | ------- | :------: |
| `pve_boot_on_start`   | whether or not to boot each VM on start                                                                   | `bool`   | `false` |    no    |
| `pve_startup_options` | startup options separated with commas: boot order (order=), startup delay(up=), and shutdown delay(down=) | `string` | `""`    |    no    |
| `pve_boot_disk`       | boot disk for each VM                                                                                     | `string` | null    |    no    |

#### CPU Options

| Name             | Description                              | Type     | Default | Required |
| ---------------- | ---------------------------------------- | -------- | ------- | :------: |
| `pve_core_count` | number of cores to allocate to each VM   | `string` | `2`     |    no    |
| `pve_cpu_type`   | type of CPU to use for each VM           | `string` | `host`  |    no    |
| `pve_sockets`    | number of sockets to allocate to each VM | `string` | `1`     |    no    |

#### Memory Options

| Name                 | Description                                                               | Type     | Default | Required |
| -------------------- | ------------------------------------------------------------------------- | -------- | ------- | :------: |
| `pve_memory_size`    | amount of memory to allocate to each VM in MiB                            | `number` | `2048`  |    no    |
| `pve_memory_balloon` | whether or not to use memory ballooning (set to 0 to turn off ballooning) | `number` | `0`     |    no    |

#### Network Options

| Name           | Description                                | Type           | Default   | Required |
| -------------- | ------------------------------------------ | -------------- | --------- | :------: |
| `pve_networks` | List of network configurations for each VM | `list(object)` | see below |    no    |

For the `pve_networks` variable, the default value is a list of objects, which is not easily representable in a single cell. Here is the default value for pve_networks:

```hcl
default = [
  {
    model  = "virtio"
    bridge = "vmbr0"
    tag    = "-1"
    queues = "1"
  }
]
```

#### Cloud-Init Options

| Name                         | Description                                                                                     | Type           | Default     | Required |
| ---------------------------- | ----------------------------------------------------------------------------------------------- | -------------- | ----------- | :------: |
| `pve_use_ci`                 | whether or not to use the cloud_init                                                            | `bool`         | `true`      |    no    |
| `pve_ci_ssh_user`            | ssh user used to provision the VM                                                               | `string`       | `ansible`   |    no    |
| `pve_ci_ssh_private_key`     | ssh private key used to provision the VM                                                        | `string`       | `""`        |    no    |
| `pve_ci_all_use_dhcp`        | whether or not to use DHCP for all VMs                                                          | `bool`         | `true`      |    no    |
| `pve_ci_dns_servers`         | ip of vm's dns server                                                                           | `string`       | `""`        |    no    |
| `pve_ci_storage_location`    | storage location for the cloud-init iso                                                         | `string`       | `local-zfs` |    no    |
| `pve_ci_static_address_list` | list of static addresses objects to use for each VM (one per VM), if not using DHCP for all VMs | `list(object)` | `null`      |    no    |

For the `pve_ci_static_address_list` this is the expected object structure (one per VM):

```hcl
[
  {
    ip_address         = "192.168.1.2"
    cidr_prefix_length = "24" # Number of bits in the subnet mask
    gateway            = "192.168.1.1"
  }
]
```

#### Disk Options

| Name                                 | Description                                                                                         | Type           | Default           | Required |
| ------------------------------------ | --------------------------------------------------------------------------------------------------- | -------------- | ----------------- | :------: |
| `pve_disk_size`                      | size of the VM disk for each VM                                                                     | `string`       | `40G`             |    no    |
| `pve_use_same_disk_storage_location` | whether or not to use the same storage location for all VM disks                                    | `bool`         | `true`            |    no    |
| `pve_disk_storage_location`          | storage location for the VM disk in all VMs, used if `pve_use_same_disk_storage_location` == `true` | `string`       | `local-zfs`       |    no    |
| `pve_disk_storage_location_list`     | list of storage locations for each VM disk, if not using same the same location                     | `list(string)` | `[]`              |    no    |
| `pve_scsihw`                         | scsi hardware to use for the VM                                                                     | `string`       | `virtio-scsi-pci` |    no    |

#### Agent Options

| Name            | Description                                | Type     | Default | Required |
| --------------- | ------------------------------------------ | -------- | ------- | :------: |
| `pve_use_agent` | whether or not to use the agent in each VM | `number` | `1`     |    no    |

### AWX Variables

You do not need to supply the numeric IDs for the organization, inventory, and inventory groups, the module will look them up based on the name.

| Name                        | Description                                                  | Type           | Default | Required |
| --------------------------- | ------------------------------------------------------------ | -------------- | ------- | :------: |
| `awx_organization`          | name of the AWX organization to create the host in           | `string`       | n/a     |   yes    |
| `awx_inventory`             | name of the AWX inventory to create the host in              | `string`       | n/a     |   yes    |
| `awx_host_groups`           | comma separated list of AWX host groups to add the host to   | `list(string)` | n/a     |   yes    |
| `awx_host_name_list`        | list of names for each AWX host to create                    | `list(string)` | n/a     |   yes    |
| `awx_use_same_host_descrip` | whether or not to use the same description for all AWX hosts | `bool`         | n/a     |   yes    |
| `awx_host_descrip`          | description for each AWX host created                        | `string`       | n/a     |   yes    |
| `awx_host_descrip_list`     | list of descriptions for each AWX host created               | `list(string)` | n/a     |    no    |

### PowerDNS Variables

Currently only a single A record will be created.

| Name                    | Description                                             | Type           | Default | Required |
| ----------------------- | ------------------------------------------------------- | -------------- | ------- | :------: |
| `pdns_zone`             | name of the PowerDNS zone to create the record in       | `string`       | n/a     |   yes    |
| `pdns_record_name_list` | list of names used for PowerDNS records created for VMs | `list(string)` | n/a     |   yes    |

## Outputs

| Name         | Description                                                        | Type           | Sensitive |
| ------------ | ------------------------------------------------------------------ | -------------- | --------- |
| `vm_details` | list of VM details including VM ID, VM Descrip,SIP, and DNS record | `list(object)` | no        |

Here is the expected object structure for the `vm_details` output:

```hcl
[
  {
    vm_id          = "100"
    vm_name        = "node-0"
    vm_ip_address  = "192.168.1.2"
    vm_dns_record  = "node-0.homelab.local"
  }
]
```

## Usage

### Example - 3 VMs Cloned From A Template Provisioned Via Cloud-Init

```hcl
module "pve-vm-cluster" {
  source     = "github.com/Johnny-Knighten/terraform-homelab-pve-vm-cluster?ref=1.3.3"
  node_count = 3

  pve_auto_increment_id_start = 500
  pve_base_name               = "test-cluster-node"
  pve_node                    = "node-alpha"
  pve_desc                    = "Test VM Cluster Node"

  pve_is_clone   = true
  pve_full_clone = true
  pve_template   = "ubuntu-server-22-04-base-template-homelab"

  pve_disk_size = "40G"

  pve_core_count = 4

  pve_memory_size    = 8196

  pve_use_ci          = true
  pve_ci_all_use_dhcp = false
  pve_ci_dns_servers  = "192.168.25.2 192.168.25.3 192.168.25.1"
  pve_ci_static_address_list = [
    {
      ip_address   = "192.168.25.100"
      network_bits = 24
      gateway      = "192.168.25.1"
    },
    {
      ip_address   = "192.168.25.101"
      network_bits = 24
      gateway      = "192.168.25.1"
    },
    {
      ip_address   = "192.168.25.102"
      network_bits = 24
      gateway      = "192.168.25.1"
    }
  ]

  pve_networks = [
    {
      model  = "virtio"
      bridge = "vmbr0"
      tag    = 6
      queues = 0
    }
  ]

  pdns_zone = "homelab.lan"
  pdns_record_name_list = [
    "test-cluster-node-1",
    "test-cluster-node-2",
    "test-cluster-node-3",
  ]

  awx_organization = "Homelab"
  awx_inventory    = "Homelab Endpoints"
  awx_host_groups  = ["proxmox-hosts"]
  awx_host_name_list = [
    "test-cluster-node1",
    "test-cluster-node-2",
    "test-cluster-node-3",
  ]
  awx_use_same_host_descrip = true
  awx_host_descrip          = "Talos Test Control Plane"
}
```
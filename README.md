# Homelab Proxmox VM Cluster Terraform Module

Terraform module which creates a group of Proxmox VMs and creates a PowerDNS A record for each VM.

The module is built on top of my [terraform-proxmox-vm](https://github.com/Knighten-Homelab/terraform-proxmox-vm) module, which creates a single Proxmox VM.

This module is designed to be used with the technology stack I utilize in my homelab. It assumes you are using the following technologies:

- [Proxmox](https://www.proxmox.com/en/)
  - Hypervisor
- [PowerDNS](https://www.powerdns.com/) (Optional)
  - DNS Server

The main goal of this module was to streamline the creation of nearly identical VMs that would be used to deploy some type of clustered based application (k8s, HA DNS, ...). There are variables that allow you to customize each VM independently to some extent, but the main focus is on creating a group of VMs that are nearly identical. Just like my single VM module, it is not designed to be used by others as it is highly opinionated and tailored to my specific use case; however, it may be useful as a reference for others.

## Opinionated Decisions

As mentioned above this module is highly opinionated and tailored to my specific use case. To see a non-exhaustive list of opinionated decisions made in this module, see the [Opinionated Decisions section](https://github.com/Knighten-Homelab/terraform-proxmox-vm?tab=readme-ov-file#opinionated-decisions) in the single vm module that this module is based off.

## Requirements

### Terraform

This module requires Terraform 1.9.8 or later. It may be compatible with earlier versions but only has been tested with 1.9.8.

### Providers

The table below lists the providers required by this module.

| Name     | Source           | Version       |
| -------- | ---------------- | ------------- |
| proxmox  | telmate/proxmox  | = 3.0.2-rc01 |
| powerdns | pan-net/powerdns | = 1.5.0       |

You most configure the above providers (URLs, credentials, ...) in your terraform configuration.

_See the [versions.tf](https://github.com/Knighten-Homelab/terraform-proxmox-vm/blob/main/versions.tf) in the single vm module for more up to date details._

## Important: Parallel VM Creation

Due to limitations in the Proxmox provider version 3.0.2-rc01, **parallel VM creation requires specific configuration**. By default, the provider creates VMs sequentially to avoid VM ID conflicts.

### For Parallel Creation

To enable parallel VM creation, you **must** use static VM IDs instead of auto-increment:

```hcl
module "pve-vm-cluster" {
  source = "github.com/Knighten-Homelab/terraform-proxmox-vm-cluster"
  
  # Required for parallel creation
  pve_auto_increment_id = false
  pve_id_list          = [801, 802, 803]  # Static VM IDs
  
  # Also recommended
  pve_auto_increment_names = false
  pve_name_list           = ["vm-1", "vm-2", "vm-3"]
  
  # Enable parallel creation in provider
  # Set pm_parallel in your provider configuration
}
```

And in your provider configuration:

```hcl
provider "proxmox" {
  # ... other settings ...
  pm_parallel = 3  # Number of parallel operations
}
```

### Why This Is Required

The Proxmox provider has a known limitation where auto-increment VM IDs can cause race conditions during parallel creation, resulting in VM ID conflicts. See [GitHub Issue #1348](https://github.com/Telmate/terraform-provider-proxmox/issues/1348) for more details.

**Note**: Without static IDs, VMs will be created sequentially even with `pm_parallel` set.

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
| `pve_ci_ssh_keys`            | ssh public keys to assigned to ci user authorized_keys                                          | `list(string)` | `           |    no    |
| `pve_ci_user`                | cloud-init user                                                                                 | `string`       | `ansible`   |    no    |
| `pve_ci_password`            | cloud-init password                                                                             | `string`       | `ansible`   |    no    |
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

#### Serial Options

| Name              | Description                                      | Type     | Default  | Required |
| ----------------- | ------------------------------------------------ | -------- | -------- | :------: |
| `pve_add_serial`  | whether or not to add a serial device to each VM | `bool`   | `false`  |    no    |
| `[ve_serial_type` | type of serial device to add to each VM          | `string` | `socket` |    no    |
| `pve_serial_id`   | id of the serial device to add to each VM        | `string` | `1`      |    no    |


### PowerDNS Variables

| Name                    | Description                                                 | Type           | Default | Required |
| ----------------------- | ----------------------------------------------------------- | -------------- | ------- | :------: |
| `create_dns_record`     | whether or not to create DNS records for VMs               | `bool`         | `true`  |    no    |
| `pdns_zone`             | name of the PowerDNS zone to create the record in          | `string`       | n/a     |   yes    |
| `pdns_record_name_list` | list of names used for PowerDNS records created for VMs    | `list(string)` | n/a     |   yes    |
| `pdns_ttl`              | TTL value for PowerDNS records                             | `number`       | `300`   |    no    |

## Outputs

| Name         | Description                                                      | Type           | Sensitive |
| ------------ | ---------------------------------------------------------------- | -------------- | --------- |
| `vm_details` | list of VM details including VM ID, VM Description, IP, and DNS record | `list(object)` | no        |

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
  source     = "github.com/Knighten-Homelab/terraform-proxmox-vm-cluster?ref=1.7.0"
  node_count = 3

  # For parallel creation, use static IDs (recommended)
  pve_auto_increment_id = false
  pve_id_list          = [500, 501, 502]
  pve_auto_increment_names = false  
  pve_name_list        = ["test-cluster-node-0", "test-cluster-node-1", "test-cluster-node-2"]
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

  # DNS configuration (optional)
  create_dns_record = true
  pdns_zone = "homelab.lan"
  pdns_record_name_list = [
    "test-cluster-node-0",
    "test-cluster-node-1", 
    "test-cluster-node-2",
  ]
  pdns_ttl = 300
}
```

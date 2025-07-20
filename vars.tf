#####################
# Cluster Variables #
#####################

variable "node_count" {
  type        = number
  description = "number of vm nodes to create"
  default     = 1
}

#################
# PVE Variables #
#################

# VM ID Variables

variable "pve_auto_increment_id" {
  type        = bool
  description = "whether or not to auto increment the VM ID"
  default     = true
}

variable "pve_auto_increment_id_start" {
  type        = number
  description = "starting number to use for auto incrementing VM IDs, otherwise uses next available ID"
  default     = null
}

variable "pve_id_list" {
  type        = list(number)
  description = "list of VM IDs to use for each VM, if not using auto incrementing"
  default     = []
}

# VM Name Variables

variable "pve_auto_increment_names" {
  type        = bool
  description = "whether or not to auto increment node names (node-0, node-1, etc)"
  default     = true
}

variable "pve_base_name" {
  type        = string
  description = "base name to use for auto generated node names, if using auto increment"
  default     = "node"
}

variable "pve_name_list" {
  type        = list(string)
  description = "list of names to use for each VM, if not using auto incrementing"
  default     = []
}

# VM Node Assignment Variables

variable "pve_use_same_node" {
  type        = bool
  description = "whether or not to assign all VMs to the same PVE node"
  default     = true
}

variable "pve_node" {
  type        = string
  description = "name of the ProxMox node to create all VMs on, if pve_use_same_nod` == true"
  default     = "primary"
}

variable "pve_node_assignments" {
  type        = list(string)
  description = "list of nodes to deploy for each VM, if not deploying all to same node"
  default     = []
}

#  VM Description Variables

variable "pve_same_descrip" {
  type        = bool
  description = "whether or not to use a unique description for each VM"
  default     = true
}

variable "pve_desc" {
  type        = string
  description = "description to use for all VMs, if using pve_same_descrip == true"
  default     = "cluster node"
}

variable "pve_desc_list" {
  type        = list(string)
  description = "list of descriptions to use for each VM, if not using same description for all vms "
  default     = []
}

# Clone/Template Variables 

variable "pve_is_clone" {
  type        = bool
  description = "flag to determine if each VM is a clone or not (based off iso)"
  default     = true
}

variable "pve_template" {
  type        = string
  description = "name of the template to clone each VM from"
  default     = "ubuntu-server-22-04-base-template-homelab"
}

variable "pve_full_clone" {
  type        = bool
  description = "whether or not to do a full clone of the template"
  default     = true
}

variable "pve_iso" {
  type        = string
  description = "name of the iso to use for each VM, if not cloning"
  default     = ""
}

# Boot Options

variable "pve_boot_on_start" {
  type        = bool
  description = "whether or not to boot each VM on start"
  default     = false
}

variable "pve_startup_options" {
  type        = string
  description = "startup options separated with commas: boot order (order=), startup delay(up=), and shutdown delay(down=)"
  default     = ""
}

variable "pve_boot_disk" {
  type        = string
  description = "boot disk for each VM"
  default     = null
}

# CPU Options

variable "pve_core_count" {
  type        = string
  description = "number of cores to allocate to each VM"
  default     = "2"
}

variable "pve_cpu_type" {
  type        = string
  description = "type of CPU to use for each VM"
  default     = "host"
}

variable "pve_sockets" {
  type        = string
  description = "number of sockets to allocate to each VM"
  default     = "1"
}

# Memory Options

variable "pve_memory_size" {
  type        = number
  description = "amount of memory to allocate to the VM in MB"
  default     = 2048
}

variable "pve_memory_balloon" {
  type        = number
  description = "whether or not to use memory ballooning"
  default     = 0
}

# Network Options

variable "pve_networks" {
  type = list(object({
    model  = string
    bridge = string
    tag    = optional(string)
    queues = optional(string)
  }))
  description = "List of network configurations for the VM"
  default = [
    {
      model  = "virtio"
      bridge = "vmbr0"
      tag    = "-1"
      queues = "1"
    }
  ]
}

# Cloud-Init Options

variable "pve_use_ci" {
  type        = bool
  description = "whether or not to use the cloud_init"
  default     = true
}

variable "pve_ci_ssh_user" {
  type        = string
  description = "ssh user used to provision the VM"
  default     = "ansible"
}

variable "pve_ci_ssh_private_key" {
  type        = string
  description = "ssh private key to used to provision the VM"
  default     = ""
}

variable "pve_ci_ssh_keys" {
  type        = list(string)
  description = "ssh public keys to assigned to ci user authorized_keys"
  default     = []
}

variable "pve_ci_user" {
  type        = string
  description = "cloud-init user"
  default     = "ansible"
}

variable "pve_ci_password" {
  type        = string
  description = "cloud-init password"
  default     = null
}

variable "pve_ci_all_use_dhcp" {
  type        = bool
  description = "whether or not to use DHCP for all VMs"
  default     = true
}

variable "pve_ci_static_address_list" {
  type = list(object({
    ip_address         = string
    cidr_prefix_length = string
    gateway            = string
  }))
  description = "list of static addresses objects to use for each VM (one per VM), if not using DHCP for all VMs"
  default     = null
}

variable "pve_ci_dns_servers" {
  type        = string
  description = "ip of vm's dns server"
  default     = ""
}

variable "pve_ci_storage_location" {
  type        = string
  description = "storage location for the cloud-init iso"
  default     = "local-zfs"
}

# Disk Configuration

variable "pve_disk_size" {
  type        = string
  description = "size of the VM disk "
  default     = "40G"
}

variable "pve_use_same_disk_storage_location" {
  type        = bool
  description = "whether or not to use the same storage location for all VM disks"
  default     = true
}

variable "pve_disk_storage_location" {
  type        = string
  description = "storage location for the VM disk in all VMs, used if `pve_use_same_disk_storage_location` == `true`"
  default     = "local-zfs"
}

variable "pve_disk_storage_location_list" {
  type        = list(string)
  description = "list of storage locations for each VM disk, if not using same the same location "
  default     = []
}

variable "pve_scsihw" {
  type        = string
  description = "scsi hardware to use for the VM"
  default     = "virtio-scsi-pci"
}

# Agent Options

variable "pve_use_agent" {
  type        = number
  description = "whether or not to use the agent in each VM"
  default     = 1
}

# Serial Options

variable "pve_add_serial" {
  type        = bool
  description = "whether or not to add a serial device to each vm"
  default     = false
}

variable "pve_serial_type" {
  type        = string
  description = "type of serial device to add to each vm"
  default     = "socket"
}

variable "pve_serial_id" {
  type        = number
  description = "id of the serial device to add to each vm"
  default     = 0
}


############
# PowerDNS #
############

variable "create_dns_record" {
  type        = bool
  description = "whether or not to create DNS records for VMs"
  default     = true
}

variable "pdns_zone" {
  type        = string
  description = "name of the PowerDNS zone to create the record in"
}

variable "pdns_record_name_list" {
  type        = list(string)
  description = "list of names used for PowerDNS records created for VMs"
}

variable "pdns_ttl" {
  type        = number
  description = "TTL value for PowerDNS records"
  default     = 300
}

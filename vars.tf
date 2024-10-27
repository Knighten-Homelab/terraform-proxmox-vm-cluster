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
  description = "list of VM IDs for each VM"
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
  description = "base name to use for auto generated node names"
  default     = "node"
}

variable "pve_name_list" {
  type        = list(string)
  description = "list of names for each VM"
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
  description = "name of the ProxMox node to create all VMs on"
  default     = "primary"
}

variable "pve_node_assignments" {
  type        = list(string)
  description = "list of nodes to deploy for each VM"
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
  description = "description to use for all VMs"
  default     = "cluster node"
}

variable "pve_desc_list" {
  type        = list(string)
  description = "list of descriptions for each VM"
  default     = []
}

# Clone/Template Variables 

variable "pve_is_clone" {
  type        = bool
  description = "Flag to determine if the VM is a clone or not (based off iso)"
  default     = true
}

variable "pve_template" {
  type        = string
  description = "name of the PVE template to clone"
  default     = "ubuntu-server-22-04-base-template-homelab"
}

variable "pve_full_clone" {
  type        = bool
  description = "whether or not to do a full clone of the template"
  default     = true
}

variable "pve_iso" {
  type        = string
  description = "iso to use for the VM"
  default     = ""
}

# Boot Options

variable "pve_boot_on_start" {
  type        = bool
  description = "whether or not to boot the VM on start"
  default     = false
}

variable "pve_startup_options" {
  type        = string
  description = "startup options seperated via comma: boot order (order=), startup delay(up=), and shutdown delay(down=)"
  default     = ""
}

variable "pve_boot_disk" {
  type        = string
  description = "boot disk for the VM"
  default     = null
}

# CPU Options

variable "pve_core_count" {
  type        = string
  description = "number of cores to allocate to the VM"
  default     = "2"
}

variable "pve_cpu_type" {
  type        = string
  description = "type of CPU to use for the VM"
  default     = "host"
}

variable "pve_sockets" {
  type        = string
  description = "number of sockets to allocate to the VM"
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
  description = "ssh user to used to provision the VM"
  default     = "ansible"
}

variable "pve_ci_ssh_private_key" {
  type        = string
  description = "ssh private key to used to provision the VM"
  default     = ""
}

variable "pve_ci_all_use_dhcp" {
  type        = bool
  description = "whether or not to use DHCP for all VMs"
  default     = true
}

variable "pve_ci_static_address_list" {
  type = list(object({
    ip_address   = string
    network_bits = string
    gateway      = string
  }))
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
  description = "storage location for the VM disk"
  default     = "local-zfs"
}

variable "pve_disk_storage_location_list" {
  type        = list(string)
  description = "list of storage locations for each VM disk"
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
  description = "whether or not to use the agent"
  default     = 1
}

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

variable "auto_increment_vm_id" {
  type        = bool
  description = "whether or not to auto increment the VM ID"
  default     = true
}

variable "auto_increment_vm_id_start" {
  type        = number
  description = "starting number to use for auto incrementing VM IDs, otherwise uses next available ID"
  default     = null
}

variable "vm_id_list" {
  type        = list(number)
  description = "list of VM IDs for each VM"
  default     = []
}

# VM Name Variables

variable "auto_increment_vm_names" {
  type        = bool
  description = "whether or not to auto increment node names (node-0, node-1, etc)"
  default     = true
}

variable "vm_base_name" {
  type        = string
  description = "base name to use for auto generated node names"
  default     = "node"
}

variable "vm_name_list" {
  type        = list(string)
  description = "list of names for each VM"
  default     = []
}

# VM Node Assignment Variables

variable "use_same_node" {
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

variable "same_description" {
  type        = bool
  description = "whether or not to use a unique description for each VM"
  default     = true
}

variable "vm_desc" {
  type        = string
  description = "description to use for all VMs"
  default     = "cluster node"
}

variable "vm_desc_list" {
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

variable "pve_vm_full_clone" {
  type        = bool
  description = "whether or not to do a full clone of the template"
  default     = true
}

variable "pve_vm_iso" {
  type        = string
  description = "iso to use for the VM"
  default     = ""
}

# Boot Options

variable "pve_vm_boot_on_start" {
  type        = bool
  description = "whether or not to boot the VM on start"
  default     = false
}

variable "pve_vm_startup_options" {
  type        = string
  description = "startup options seperated via comma: boot order (order=), startup delay(up=), and shutdown delay(down=)"
  default     = ""
}

variable "pve_vm_boot_disk" {
  type        = string
  description = "boot disk for the VM"
  default     = null
}

# CPU Options

variable "pve_vm_core_count" {
  type        = string
  description = "number of cores to allocate to the VM"
  default     = "2"
}

variable "pve_vm_cpu_type" {
  type        = string
  description = "type of CPU to use for the VM"
  default     = "host"
}

variable "pve_vm_sockets" {
  type        = string
  description = "number of sockets to allocate to the VM"
  default     = "1"
}

# Memory Options

variable "pve_vm_memory_size" {
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

variable "pve_vm_networks" {
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

variable "pve_use_cloud_init" {
  type        = bool
  description = "whether or not to use the cloud_init"
  default     = true
}

variable "pve_ssh_user" {
  type        = string
  description = "ssh user to used to provision the VM"
  default     = "ansible"
}

variable "pve_ssh_private_key" {
  type        = string
  description = "ssh private key to used to provision the VM"
  default     = ""
}

variable "all_dhcp" {
  type        = bool
  description = "whether or not to use DHCP for all VMs"
  default     = true
}

variable "static_addresses" {
  type = list(object({
    ip_address   = string
    network_bits = string
    gateway      = string
  }))
}

variable "pve_vm_dns_server" {
  type        = string
  description = "ip of vm's dns server"
  default     = ""
}

variable "pve_cloudinit_storage_location" {
  type        = string
  description = "storage location for the cloud-init iso"
  default     = "local-zfs"
}

# Disk Configuration

variable "pve_vm_disk_size" {
  type        = string
  description = "size of the VM disk "
  default     = "20G"
}

variable "same_disk_storage_location" {
  type        = bool
  description = "whether or not to use the same storage location for all VM disks"
  default     = true
}

variable "pve_vm_disk_storage_location" {
  type        = string
  description = "storage location for the VM disk"
  default     = "local-zfs"
}

variable "pve_vm_disk_storage_location_list" {
  type        = list(string)
  description = "list of storage locations for each VM disk"
  default     = []
}

variable "pve_vm_scsihw" {
  type        = string
  description = "scsi hardware to use for the VM"
  default     = "virtio-scsi-pci"
}

# Agent Options

variable "pve_vm_agent" {
  type        = number
  description = "whether or not to use the agent"
  default     = 1
}

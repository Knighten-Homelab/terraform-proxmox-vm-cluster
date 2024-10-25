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



# ############################
# #  Required Auth Variables #
# ############################

# variable "ansible_service_account_ssh_key" {
#   type        = string
#   description = "SSH key for the ansible service account"
# }

# #################
# # PVE Variables #
# #################

# variable "pve_vm_name_base" {
#   description = "base name of the VM to create"
#   type        = string
# }

# variable "pve_template" {
#   description = "name of the PVE template to clone"
#   type        = string
# }

# variable "pve_vm_full_clone" {
#   description = "whether or not to do a full clone"
#   type        = bool
# }

# variable "pve_vm_core_count" {
#   description = "number of cores to allocate to the VM"
#   type        = number
# }

# variable "pve_vm_memory" {
#   description = "amount of memory to allocate to the VM in MB"
#   type        = number
# }

# variable "pve_vm_gateway" {
#   description = "gateway to use for the VM, must be set if using static IP"
#   type        = string
# }

# variable "pve_vm_dns_server" {
#   description = "ip of vm's dns server"
#   type        = string
# }

# variable "pve_vm_vlan_tag" {
#   description = "VLAN tag to use for the VM"
#   type        = number
# }

# variable "pve_vm_packet_queue_count" {
#   description = "number of VM packet queues"
#   type        = number
# }

# variable "pve_vm_desc_list" {
#   description = "list of descriptions for each VM"
#   type        = list(string)
# }

# variable "pve_node_list" {
#   description = "list of nodes to deploy for each VM"
#   type        = list(string)
# }

# variable "pve_vm_use_static_ip_list" {
#   description = "list of booleans indicating if each VM should use a static IP"
#   type        = list(bool)
# }

# variable "pve_vm_ip_list" {
#   description = "list of IP addresses for each VM"
#   type        = list(string)
# }

# variable "pve_vm_subnet_network_bits_list" {
#   description = "list of subnet network bits for each VM"
#   type        = list(string)
# }

# variable "pve_vm_boot_on_start_list" {
#   description = "list of booleans indicating if each VM should boot on start"
#   type        = list(bool)
# }

# variable "pve_vm_startup_options_list" {
#   description = "list of startup options for each VM"
#   type        = list(string)
# }

# variable "pve_vm_disk_storage_location_list" {
#   description = "list of disk storage locations for each VM"
#   type        = list(string)
# }

# ############
# # PowerDNS #
# ############

# variable "pdns_zone" {
#   description = "name of the PowerDNS zone to create the record in"
#   type        = string
# }

# variable "pdns_record_name_list" {
#   description = "list of record names for each VM"
#   type        = list(string)
# }

# #################
# # AWX Variables #
# #################

# variable "awx_organization" {
#   description = "name of the AWX organization to create the host in"
#   type        = string
# }

# variable "awx_inventory" {
#   description = "name of the AWX inventory to create the host in"
#   type        = string
# }

# variable "awx_host_groups" {
#   description = "comma separated list of AWX host groups to add the host tos"
#   type        = list(string)
# }

# variable "awx_host_name_list" {
#   description = "list of names for AWX hosts for each VM"
#   type        = list(string)
# }

# variable "awx_host_description_list" {
#   description = "list of descriptions for AWX host for each VM"
#   type        = list(string)
# }

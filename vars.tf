#################
# Cluster Nodes #
#################

variable "cluster_node_count" {
  type        = number
  description = "number of vm nodes to create"
  default     = 3
}

############################
#  Required Auth Variables #
############################

variable "pve_username" {
  type        = string
  description = "username for the ProxMox API"
}

variable "pve_password" {
  type        = string
  description = "password for the ProxMox API "
}

variable "ansible_service_account_ssh_key" {
  type        = string
  description = "SSH key for the ansible service account"
}

variable "pdns_api_key" {
  type        = string
  description = "API key for the PowerDNS API"
}

variable "awx_account_username" {
  type        = string
  description = "username used to interact with the AWX API"
}

variable "awx_account_password" {
  type        = string
  description = "password used to interact with the AWX API"
}

#################
# PVE Variables #
#################

variable "pve_cluster_url" {
  type        = string
  description = "URL for the ProxMox cluster"
}

variable "pve_vm_name_base" {
  description = "base name of the VM to create"
  type        = string
}

variable "pve_template" {
  description = "name of the PVE template to clone"
  type        = string
}

variable "pve_vm_full_clone" {
  description = "whether or not to do a full clone"
  type        = bool
}

variable "pve_vm_core_count" {
  description = "number of cores to allocate to the VM"
  type        = number
}

variable "pve_vm_memory" {
  description = "amount of memory to allocate to the VM in MB"
  type        = number
}

variable "pve_vm_gateway" {
  description = "gateway to use for the VM, must be set if using static IP"
  type        = string
}

variable "pve_vm_dns_server" {
  description = "ip of vm's dns server"
  type        = string
}

variable "pve_vm_vlan_tag" {
  description = "VLAN tag to use for the VM"
  type        = number
}

variable "pve_vm_packet_queue_count" {
  description = "number of VM packet queues"
  type        = number
}

variable "pve_vm_desc_list" {
  description = "list of descriptions for each VM"
  type        = list(string)
}

variable "pve_node_list" {
  description = "list of nodes to deploy for each VM"
  type        = list(string)
}

variable "pve_vm_use_static_ip_list" {
  description = "list of booleans indicating if each VM should use a static IP"
  type        = list(bool)
}

variable "pve_vm_ip_list" {
  description = "list of IP addresses for each VM"
  type        = list(string)
}

variable "pve_vm_subnet_network_bits_list" {
  description = "list of subnet network bits for each VM"
  type        = list(string)
}

variable "pve_vm_boot_on_start_list" {
  description = "list of booleans indicating if each VM should boot on start"
  type        = list(bool)
}

variable "pve_vm_startup_options_list" {
  description = "list of startup options for each VM"
  type        = list(string)
}

variable "pve_vm_disk_storage_location_list" {
  description = "list of disk storage locations for each VM"
  type        = list(string)
}

############
# PowerDNS #
############

variable "pdns_url" {
  description = "URL for the PowerDNS server"
  type        = string
}

variable "pdns_zone" {
  description = "name of the PowerDNS zone to create the record in"
  type        = string
}

variable "pdns_record_name_list" {
  description = "list of record names for each VM"
  type        = list(string)
}

#################
# AWX Variables #
#################

variable "awx_url" {
  description = "URL for the AWX server"
  type        = string
}

variable "awx_organization" {
  description = "name of the AWX organization to create the host in"
  type        = string
}

variable "awx_inventory" {
  description = "name of the AWX inventory to create the host in"
  type        = string
}

variable "awx_host_groups" {
  description = "comma separated list of AWX host groups to add the host tos"
  type        = list(string)
}

variable "awx_host_name_list" {
  description = "list of names for AWX hosts for each VM"
  type        = list(string)
}

variable "awx_host_description_list" {
  description = "list of descriptions for AWX host for each VM"
  type        = list(string)
}

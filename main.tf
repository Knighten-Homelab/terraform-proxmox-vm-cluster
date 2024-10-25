terraform {
  required_version = "1.9.8"
}

module "pve-vm-cluster" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm?ref=1.3.4"
  count  = var.node_count

  pve_node    = var.use_same_node ? var.pve_node : var.pve_node_assignments[count.index]
  pve_vm_id   = var.auto_increment_vm_id ? (var.auto_increment_vm_id_start != null ? var.auto_increment_vm_id_start + count.index : 0) : var.vm_id_list[count.index]
  pve_vm_name = var.auto_increment_vm_names ? format("%s-%s", var.vm_base_name, count.index) : var.vm_name_list[count.index]
  pve_vm_desc = var.same_description ? var.vm_desc : var.vm_desc_list[count.index]

  pdns_zone        = "homelab.lan"
  pdns_record_name = format("%s-%s", "test-vm", count.index)

  awx_organization     = "Homelab"
  awx_inventory        = "Homelab Endpoints"
  awx_host_groups      = ["proxmox-hosts"]
  awx_host_name        = format("%s-%s", "test-vm", count.index)
  awx_host_description = "A test VM created by Terraform"
}

# module "pve-vm-cluster" {
#   source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm?ref=1.3.4"
#   count  = var.cluster_node_count

#   // Authentication Vars
#   ansible_service_account_ssh_key = var.ansible_service_account_ssh_key

#   // PVE Vars Shared Across All VMs
#   pve_template              = var.pve_template
#   pve_vm_full_clone         = var.pve_vm_full_clone
#   pve_vm_core_count         = var.pve_vm_core_count
#   pve_vm_memory             = var.pve_vm_memory
#   pve_vm_gateway            = var.pve_vm_gateway
#   pve_vm_dns_server         = var.pve_vm_dns_server
#   pve_vm_vlan_tag           = var.pve_vm_vlan_tag
#   pve_vm_packet_queue_count = var.pve_vm_packet_queue_count

#   // PVE Vars Unique To Each VM
#   pve_vm_name                  = format("%s-%s", var.pve_vm_name_base, count.index)
#   pve_vm_desc                  = var.pve_vm_desc_list[count.index]
#   pve_node                     = var.pve_node_list[count.index]
#   pve_vm_use_static_ip         = var.pve_vm_use_static_ip_list[count.index]
#   pve_vm_ip                    = var.pve_vm_ip_list[count.index]
#   pve_vm_subnet_network_bits   = var.pve_vm_subnet_network_bits_list[count.index]
#   pve_vm_boot_on_start         = var.pve_vm_boot_on_start_list[count.index]
#   pve_vm_startup_options       = var.pve_vm_startup_options_list[count.index]
#   pve_vm_disk_storage_location = var.pve_vm_disk_storage_location_list[count.index]


#   // PowerDNS Vars Shared Across All VMs
#   pdns_zone = var.pdns_zone

#   // PowerDNS Vars Unique To Each VM
#   pdns_record_name = var.pdns_record_name_list[count.index]

#   // AWX Vars Shared Across All VMs
#   awx_organization = var.awx_organization
#   awx_inventory    = var.awx_inventory
#   awx_host_groups  = var.awx_host_groups

#   // AWX Vars Unique To Each VM
#   awx_host_name        = var.awx_host_name_list[count.index]
#   awx_host_description = var.awx_host_description_list[count.index]

# }

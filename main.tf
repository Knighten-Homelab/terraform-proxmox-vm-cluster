terraform {
  required_version = "1.9.8"
}

module "pve-vm-cluster" {
  source = "github.com/Johnny-Knighten/terraform-homelab-pve-vm?ref=1.3.4"
  count  = var.node_count

  # Core PVE Fields
  pve_node  = var.use_same_node ? var.pve_node : var.pve_node_assignments[count.index]
  pve_vm_id = var.auto_increment_vm_id ? (var.auto_increment_vm_id_start != null ? var.auto_increment_vm_id_start + count.index : 0) : var.vm_id_list[count.index]

  # Metadata Fields
  pve_vm_name = var.auto_increment_vm_names ? format("%s-%s", var.vm_base_name, count.index) : var.vm_name_list[count.index]
  pve_vm_desc = var.same_description ? var.vm_desc : var.vm_desc_list[count.index]

  # Clone/Template Fields
  pve_is_clone      = var.pve_is_clone
  pve_template      = var.pve_template
  pve_vm_full_clone = var.pve_vm_full_clone
  pve_vm_iso        = var.pve_vm_iso

  # Boot Options
  pve_vm_boot_on_start   = var.pve_vm_boot_on_start
  pve_vm_startup_options = var.pve_vm_startup_options
  pve_vm_boot_disk       = var.pve_vm_boot_disk

  # CPU Options
  pve_vm_core_count = var.pve_vm_core_count
  pve_vm_sockets    = var.pve_vm_sockets
  pve_vm_cpu_type   = var.pve_vm_cpu_type

  # Memory Options
  pve_vm_memory_size = var.pve_vm_memory_size
  pve_memory_balloon = var.pve_memory_balloon

  # Network Options
  pve_vm_networks = var.pve_vm_networks

  # Cloud-Init Options
  pve_use_cloud_init             = var.pve_use_cloud_init
  pve_ssh_user                   = var.pve_ssh_user
  pve_ssh_private_key            = var.pve_ssh_private_key
  pve_vm_dns_server              = var.pve_vm_dns_server
  pve_cloudinit_storage_location = var.pve_cloudinit_storage_location
  pve_vm_use_static_ip           = !var.all_dhcp
  pve_vm_ip                      = var.all_dhcp ? null : var.static_addresses[count.index].ip_address
  pve_vm_subnet_network_bits     = var.all_dhcp ? null : var.static_addresses[count.index].subnet_network_bits
  pve_vm_gateway                 = var.all_dhcp ? null : var.static_addresses[count.index].gateway

  # Disk Configuration
  pve_vm_disk_size             = var.pve_vm_disk_size
  pve_vm_disk_storage_location = var.same_disk_storage_location ? var.pve_vm_disk_storage_location : var.pve_vm_disk_storage_location_list[count.index]
  pve_vm_scsihw                = var.pve_vm_scsihw

  # Agent Options
  pve_vm_agent = var.pve_vm_agent

  pdns_zone        = "homelab.lan"
  pdns_record_name = format("%s-%s", "test-vm", count.index)

  awx_organization     = "Homelab"
  awx_inventory        = "Homelab Endpoints"
  awx_host_groups      = ["proxmox-hosts"]
  awx_host_name        = format("%s-%s", "test-vm", count.index)
  awx_host_description = "A test VM created by Terraform"
}

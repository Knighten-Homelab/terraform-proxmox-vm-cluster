module "pve-vm-cluster" {
  source = "github.com/Knighten-Homelab/terraform-proxmox-vm?ref=2.8.0"
  count  = var.node_count

  # Core PVE Fields
  pve_node = var.pve_use_same_node ? var.pve_node : var.pve_node_assignments[count.index]
  pve_id   = var.pve_auto_increment_id ? (var.pve_auto_increment_id_start != null ? var.pve_auto_increment_id_start + count.index : 0) : var.pve_id_list[count.index]

  # Metadata Fields
  pve_name = var.pve_auto_increment_names ? format("%s-%s", var.pve_base_name, count.index) : var.pve_name_list[count.index]
  pve_desc = var.pve_same_descrip ? var.pve_desc : var.pve_desc_list[count.index]

  # Clone/Template Fields
  pve_is_clone   = var.pve_is_clone
  pve_template   = var.pve_template
  pve_full_clone = var.pve_full_clone
  pve_iso        = var.pve_iso

  # Boot Options
  pve_boot_on_start   = var.pve_boot_on_start
  pve_startup_options = var.pve_startup_options
  pve_boot_disk       = var.pve_boot_disk

  # CPU Options
  pve_core_count = var.pve_core_count
  pve_sockets    = var.pve_sockets
  pve_cpu_type   = var.pve_cpu_type

  # Memory Options
  pve_memory_size    = var.pve_memory_size
  pve_memory_balloon = var.pve_memory_balloon

  # Network Options
  pve_networks = var.pve_networks

  # Cloud-Init Options
  pve_use_ci = var.pve_use_ci

  pve_ci_ssh_user           = var.pve_ci_ssh_user
  pve_ci_ssh_private_key    = var.pve_ci_ssh_private_key
  pve_ci_ssh_keys           = var.pve_ci_ssh_keys
  pve_ci_user               = var.pve_ci_user
  pve_ci_password           = var.pve_ci_password
  pve_ci_dns_servers        = var.pve_ci_dns_servers
  pve_ci_storage_location   = var.pve_ci_storage_location
  pve_ci_use_dhcp           = var.pve_ci_all_use_dhcp
  pve_ci_ip_address         = var.pve_ci_all_use_dhcp ? "" : var.pve_ci_static_address_list[count.index].ip_address
  pve_ci_cidr_prefix_length = var.pve_ci_all_use_dhcp ? "" : var.pve_ci_static_address_list[count.index].cidr_prefix_length
  pve_ci_gateway_address    = var.pve_ci_all_use_dhcp ? "" : var.pve_ci_static_address_list[count.index].gateway

  # Disk Configuration
  pve_disk_size             = var.pve_disk_size
  pve_disk_storage_location = var.pve_use_same_disk_storage_location ? var.pve_disk_storage_location : var.pve_disk_storage_location_list[count.index]
  pve_scsihw                = var.pve_scsihw

  # Agent Options
  pve_use_agent = var.pve_use_agent

  pve_add_serial  = var.pve_add_serial
  pve_serial_type = var.pve_serial_type
  pve_serial_id   = var.pve_serial_id

  # PDNS Options
  create_dns_record = var.create_dns_record
  pdns_zone         = var.pdns_zone
  pdns_record_name  = var.pdns_record_name_list[count.index]
  pdns_ttl          = var.pdns_ttl
}

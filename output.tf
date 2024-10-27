output "vm_details" {
  value = [
    for i in range(var.node_count) : {
      ip-address = module.pve-vm-cluster[i].ip-address
      dns-record = module.pve-vm-cluster[i].dns-record
    }
  ]
  description = "List of VM details including IP and DNS record."
}

output "vm_details" {
  value = [
    for i in range(var.node_count) : {
      vm_id          = module.pve-vm-cluster[i].vm_id
      vm_name        = module.pve-vm-cluster[i].vm_name
      vm_ip_address  = module.pve-vm-cluster[i].vm_ip_address
      vm_dns_records = module.pve-vm-cluster[i].vm_dns_records
    }
  ]
  description = "List of VM details including VM ID, VM Descrip,SIP, and DNS record."
}

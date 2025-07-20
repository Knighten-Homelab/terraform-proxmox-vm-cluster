terraform {
  required_version = ">= 1.9.8"

  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "3.0.2-rc01"
    }
    powerdns = {
      source  = "pan-net/powerdns"
      version = "1.5.0"
    }
  }
}

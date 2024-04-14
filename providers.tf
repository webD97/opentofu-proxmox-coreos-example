terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.51.0"
    }
    ct = {
      source  = "poseidon/ct"
      version = "0.13.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
  }
}

provider "proxmox" {
  endpoint = "https://pve.mydomain.tld:8006"
  # If Proxmox uses a self-signed TLS certificate, ignore the unknown issuer
  insecure = true

  # Some resources require SSH access to Proxmox.
  ssh {
    agent = true
  }
}

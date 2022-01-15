terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.3"
    }
  }

  experiments = [module_variable_optional_attrs]
}
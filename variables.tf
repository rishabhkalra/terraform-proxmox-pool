variable "proxmox_host" {
  description = "Name of the proxmox host."
  type        = string
}

variable "template_name" {
  description = "Name of the cloudinit template to clone."
  type        = string
}

variable "network_gateway" {
  description = "IP address of your network gateway."
  type        = string
}

variable "authorized_keys" {
  description = "Path to the file containing public SSH key(s) for remote access to VMs."
  type        = string
}

variable "vm_types" {
  description = "Map of different VM size configurations."
  type        = map(any)
}

variable "pools" {
  description = "Map of VM pools you want to create and the configuration to go with it."
  type        = map(any)
}

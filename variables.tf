variable "proxmox_host" {
  description = "Name of the proxmox host."
  type        = string
}

variable "node_template_name" {
  description = "Name of the cloudinit template to clone."
  type        = string
}

variable "network_gateway" {
  description = "IP address of your network gateway."
  type        = string
}

variable "authorized_keys" {
  description = "Path to the file containing public SSH key(s) for remote access to nodes."
  type        = string
}

variable "node_types" {
  description = "Map of different node size configurtions."
  type        = map(any)
}

variable "nodes" {
  description = "Map of node groups you want to create and the configuration to go with it."
  type        = map(any)
}
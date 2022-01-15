locals {
  node_list = flatten([
    for node in var.nodes : [
      for i in range(node.node_count) :
      merge(node, {
        id      = i
        node_ip = cidrhost(node.node_subnet, i)
      })
    ]
  ])

  node_map = {
    for node in local.node_list : "${node.node_prefix}-${node.id + 1}" => node
  }

  node_inventory = {
    for i in var.nodes : i.node_prefix => [for instance in local.node_list : instance.node_ip if instance.node_prefix == i.node_prefix]
  }
}

resource "random_uuid" "node_identifier" {
  for_each = local.node_map

  keepers = {
    node_id = "${each.value.node_prefix}-${each.value.id + 1}"
  }
}

resource "proxmox_vm_qemu" "vm" {
  for_each = local.node_map

  target_node = var.proxmox_host
  name        = "${each.value.node_prefix}-${random_uuid.node_identifier[each.key].result}"
  clone       = var.node_template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = var.node_types[each.value.node_type].cores
  sockets  = 1
  cpu      = "host"
  memory   = var.node_types[each.value.node_type].memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot     = 0
    size     = var.node_types[each.value.node_type].storage
    type     = "scsi"
    storage  = "local-lvm"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=${each.value.node_ip}/${split("/", each.value.node_subnet)[1]},gw=${var.network_gateway}"

  sshkeys = file(var.authorized_keys)
}

locals {
  vm_list = flatten([
    for pool in var.pools : [
      for i in range(pool.vm_count) : {
        id           = i
        ip           = pool.vm_ips[i]
        prefix       = pool.vm_prefix
        type         = pool.vm_type
        disk_storage = pool.disk_storage
    }]
    ]
  )

  vm_map = {
    for vm in local.vm_list : "${vm.prefix}-${vm.id + 1}" => vm
  }

  vm_inventory = {
    for pool in var.pools : pool.vm_prefix => [for vm in local.vm_list : vm.ip if vm.prefix == pool.vm_prefix]
  }
}

resource "proxmox_vm_qemu" "vm" {
  for_each = local.vm_map

  target_node = var.proxmox_host
  name        = each.key
  clone       = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = var.vm_types[each.value.type].cores
  sockets  = 1
  cpu      = "host"
  memory   = var.vm_types[each.value.type].memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot     = 0
    size     = var.vm_types[each.value.type].disk_size
    type     = "scsi"
    storage  = each.value.disk_storage
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

  ipconfig0 = "ip=${each.value.ip},gw=${var.network_gateway}"

  sshkeys = file(var.authorized_keys)
}

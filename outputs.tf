output "ansible_inventory" {
  depends_on = [
    proxmox_vm_qemu.vm
  ]

  value = templatefile("${path.module}/inventory.tftpl", { inventory = local.vm_inventory })
}

output "machine_inventory" {
  depends_on = [
    proxmox_vm_qemu.vm
  ]

  value = local.vm_map
}
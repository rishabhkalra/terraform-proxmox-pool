output "ansible_inventory" {
  depends_on = [
    proxmox_vm_qemu.vm
  ]

  value = templatefile("${path.module}/inventory.tftpl", { inventory = local.node_inventory })
}
# terraform-proxmox-pool

A terraform module to provision similarly configured pools of VMs.

## Why did I make this?

I spun up some VMs for a cluster on my microserver for my homelab and everything was great; until I wanted to add additional nodes. I quickly realized I didn't want to have to manually add nodes. So I built this module to allow me to quickly provision any number of VMs, with a little bit of configuration. The best part is that if I scale up my hardware later, I can add additional VM sizes to allow for more flexibility.

## What does it to?

- fully automated VM creation
- easily customizable to your hardware and can scale with you & your hardware
  - currently you're able to configure the number of cores, memory & storage
- support for creating pools of VMs of different sizes
  - note that all VMs in the same pool will be the same size; the size affects all VMs of the same group
- outputs an ansible inventory file for easy integration; or you can configure the VMs however you'd like

## Is it on the Terraform Registry?

Yes! You can find it here on the [official Terraform Registry](https://registry.terraform.io/modules/rishabhkalra/pool/proxmox/latest)

## How do I use it?

```terraform
module "cluster" {
  source = "rishabhkalra/pool/proxmox"
  version = "0.0.1"

  proxmox_host = "proxmox"

  node_template_name = "template_name"

  network_gateway = "x.x.x.x"

  authorized_keys = "authorized_keys"

  node_types = {
    sm = {
      cores = 2
      memory = 1024
      storage = "5G"
    },
    md = {
      cores = 2
      memory = 4096
      storage = "10G"
    },
    lg = {
      cores = 4
      memory = 8192
      storage = "20G"
    }
  }

  nodes = {
    support = {
      node_prefix = "support" # node names will use be of the format 'node_prefix-uuid'
      node_subnet = "x.x.x.x/x"
      node_type = "sm" # note that this type must match a type defined in the node_types map above
      node_count = 0
    },
    control_plane = {
      node_prefix = "control_plane"
      node_subnet = "x.x.x.x/x"
      node_type = "md"
      node_count = 0
    },
    agents = {
      node_prefix = "agent"
      node_subnet = "x.x.x.x/x"
      node_type = "lg"
      node_count = 0
    }
  }
}
```

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "arch_cloudinit" {
  name   = "arch-cloudinit"
  pool   = "default"
  source = "https://pkgbuild.com/~shibumi/Arch-Linux-cloudimg-amd64-2020-03-04.img"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name      = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
  pool      = "default"
}

resource "libvirt_volume" "as-system1" {
  name           = "as-system1"
  base_volume_id = libvirt_volume.arch_cloudinit.id
  pool           = "default"
  size           = 60000000000
}

resource "libvirt_domain" "as-system1" {
  name   = "as-system1"
  memory = "2048"
  vcpu   = 2

  qemu_agent = true
  autostart  = true

  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.as-system1.id
  }

  network_interface {
    network_name = "default"
  }

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }
}

output "ip1" {
  value = "${libvirt_domain.as-system1.network_interface.0.addresses.0}"
}

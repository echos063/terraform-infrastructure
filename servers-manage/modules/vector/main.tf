data "template_file" "user_data_vector" {
  template       = file("./modules/vector/cloud-init/vector/user-data.yml")
}

resource "libvirt_cloudinit_disk" "cloudinit_vector" {
  count          = var.vector_counter
  name           = "${var.env}-vector${count.index}.iso"
  user_data      =  data.template_file.user_data_vector.rendered
  pool           = "default"
}

resource "libvirt_volume" "vector-volume" {
  count          = var.vector_counter
  name           = "${var.env}-vector-volume${count.index}"
  pool           = "default" # List storage pools using virsh pool-list
  source         = "/pools/lib/Companyint-redos7.qcow2"
  format         = "qcow2"
}

resource "libvirt_domain" "vector" {
  count          = var.vector_counter
  name           = "${var.env}-vector${count.index}"
  memory         = "2048"
  vcpu           = 1

  cloudinit      = libvirt_cloudinit_disk.cloudinit_vector[count.index].id

  network_interface {
    network_id   = var.backend_network_id
    hostname     = "${var.env}-vector${count.index}"
    addresses    = [local.vector_ips[var.env]]
    mac          = local.vector_macs[var.env]
    wait_for_lease = true
  }
  disk {
    volume_id    = "${libvirt_volume.vector-volume[count.index].id}"
  }
  boot_device {
    dev          = [ "hd" ]
  }
  console {
    type = "pty"
    target_type  = "serial"
    target_port  = "0"
  }
  graphics {
    type         = "vnc"
    listen_type  = "address"
    autoport     = true
  }
  timeouts {
    create       = "5m"
  }
}

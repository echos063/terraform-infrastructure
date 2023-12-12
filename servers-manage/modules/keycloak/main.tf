data "template_file" "user_data_keycloak" {
  template       = file("./modules/keycloak/cloud-init/user-data.yml")
}

resource "libvirt_cloudinit_disk" "cloudinit_keycloak" {
  count          = var.keycloak_counter
  name           = "${var.env}-keycloak${count.index}.iso"
  user_data      =  data.template_file.user_data_keycloak.rendered
  pool           = "default"
}

resource "libvirt_volume" "keycloak-volume" {
  count          = var.keycloak_counter
  name           = "${var.env}-keycloak-volume${count.index}"
  pool           = "default" # List storage pools using virsh pool-list
  source         = "/pools/lib/Companyint-redos7.qcow2"
  format         = "qcow2"
}

resource "libvirt_domain" "keycloak" {
  count          = var.keycloak_counter
  name           = "${var.env}-keycloak${count.index}"
  memory         = "2048"
  vcpu           = 1

  cloudinit      = libvirt_cloudinit_disk.cloudinit_keycloak[count.index].id

  network_interface {
    network_id   = var.backend_network_id
    hostname     = "${var.env}-keycloak${count.index}"
    addresses    = [local.keycloak_ips[var.env]]
    mac          = local.keycloak_mac[var.env]
    wait_for_lease = true
  }
  disk {
    volume_id    = "${libvirt_volume.keycloak-volume[count.index].id}"
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

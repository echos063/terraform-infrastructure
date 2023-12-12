data "template_file" "user_data_postgres-infra" {
  template       = file("./modules/postgres-infra/cloud-init/user-data.yml")
}

resource "libvirt_cloudinit_disk" "cloudinit_postgres-infra" {
  count          = var.postgres_counter
  name           = "${var.env}-postgres-infra${count.index}.iso"
  user_data      =  data.template_file.user_data_postgres-infra.rendered
  pool           = "default"
}

resource "libvirt_volume" "postgres-infra-volume" {
  count          = var.postgres_counter
  name           = "${var.env}-postgres-infra${count.index}-volume"
  pool           = "default" # List storage pools using virsh pool-list
  source         = "/pools/lib/Companyint-redos7.qcow2"
  format         = "qcow2"
}
#resource "libvirt_volume" "postgres-infra-data-volume" {
#  count          = var.postgres_counter
#  name           = "postgres-infra-data-volume${count.index}"
#  pool           = "default" # List storage pools using virsh pool-list
#  source         = "/pools/lib/postgres-infra-external.qcow2"
#  format         = "qcow2"
#}

resource "libvirt_domain" "postgres-infra" {
  count          = var.postgres_counter
  name           = "${var.env}-postgres-infra${count.index}"
  memory         = "2048"
  vcpu           = 1

  cloudinit      = libvirt_cloudinit_disk.cloudinit_postgres-infra[count.index].id

  network_interface {
    network_id   = var.backend_network_id
    hostname     = "${var.env}-postgres${count.index}"
    addresses    = [local.postgres_ips[var.env]]
    mac          = local.postgres_mac[var.env]
    wait_for_lease = true
  }
  disk {
    volume_id    = "${libvirt_volume.postgres-infra-volume[count.index].id}"
  }
#  disk {
#    volume_id    = "${libvirt_volume.postgres-infra-data-volume[count.index].id}"
#  }
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
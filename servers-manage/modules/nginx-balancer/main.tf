data "template_file" "user_data_nginx-balancer" {
  template       = file("./modules/nginx-balancer/cloud-init/nginx/user-data.yml")
}

resource "libvirt_cloudinit_disk" "cloudinit_nginx-balancer" {
  count          = var.nginx_counter
  name           = "${var.env}-nginx-balancer${count.index}.iso"
  user_data      =  data.template_file.user_data_nginx-balancer.rendered
  pool           = "default"
}

resource "libvirt_volume" "nginx-balancer-volume" {
  count          = var.nginx_counter
  name           = "${var.env}-nginx-balancer${count.index}-volume"
  pool           = "default"
  source         = "/pools/lib/Companyint-redos7.qcow2"
  format         = "qcow2"
}

resource "libvirt_domain" "nginx-balancer" {
  count          = var.nginx_counter
  name           = "${var.env}-nginx-balancer${count.index}"
  memory         = "2048"
  vcpu           = 1

  cloudinit      = libvirt_cloudinit_disk.cloudinit_nginx-balancer[count.index].id

  network_interface {
    network_id   = var.backend_network_id
    hostname     = "${var.env}-nginx-balancer${count.index}"
    addresses    = [local.nginx_balancer_ips[var.env]]
    wait_for_lease = true
  }

  disk {
    volume_id    = "${libvirt_volume.nginx-balancer-volume[count.index].id}"
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


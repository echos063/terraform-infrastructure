data "template_file" "user_data_opensearch-node" {
  template       = file("./modules/opensearch-cluster/cloud-init/opensearch-node/user-data.yml")
}
data "template_file" "user_data_opensearch-dashboard" {
  template       = file("./modules/opensearch-cluster/cloud-init/opensearch-dashboard/user-data.yml")
}

resource "libvirt_cloudinit_disk" "cloudinit_opensearch-node" {
  count          = var.opensearch_counter
  name           = "${var.env}-opensearch-node${count.index}.iso"
  user_data      =  data.template_file.user_data_opensearch-node.rendered
  pool           = "default"
}
resource "libvirt_cloudinit_disk" "cloudinit_opensearch-dashboard" {
  count          = var.opensearch_dashboard_counter
  name           = "${var.env}-opensearch-dashboard${count.index}.iso"
  user_data      =  data.template_file.user_data_opensearch-dashboard.rendered
  pool           = "default"
}

resource "libvirt_volume" "opensearch-node-volume" {
  count          = var.opensearch_counter
  name           = "${var.env}-opensearch-node${count.index}-volume"
  pool           = "default"
  source         = "/pools/lib/Companyint-redos7.qcow2"
  format         = "qcow2"
}
resource "libvirt_volume" "opensearch-dashboard-volume" {
  count          = var.opensearch_dashboard_counter
  name           = "${var.env}-opensearch-dashboard${count.index}-volume"
  pool           = "default"
  source         = "/pools/lib/Companyint-redos7.qcow2"
  format         = "qcow2"
}

resource "libvirt_domain" "opensearch-node" {
  count          = var.opensearch_counter
  name           = "${var.env}-opensearch-node${count.index}"
  memory         = "2048"
  vcpu           = 1

  cloudinit      = libvirt_cloudinit_disk.cloudinit_opensearch-node[count.index].id

  network_interface {
    network_id   = var.backend_network_id
    hostname     = "${var.env}-opensearch-node${count.index}"
    addresses    = [local.opensearch-node_ips[var.env][count.index]]
    mac          = local.opensearch-node_macs[var.env][count.index]
    wait_for_lease = true
  }

  disk {
    volume_id    = "${libvirt_volume.opensearch-node-volume[count.index].id}"
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

resource "libvirt_domain" "opensearch-dashboard" {
  count          = var.opensearch_dashboard_counter
  name           = "${var.env}-opensearch-dashboard${count.index}"
  memory         = "2048"
  vcpu           = 1

  cloudinit      = libvirt_cloudinit_disk.cloudinit_opensearch-dashboard[count.index].id

  network_interface {
    network_id   = var.backend_network_id
    hostname     = "${var.env}-opensearch-dashboard${count.index}"
    addresses    = [local.opensearch-dashboard_ips[var.env]]
    mac          = local.opensearch-dashboard_macs[var.env]
    wait_for_lease = true
  }

  disk {
    volume_id    = "${libvirt_volume.opensearch-dashboard-volume[count.index].id}"
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

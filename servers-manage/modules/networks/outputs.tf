output "backend_network_id" {
  value = libvirt_network.backend_projectname_infra_network.id
}

output "dmz_network_id" {
  value = libvirt_network.dmz_projectname_infra_network.id
}

output "backend_network_address" {
  value = libvirt_network.backend_projectname_infra_network.addresses[0]
}

output "dmz_network_address" {
  value = libvirt_network.dmz_projectname_infra_network.addresses[0]
}
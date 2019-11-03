

output "network_id" {
  value = data.openstack_networking_network_v2.default.id
}

output "port_id" {
  value = openstack_networking_port_v2.default.id
}

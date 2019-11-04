output "port_id" {
  description = "Port ID"
  value = openstack_networking_port_v2.default.id
}

output "port_name" {
  description = "Port name"
  value = openstack_networking_port_v2.default.name
}

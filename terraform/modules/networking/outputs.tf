
output "cidr" {
  description = "CIDR used for network subnet"
  value = var.cidr
}

output "subnet_id" {
  description = "Subnet id"
  value = openstack_networking_subnet_v2.private_subnet.id
}

output "network_id" {
  description = "Network ID of private network"
  value = openstack_networking_network_v2.private_network.id
}

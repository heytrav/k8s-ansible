output "public_ip_address" {
  description = "Public IP address of bastion server"
  value = openstack_networking_floatingip_v2.public_ip.address
}

output "user_public_key_path" {
  value = file(var.user_public_key_path)
}
output "public_key" {
  value = var.public_key_openssh
}

output "user_data" {
  value = openstack_compute_instance_v2.default.user_data
}

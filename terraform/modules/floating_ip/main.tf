
resource "openstack_networking_floatingip_v2" "default" {
  pool = var.public_ip_pool
}
resource "openstack_networking_floatingip_associate_v2" "default" {
  floating_ip = openstack_networking_floatingip_v2.default.address
  port_id = var.port_id
}

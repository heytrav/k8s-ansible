

resource "openstack_networking_port_v2" "default" {
  name = var.name
  network_id = var.network_id
  admin_state_up = true
}

resource "openstack_networking_port_secgroup_associate_v2" "default" {
  port_id = openstack_networking_port_v2.default.id
  security_group_ids = var.security_groups
}

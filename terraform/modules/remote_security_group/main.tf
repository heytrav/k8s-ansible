

resource "openstack_networking_secgroup_v2" "default" {
  name = var.name
  description = "${var.description} (managed by Terraform)"
  delete_default_rules = true
}

resource "openstack_networking_secgroup_rule_v2" "default" {
  count = length(var.remote_security_groups)
  direction = "ingress"
  ethertype = "IPv4"
  protocol = "tcp"
  port_range_min = var.port
  port_range_max = var.port
  remote_group_id = element(var.remote_security_groups, count.index)
  security_group_id = openstack_networking_secgroup_v2.default.id
}

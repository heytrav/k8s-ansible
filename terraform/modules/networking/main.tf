
locals {
  network_name = "${var.prefix}-net"
  subnet_name = "${var.prefix}-subnet"
  router_name = "${var.prefix}-router"
}

data "openstack_networking_network_v2" "public_network" {
  name = var.public_network
}

resource "openstack_networking_network_v2" "private_network" {
  name = local.network_name
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "private_subnet" {
  name = local.subnet_name
  cidr = var.cidr
  network_id = openstack_networking_network_v2.private_network.id
}

resource "openstack_networking_router_v2" "default" {
  name = local.router_name
  admin_state_up = true
  external_network_id = data.openstack_networking_network_v2.public_network.id
}

resource "openstack_networking_router_interface_v2" "default" {
  router_id = openstack_networking_router_v2.default.id
  subnet_id = openstack_networking_subnet_v2.private_subnet.id
}

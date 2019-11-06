data "openstack_images_image_v2" "default" {
  name = var.base_image
  most_recent = true
}
data "openstack_networking_network_v2" "public" {
  name = "public-net"
}

data "openstack_networking_network_v2" "default" {
  network_id = var.k8s_network_id
}

module "office_ssh_access" {
  name = "${var.prefix}-bastion-ssh"
  source = "../../modules/ip_security_group"
  description = "SSH access from Catalyst office"
  remote_ip_prefixes = var.ssh_prefixes
  port = 22
}


resource "openstack_networking_port_v2" "default" {
  name = "${var.prefix}-bastion"
  network_id = var.k8s_network_id
  admin_state_up = true
}


resource "openstack_networking_port_secgroup_associate_v2" "default" {
  port_id = openstack_networking_port_v2.default.id
  security_group_ids = [module.office_ssh_access.id]
}

resource "openstack_networking_floatingip_v2" "public_ip" {
  pool = "public-net"
}

#resource "openstack_networking_router_v2" "default" {
  #name = "${var.prefix}-router"
  #external_network_id = data.openstack_networking_network_v2.public.id
  #admin_state_up = true
#}

#resource "openstack_networking_router_interface_v2" "default" {
  ##port_id = openstack_networking_port_v2.default.id
  #router_id = openstack_networking_router_v2.default.id
  #subnet_id = data.openstack_networking_subnet_v2.default.id
#}
resource "openstack_networking_floatingip_associate_v2" "default" {
  floating_ip = openstack_networking_floatingip_v2.public_ip.address
  port_id = openstack_networking_port_v2.default.id
}

resource "openstack_compute_instance_v2" "default" {
  name = "${var.prefix}-bastion"
  key_pair = var.key_pair
  flavor_name = var.flavor
  image_id = data.openstack_images_image_v2.default.id
  network {
    port = openstack_networking_port_v2.default.id
  }

  metadata = {
    "function" = "k8s_bastion"
    "training_machine" = var.prefix
  }
  user_data = templatefile(var.cloud_init_template, {user_public_key = "${file("${var.user_public_key_path}")}", generated_public_key = var.public_key_openssh})

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello World'"
    ]
    connection {
      type = "ssh"
      host = openstack_networking_floatingip_v2.public_ip.address
      user = var.ssh_user
      private_key = var.private_key_pem
    }
  }
}

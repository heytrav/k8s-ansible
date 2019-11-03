data "openstack_compute_keypair_v2" "default" {
  name = var.key_pair_name
}


data "openstack_images_image_v2" "default" {
  name = var.base_image
  most_recent = true
}

module "office_ssh_access" {
  name = "bastion-ssh-access"
  source = "../../modules/security_group"
  description = "SSH access from Catalyst office"
  remote_ip_prefixes = var.catalyst_ssh_prefixes
  port = 22
}

module "floating_ip" {
  source = "../../modules/floating_ip"
  port_id = openstack_networking_port_v2.default.id
  
}
data "openstack_networking_network_v2" "default" {
  network_id = var.private_network_id
}

resource "openstack_networking_port_v2" "default" {
  name = "k8s-bastion-port"
  network_id = var.private_network_id
  admin_state_up = true
}

resource "openstack_networking_port_secgroup_associate_v2" "default" {
 port_id = openstack_networking_port_v2.default.id
 security_group_ids =  [module.office_ssh_access.id]
}


resource "openstack_compute_instance_v2" "default" {
  name = var.instance_name
  key_pair = var.key_pair_name
  flavor_name = var.flavor
  image_id = data.openstack_images_image_v2.default.id
  network {
    port = openstack_networking_port_v2.default.id
  }

  metadata = var.instance_metadata
  user_data = templatefile(var.cloud_init_template_path, {generated_public_key = tls_private_key.default.public_key_openssh})

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello World'"
    ]
    connection {
      type = "ssh"
      host = module.floating_ip.address
      user = var.ssh_user
      private_key = tls_private_key.default.private_key_pem
    }
  }
}

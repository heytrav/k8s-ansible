data "openstack_images_image_v2" "default" {
  name = var.base_image
  most_recent = true
}

module "office_ssh_access" {
  name = "${var.prefix}-bastion-ssh"
  source = "../../modules/ip_security_group"
  description = "SSH access from Catalyst office"
  remote_ip_prefixes = var.ssh_prefixes
  port = 22
}

data "openstack_networking_network_v2" "default" {
  network_id = var.k8s_network_id
}
module "port" {
  source = "../network_port"
  name = "${var.prefix}-rancher"
  network_id = openstack_networking_network_v2.default.id
  security_groups = [module.office_ssh_access.id]
}

module "floating_ip" {
  source = "../../modules/floating_ip"
  port_id = module.port.port_id
}


resource "openstack_compute_instance_v2" "default" {
  name = "${var.prefix}-bastion"
  key_pair = var.key_pair
  flavor_name = var.flavor
  image_id = data.openstack_images_image_v2.default.id
  network {
    port = module.port.port_id
  }

  metadata = {
    "function" = "k8s_bastion"
    "training_machine" = var.prefix

  }
  user_data = templatefile(var.cloud_init_template_path, {generated_public_key = var.public_key_openssh})

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello World'"
    ]
    connection {
      type = "ssh"
      host = module.floating_ip.address
      user = var.ssh_user
      private_key = var.private_key_pem
    }
  }
}

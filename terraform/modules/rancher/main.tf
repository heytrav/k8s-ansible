
module "office_ssh_access" {
  source = "../ip_security_group"
  name = "${var.prefix}-rancher-ssh"
  description = "SSH access from Catalyst office"
  remote_ip_prefixes = var.ssh_prefixes
  port = 22
}

module "http_access" {
  source = "../ip_security_group"
  name = "${var.prefix}-rancher-http"
  description = "HTTPS access security groups"
  remote_ip_prefixes = var.remote_https_ip_prefixes
  port = 443
}

module "rancher_network" {
 source = "../networking"
 prefix = "${var.prefix}-rancher"
}

data "openstack_images_image_v2" "rancher_image" {
  name = var.base_image
  most_recent = true
}


resource "openstack_networking_port_v2" "default" {
  name = "${var.prefix}-rancher"
  network_id = module.rancher_network.network_id
  admin_state_up = true
  fixed_ip {
    subnet_id = module.rancher_network.subnet_id
  }
}

resource "openstack_networking_port_secgroup_associate_v2" "default" {
  port_id = openstack_networking_port_v2.default.id
  security_group_ids = [module.office_ssh_access.id, module.http_access.id]
}

module "floating_ip" {
  source = "../floating_ip"
  port_id = openstack_networking_port_v2.default.id
  public_ip_pool = "public-net"
}


resource "openstack_compute_instance_v2" "rancher" {
  name = "${var.prefix}-rancher"
  key_pair = var.key_pair
  flavor_name = var.flavor
  image_id = data.openstack_images_image_v2.rancher_image.id
  network  {
    port = openstack_networking_port_v2.default.id
  }

  metadata = {
    "function" = "dashboard"
    "training_machine" = var.prefix
  }
  user_data = templatefile(var.cloud_init_template, {user_public_key = file(var.user_public_key_path), generated_public_key = var.public_key_openssh})


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
  provisioner "local-exec" {
    environment = {
      "ANSIBLE_CONFIG" = "${var.base_dir}/${var.ansible_config}"
      "VIRTUAL_ENV" = "${var.base_dir}/${var.virtual_env}"
      "PREFIX" = var.prefix
    }
    command = "cd ${var.base_dir} && ansible-playbook ansible/rancher/start-rancher.yml"
  }
}


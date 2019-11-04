
locals {
  ssh_security_group = "${var.prefix}-rancher-ssh"
  http_security_group = "${var.prefix}-rancher-http"
}

module "office_ssh_access" {
  source = "../ip_security_group"
  name = local.ssh_security_group
  description = "SSH access from Catalyst office"
  remote_ip_prefixes = var.ssh_prefixes
  port = 22
}

module "http_access" {
  source = "../ip_security_group"
  name = local.http_security_group
  description = "HTTPS access security groups"
  remote_ip_prefixes = var.remote_https_ip_prefixes
  port = 443
}

module "rancher_network" {
 source = "../networking"
 prefix = var.prefix
 security_groups = [module.office_ssh_access.id, module.http_access.id]
}

data "openstack_images_image_v2" "rancher_image" {
  name = var.base_image
  most_recent = true
}


module "port" {
  source = "../network_port"
  name = "${var.prefix}-rancher"
  network_id = module.rancher_network.network_id
  security_groups = [module.office_ssh_access.id, module.http_access.id]
}

module "floating_ip" {
  source = "../floating_ip"
  port_id = module.port.port_id
}


resource "openstack_compute_instance_v2" "rancher" {

  count = 1
  name = "${var.prefix}-rancher"
  key_pair = var.key_pair
  flavor_name = var.flavor
  image_id = data.openstack_images_image_v2.rancher_image.id
  network  {
    port = module.port.port_id
  }

  metadata = {
    "function" = "dashboard"
    "training_machine" = var.prefix
  }
  user_data = templatefile(var.cloud_init_template, {generated_public_key = var.public_key_openssh})


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
    }
    command = "cd ${var.base_dir} && ansible-playbook ansible/rancher/start-server.yml"
  }
}


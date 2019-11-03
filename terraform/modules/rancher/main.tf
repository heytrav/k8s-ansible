

module "office_ssh_access" {
  name = "rancher-ssh"
  source = "../security_group"
  description = "SSH access from Catalyst office"
  remote_ip_prefixes = var.remote_ssh_ip_prefixes
  port = 22
}

module "http_access" {
  name = "rancher-http"
  source = "../security_group"
  description = "HTTPS access"
  remote_ip_prefixes = var.remote_https_ip_prefixes
  port = 443
}

module "rancher_network" {
 source = "../networking"
 private_network = var.private_network
 port_name = "rancher_port"
 security_groups = [module.office_ssh_access.id, module.http_access.id]
}

data "openstack_images_image_v2" "rancher_image" {
  name = var.base_image
  most_recent = true
}

module "floating_ip" {
  source = "../floating_ip"
  port_id = module.rancher_network.port_id
  address = var.public_ip_address
}

resource "openstack_compute_instance_v2" "rancher" {
  
  count = 1
  name = var.rancher_instance_name
  key_pair = var.builder_tls_key.name
  flavor_name = var.rancher_flavor
  image_id = data.openstack_images_image_v2.rancher_image.id
  network  {
    port = module.rancher_network.port_id
  }
  
  metadata = {
    "function" = "dashboard"
  }
  user_data = templatefile(var.cloud_init_template_path, {generated_public_key = var.builder_tls_key.public_ssh_key})


  provisioner "remote-exec" {
    inline = [
      "echo 'Hello World'"
    ]
    connection {
      type = "ssh"
      host = module.floating_ip.address
      user = var.ssh_user
      private_key = var.builder_tls_key.private_ssh_key_pem
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


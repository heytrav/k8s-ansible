
provider "openstack" {
  cloud = var.cloud_name
}

locals {
  key_pair = "${var.prefix}-key"
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits = 4096
}

module "bastion" {
  source = "./modules/bastion"
  ssh_prefixes = var.ssh_prefixes
  key_pair = local.key_pair
  prefix = "${var.prefix}-bastion"
  k8s_network_id = var.k8s_network_id
  cloud_init_template = var.cloud_init_template
  public_key_openssh = tls_private_key.default.public_key_openssh
  private_key_pem = tls_private_key.default.private_key_pem
}

module "rancher" {
  source = "./modules/rancher"
  ssh_prefixes = var.ssh_prefixes
  key_pair = local.key_pair
  prefix = "${var.prefix}-rancher"
  cloud_init_template = var.cloud_init_template
  public_key_openssh = tls_private_key.default.public_key_openssh
  private_key_pem = tls_private_key.default.private_key_pem
}


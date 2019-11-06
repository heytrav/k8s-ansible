
provider "openstack" {
  cloud = var.cloud_name
}

resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "openstack_compute_keypair_v2" "default" {
  name = "${var.prefix}-key"
  public_key = tls_private_key.default.public_key_openssh
}

#module "bastion" {
  #source = "./modules/bastion"
  #ssh_prefixes = var.ssh_prefixes
  #key_pair = openstack_compute_keypair_v2.default.name
  #prefix = var.prefix
  #k8s_network_id = var.k8s_network_id
  #cloud_init_template = var.cloud_init_template
  #public_key_openssh = tls_private_key.default.public_key_openssh
  #private_key_pem = tls_private_key.default.private_key_pem
  #user_public_key_path = var.user_public_key_path
#}

module "rancher" {
  source = "./modules/rancher"
  ssh_prefixes = var.ssh_prefixes
  key_pair = "${var.prefix}-key"
  prefix = var.prefix
  cloud_init_template = var.cloud_init_template
  public_key_openssh = tls_private_key.default.public_key_openssh
  private_key_pem = tls_private_key.default.private_key_pem
  base_dir = var.base_dir
  ansible_config = var.ansible_config
  virtual_env = var.virtual_env
  user_public_key_path = var.user_public_key_path
}


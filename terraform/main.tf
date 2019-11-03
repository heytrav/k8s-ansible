
provider "openstack" {
  cloud = var.cloud_name
  
}
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits = 4096
}

module "bastion" {
  source = "./modules/bastion"
  ssh_prefixes = var.ssh_prefixes
  prefix = var.prefix
  k8s_network_id = var.k8s_network_id

  

}



provider "openstack" {
  cloud = var.cloud_name
  
}
resource "tls_private_key" "default" {
  algorithm = "RSA"
  rsa_bits = 4096
}

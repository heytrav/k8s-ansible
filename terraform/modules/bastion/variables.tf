variable "instance_name" {
  default = "pact-k8s-bastion"
  type = string
  description = "Name of bastion instance"
}
variable "base_image" {
  default = "ubuntu-18.04-x86_64"
}
variable "ssh_user" {
  default = "ubuntu"
}
variable "flavor" {
  default = "c1.c1r1"
}
variable "key_pair_name" {
 default = "pact-terraform-key" 
}
variable "ssh_prefixes" {
  type = "list"
}
variable "instance_metadata" {
  type = map
  default = {
    function = "k8s_bastion"
  }
}

# Must specify the private network for the bastion host
variable "private_network_id" {
  type = "string"
}

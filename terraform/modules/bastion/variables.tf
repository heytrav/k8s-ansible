variable "prefix" {
  description = "Environment or machine specific prefix for all machines"
  type = string
}
variable "base_image" {
  default = "ubuntu-18.04-x86_64"
}
variable "ssh_user" {
  default = "ubuntu"
}
variable "user_public_key_path" {
  type = string
  description = "Path to user's ssh public key" 
}
variable "key_pair" {
  type = string
  description = "Name of key pair"
}

variable "public_key_openssh" {
  type = string
  description = "Public SSH key"
}

variable "private_key_pem" {
  type = string
  description = "Private key"
}

variable "flavor" {
  default = "c1.c1r1"
}
variable "ssh_prefixes" {
  description = "List of IP ranges"
  type = "list"
}

# Must specify the private network for the bastion host
variable "k8s_network_id" {
  description = "Private network of Kubernetes cluster"
  type = "string"
}
variable "cloud_init_template" {
  type = string
  description = "Path to cloud init template"
}

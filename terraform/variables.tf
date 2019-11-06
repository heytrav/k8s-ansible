variable "cloud_name" {
  default = "docker-training"
}

variable "user_public_key_path" {
  type = string
 description = "Path to user's ssh public key" 
  default = "~/.ssh/id_rsa.pub"
}

variable "user_private_key_path" {
  description = "Path to private SSH key"
  default = "~/.ssh/id_rsa"
}
variable "prefix" {
  type = string
}
variable "key_pair" {
  description = "Key for openstack"
  type = string
  default = "training-key"
}

variable "ssh_prefixes" {
  type = list
  description = "List of CIDR addresses for SSH access"
  default = [
    "202.78.240.7/32",
    "202.6.117.189/32",
    "114.110.38.54/32",
    "121.75.249.106/32" # my home IP
  ]
}

variable "k8s_network_id" {
  description = "Network ID of Kubernetes cluster to join bastion"
  type = string 
}
variable "base_dir" {
  description = "Base directory of project to run Ansible code from"
  type = string
  default = "../.."
}
variable "ansible_config" {
  description = "Configuration file for Ansible"
  type = string
  default = "ansible.cfg"
}
variable "virtual_env" {
  type = string
  description = "Python virtual environment with ansible installed"
  default = "venv"
}
variable "cloud_init_template" {
  default = "./cloud_init.tmpl" 
}

variable "cloud_name" {
  default = "docker-training"
}

variable "prefix" {
  type = string
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
}
variable "ansible_config" {
  description = "Configuration file for Ansible"
  type = string
}
variable "virtual_env" {
  type = string
}

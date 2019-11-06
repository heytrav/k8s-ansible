
variable "prefix" {
  type = string
  description = "Prefix to put on front of instances"
}
variable "ssh_user" {
  description = "User that will log into box"
  default = "core"
}

variable "key_pair" {
  type = string
  description = "Name of key pair"
}

variable "user_public_key_path" {
  type = string
  description = "Path to user's ssh public key" 
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

variable "base_image" {
  default = "coreos-stable-x86_64"
}

variable "ssh_prefixes" {
  type = list
}
variable "cloud_init_template" {
  type = string
  description = "Path to cloud init template"
}

variable "remote_https_ip_prefixes" {
  type = list
  default = ["0.0.0.0/0"]
}

variable "rancher_instance_name" {
  type = string
  default = "pact-rancher-dashboard"
}

variable "base_dir" {
  type = string
  description  = "Base directory of project"
}

variable "ansible_config" {
  type = string
  description = "Ansible config file"
}

variable "virtual_env" {
  type = string
  description = "Python virtual environment with Ansible installed"
}

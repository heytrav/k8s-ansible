
variable "ssh_user" {
  default = "core"
}

variable "rancher_flavor" {
  default = "c1.c1r1"
}


variable "private_network" {
  type = string
}

variable "base_image" {
  default = "coreos-stable-x86_64"
}

variable "remote_ssh_ip_prefixes" {
  type = list
}

variable "remote_https_ip_prefixes" {
  type = list
  default = ["0.0.0.0/0"]
}

variable "rancher_instance_name" {
  type = string
  default = "pact-rancher-dashboard"
}

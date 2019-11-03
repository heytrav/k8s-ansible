variable "cloud_name" {
  default = "docker-training"
}

variable "prefix" {
  type = string
}

variable "ssh_prefixes" {
  type = list
  default = ["202.78.240.7/32", "121.75.249.106/32"]
}

variable "k8s_cluster_network_id" {
 type = string 
}
variable "base_dir" {
  type = string
}
variable "ansible_config" {
  type = string
}
variable "virtual_env" {
  type = string
}


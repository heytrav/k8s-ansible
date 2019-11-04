variable "name" {
 type = string
 description = "Name of port"
}

variable "network_id" {
 type = string
 description = "Network ID to attach port"
}

variable "security_groups" {
 type = list
 description = "Set of security groups to attach port"
}

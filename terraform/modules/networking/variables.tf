variable "public_network" {
  type = string
  description = "Public IP pool of tenant"
  default = "public-net"
}
variable "prefix" {
  type = string
  description = "Environment specific prefix for instances and network objects."
}
variable "cidr" {
 type = string
 description = "Network range for subnet"
 default = "192.168.0.0/24"
}



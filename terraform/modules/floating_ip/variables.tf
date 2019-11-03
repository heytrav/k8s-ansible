variable "port_id" {
 type = string 
}

variable "public_ip_pool" {
 type = string 
 default = "public-net"
}

variable "address" {
  type = string
  default = null
}

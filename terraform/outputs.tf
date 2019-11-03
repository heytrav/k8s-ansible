output "bastion_public_ip_address" {
  description = "Public IP address of bastion server"
  
}

output "rancher_public_ip_address" {
  description = "Public IP address of Rancher dashboard"
  value = module.rancher.public_ip_address
}

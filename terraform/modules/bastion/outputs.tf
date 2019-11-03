output "public_ip_address" {
  description = "Public IP address of bastion server"
  value = module.floating_ip.address
}

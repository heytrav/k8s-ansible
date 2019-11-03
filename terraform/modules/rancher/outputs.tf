output "public_ip_address" {
  description = "Floating IP of Rancher dashboard"
  value = module.floating_ip.address
}

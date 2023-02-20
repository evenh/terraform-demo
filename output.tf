# Dette vil bli skrevet til terminalen ved kjøring.
# Kan også hentes ut programmatisk om ønskelig.
output "lb" {
  value = {
    url         = "https://${digitalocean_record.www.fqdn}"
    ip          = module.loadbalancer.ip
    cert_expiry = module.loadbalancer.cert_expiry
  }
}

output "instances" {
  value = module.vm.public_ips
}

output "urn" {
  value = digitalocean_loadbalancer.default.urn
}

output "ip" {
  value = digitalocean_loadbalancer.default.ip
}

output "cert_expiry" {
  value = digitalocean_certificate.default.not_after
}

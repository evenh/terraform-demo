output "urns" {
  value = digitalocean_droplet.default[*].urn
}

output "ids" {
  value = digitalocean_droplet.default[*].id
}

output "public_ips" {
  value = {for i in digitalocean_droplet.default : i.name => i.ipv4_address}
}

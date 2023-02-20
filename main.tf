locals {
  // mitt-navn.domene.no
  tls_fqdn = "${var.name}.${var.dns_domain}"
}

// Lag et nettverk som VM'ene + lastbalanserer skal inn i
resource "digitalocean_vpc" "default" {
  name     = var.name
  region   = var.region
  ip_range = cidrsubnet(var.network_space, 8, 99)
}

// En SSH-nøkkel som skal brukes for å koble til som root på VM'ene (aldri eksponer root i det virkelige liv)
resource "digitalocean_ssh_key" "default" {
  name       = "${var.name}-admin"
  public_key = file("${path.module}/files/sample_key.pub")
}

// Provisjoner VM'er med en standardoppsett (webapp)
module "vm" {
  source = "./modules/vm"

  instances   = var.vm_count
  name_prefix = var.name
  region      = var.region
  vpc_id      = digitalocean_vpc.default.id
  ssh_keys    = [digitalocean_ssh_key.default.id]
}

// Begrens trafikk
module "firewall" {
  source = "./modules/firewall"
  name   = var.name
  vm_ids = module.vm.ids
  rules  = file("${path.module}/files/fw_rules.csv")
}

// Balanser inkommende trafikk med TLS-terminering
module "loadbalancer" {
  source   = "./modules/lb"
  name     = var.name
  region   = var.region
  vm_ids   = module.vm.ids
  vpc_id   = digitalocean_vpc.default.id
  tls_fqdn = local.tls_fqdn
}

// DNS
data "digitalocean_domain" "default" {
  name = var.dns_domain
}

// Lag en DNS A record for kv-demo.evenh.net som peker på LB
resource "digitalocean_record" "www" {
  domain = data.digitalocean_domain.default.id
  type   = "A"
  ttl    = 30
  name   = var.name
  value  = module.loadbalancer.ip
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "${var.name}@terraform.example.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem       = acme_registration.reg.account_key_pem
  common_name           = var.tls_fqdn
  recursive_nameservers = [
    "8.8.8.8:53", // Google DNS primary
    "8.8.4.4:53", // Google DNS secondary
    "1.1.1.1:53", // Cloudflare primary
    "1.0.0.1:53", // Cloudflare secondary
  ]

  dns_challenge {
    provider = "digitalocean"
    config   = {
      DO_POLLING_INTERVAL    = 10
      DO_PROPAGATION_TIMEOUT = 60 * 3
    }
  }
}

resource "digitalocean_certificate" "default" {
  name              = var.name
  private_key       = acme_certificate.certificate.private_key_pem
  certificate_chain = acme_certificate.certificate.issuer_pem
  leaf_certificate  = acme_certificate.certificate.certificate_pem
}

resource "digitalocean_loadbalancer" "default" {
  name                             = var.name
  region                           = var.region
  size                             = var.lb_size
  vpc_uuid                         = var.vpc_id
  algorithm                        = "round_robin"
  redirect_http_to_https           = true
  disable_lets_encrypt_dns_records = true // skrus av for demo, ønsker å håndtere det selv

  droplet_ids = var.vm_ids

  forwarding_rule {
    entry_port      = 443
    entry_protocol  = "https"
    target_port     = 8080
    target_protocol = "http"

    certificate_name = digitalocean_certificate.default.name
  }

  sticky_sessions {
    type = "none"
  }

  healthcheck {
    port     = 8080
    protocol = "http"
    path     = "/"
  }
}

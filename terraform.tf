# En slik blokk finnes i alle Terraform-prosjekter
terraform {
  # Hvilken versjon er vi kompatible med
  required_version = ">= 1.3.9"

  # TODO: I et virkelig scenario ville man ha lagret state eksternt (versjonert, konfidensielt, kryptert)
  # (se "backend" blokk-konfigurasjon og tilbydere her: https://developer.hashicorp.com/terraform/language/settings/backends/s3)

  # Hvilke providere/plugins har vi
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.26.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }
}

# Bruk Let's Encrypt som utsteder av certs
provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

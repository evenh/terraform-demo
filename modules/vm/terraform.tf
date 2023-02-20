terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.26.0"
    }
    cloudinit = {
      source = "hashicorp/cloudinit"
      version = "2.2.0"
    }
  }
}

# Alle inputvariabler vi trenger for å kunne provisjonere ressurser
variable "dns_domain" {
  type        = string
  description = "The domain to host subdomains under"
}

variable "name" {
  type        = string
  description = "Name for this project and associated resources"
}

variable "region" {
  type        = string
  description = "Where to run the resources"
}

variable "vm_count" {
  type = number
}

variable "network_space" {
  type        = string
  description = "CIDR for main network"
}

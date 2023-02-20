variable "name" {
  type        = string
  description = "Firewall name"
}

variable "region" {
  type        = string
  description = "Where should VMs live?"
}

variable "vm_ids" {
  type        = set(string)
  description = "VMs to put behind firewall"
}

variable "lb_size" {
  type        = string
  description = "How much capacity shall the LB have? See DO docs"
  default     = "lb-small"
}

variable "vpc_id" {
  type        = string
  description = "The network to place VMs in"
}

variable "tls_fqdn" {
  type        = string
  description = "Hostname to request certs for"
}

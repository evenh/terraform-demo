variable "name" {
  type = string
  description = "Firewall name"
}

variable "vm_ids" {
  type = set(string)
  description = "VMs to put behind firewall"
}

variable "rules" {
  type = string
  description = "CSV encoded firewall rules"
}

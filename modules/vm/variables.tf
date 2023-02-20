variable "name_prefix" {
  type = string
  description = "Name prefix to use for VMs"
}

variable "sku" {
  type = string
  description = "VM SKU"
  default = "s-1vcpu-1gb"
}

variable "instances" {
  type = number
  description = "Number of VM's to provision"
}

variable "image" {
  type = string
  description = "What image should the VMs run?"
  default = "ubuntu-22-04-x64"
}

variable "region" {
  type = string
  description = "Where should VMs live?"
}

variable "vpc_id" {
  type = string
  description = "The network to place VMs in"
}

variable "ssh_keys" {
  type = set(string)
  description = "A set of pre-provisioned SSH key references"
}

locals {
  parsed_rules = csvdecode(var.rules)
  inbound_rules = { for k, v in local.parsed_rules :  k => v if v.direction == "in" }
  outbound_rules = { for k, v in local.parsed_rules :  k => v if v.direction == "out" }
}

resource "digitalocean_firewall" "default" {
  name        = var.name
  droplet_ids = var.vm_ids

  dynamic "inbound_rule" {
    for_each = local.inbound_rules
    content {
      protocol = inbound_rule.value.protocol
      port_range = inbound_rule.value.port
      source_addresses = split(";", inbound_rule.value.peer)
    }
  }

  dynamic "outbound_rule" {
    for_each = local.outbound_rules
    content {
      protocol = outbound_rule.value.protocol
      port_range = outbound_rule.value.port
      destination_addresses = split(";", outbound_rule.value.peer)
    }
  }
}

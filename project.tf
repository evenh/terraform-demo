// Logisk gruppering av ressurser
resource "digitalocean_project" "default" {
  name        = var.name
  purpose     = "Testing Terraform"
  environment = "Development"
  is_default  = false
}

// Grupper ressurser inn i prosjektet.
// NB: VPC kan ikke grupperes
resource "digitalocean_project_resources" "default" {
  project   = digitalocean_project.default.id
  resources = concat(
    module.vm.urns, // allerede en liste
    [
      module.loadbalancer.urn
    ]) // concat for å legge til flere elementer for hånd
}

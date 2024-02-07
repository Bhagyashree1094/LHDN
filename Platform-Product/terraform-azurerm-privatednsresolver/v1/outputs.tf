#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------------------
# - OUTPUTS Azure DNS resolver
#----------------------------


output "id" {
  value = azurerm_private_dns_resolver.this.id
}

output "location" {
  value = azurerm_private_dns_resolver.this.location
}

output "id_outbound" {
  value = azurerm_private_dns_resolver_outbound_endpoint.this.id
}

output "id_inbound" {
  value = azurerm_private_dns_resolver_inbound_endpoint.this.id
}

output "id_rule" {
  value = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
}

#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  description = "id of the DNZ zone."
  value       = azurerm_private_dns_zone.this.id
}
output "name" {
  description = "The DNS zone name."
  value       = azurerm_private_dns_zone.this.name
}
output "dns_zone_vnet_link_ids" {
  value       = [for d in azurerm_private_dns_zone_virtual_network_link.this : d.id]
  description = "Resource Id's of the Private DNS Zone Virtual Network Link."
}
output "dns_zone_vnet_link_ids_map" {
  value       = { for d in azurerm_private_dns_zone_virtual_network_link.this : d.name => d.id... }
  description = "Map of Resource Id's of the Private DNS Zone Virtual Network Link."
}

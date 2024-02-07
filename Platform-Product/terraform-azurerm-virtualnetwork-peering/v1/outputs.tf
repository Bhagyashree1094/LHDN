#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id_spoke" {
  value       = azurerm_virtual_network_peering.spoke_to_hub.id
  description = "The ID of the created Virtual Network peering on the SPOKE side."
}
output "id_hub" {
  value       = azurerm_virtual_network_peering.hub_to_spoke.id
  description = "The ID of the created Virtual Network peering on the HUB side."
}
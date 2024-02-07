#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------------------
# - OUTPUTS VIrtual Wan
#----------------------------

output "id" {
  value       = azurerm_virtual_wan.this.id
  description = "The Virtual network ID."
}

output "name" {
  value       = azurerm_virtual_wan.this.name
  description = "The Virtual network name."
}
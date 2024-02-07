#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "name" {
  description = "The generated name of the Network Security Group."
  value       = azurerm_network_security_group.this.name
}
output "id" {
  description = "The generated ID of the Network Security Group."
  value       = azurerm_network_security_group.this.id
}

#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  value       = azurerm_route_table.this.id
  description = "The Route Table ID."
}

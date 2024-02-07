#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  value       = azurerm_policy_set_definition.this.id
  description = "The ID of the Policy Set Definition."
}
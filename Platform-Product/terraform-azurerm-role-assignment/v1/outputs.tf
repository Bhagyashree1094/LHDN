#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#
output "id" {
  value       = azurerm_role_assignment.this.id
  description = "The Role Assignment ID."
}
output "principal_type" {
  value       = azurerm_role_assignment.this.principal_type
  description = "The `principal_id`'s type: e.g. `User`, `Group`, `Service Principal`, `Application`, `etc`."
}

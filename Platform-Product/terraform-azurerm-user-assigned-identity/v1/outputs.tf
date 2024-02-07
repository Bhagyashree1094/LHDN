#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  value       = azurerm_user_assigned_identity.this.id
  description = "The User Assigned Identity ID."
}

output "client_id" {
  value       = azurerm_user_assigned_identity.this.client_id
  description = "Client ID associated with the user assigned identity."
}

output "principal_id" {
  value       = azurerm_user_assigned_identity.this.principal_id
  description = "Service Principal ID associated with the user assigned identity."
}

output "tenant_id" {
  value       = azurerm_user_assigned_identity.this.tenant_id
  description = "Tenant ID associated with the user assigned identity."
} 
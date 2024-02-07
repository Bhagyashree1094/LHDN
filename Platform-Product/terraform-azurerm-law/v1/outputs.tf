#
# Copyright 2023 BBL  & Microsoft. All rights reserved.
#
output "id" {
  description = "The Resource ID of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "name" {
  description = "Specifies the name of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.name
}

output "primary_shared_key" {
  description = "The Primary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.primary_shared_key
  sensitive   = true
}

output "secondary_shared_key" {
  description = "The Secondary shared key for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.secondary_shared_key
  sensitive   = true
}

output "workspace_id" {
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "sku" {
  description = "The Sku of the Log Analytics Workspace."
  value       = azurerm_log_analytics_workspace.this.sku
}

output "retention_in_days" {
  description = "The workspace data retention in days."
  value       = azurerm_log_analytics_workspace.this.retention_in_days
}

output "daily_quota_gb" {
  description = "The workspace daily quota for ingestion in GB."
  value       = azurerm_log_analytics_workspace.this.daily_quota_gb
}

output "random_suffix" {
  value       = module.bbl_law_name.random_suffix
  description = "Randomized piece of the Log analytics workspace name when \"`add_random = true`\"."
}
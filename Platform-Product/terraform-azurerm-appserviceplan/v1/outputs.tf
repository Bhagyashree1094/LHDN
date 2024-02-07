#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  value       = azurerm_service_plan.this.id
  description = "The ID of the App Service Plan component."
}
output "name" {
  value       = azurerm_service_plan.this.name
  description = "The name of the App Service Plan component."
}
output "random_suffix" {
  value       = module.bbl_asp_name.random_suffix
  description = "Randomized piece of the ASP name when \"`add_random = true`\"."
}

output "maximum_number_of_workers" {
  value       = azurerm_service_plan.this.maximum_elastic_worker_count
  description = "The maximum number of workers supported with the App Service Plan's sku."
}
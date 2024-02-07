#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  value       = azurerm_container_registry.this.id
  description = "The Container Registry ID."
}

output "name" {
  value       = azurerm_container_registry.this.name
  description = "The Container Registry name."
}

output "login_server" {
  value       = azurerm_container_registry.this.login_server
  description = "The URL that can be used to log into the container registry."
}

# output "admin_username" {
#   description = "The Username associated with the Container Registry Admin account - if the admin account is enabled."
#   value       = azurerm_container_registry.this.admin_username
# }

# output "admin_password" {
#   description = "The Password associated with the Container Registry Admin account - if the admin account is enabled."
#   value       = azurerm_container_registry.this.admin_password
#   sensitive   = true
# }

output "random_suffix" {
  value       = module.bbl_acr_name.random_suffix
  description = "Randomized piece of the Azure Container Registry name when \"`add_random = true`\"."
}
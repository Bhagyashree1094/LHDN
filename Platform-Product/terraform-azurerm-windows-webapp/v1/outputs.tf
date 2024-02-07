#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "id" {
  value       = azurerm_windows_web_app.this.id
  description = "The ID of the Windows Web App."
}
output "name" {
  value       = azurerm_windows_web_app.this.name
  description = "The name of the Windows Web App."
}
output "module_name" {
  value = module.bbl_win_webapp_name.name
}
output "custom_domain_verification_id" {
  value       = azurerm_windows_web_app.this.custom_domain_verification_id
  description = "The identifier used by App Service to perform domain ownership verification via DNS TXT record."
}
output "default_hostname" {
  value       = azurerm_windows_web_app.this.default_hostname
  description = "The default hostname of the Windows Web App."
}
output "kind" {
  value       = azurerm_windows_web_app.this.kind
  description = "The Kind value for this Windows Web App."
}
output "outbound_ip_address_list" {
  value       = azurerm_windows_web_app.this.outbound_ip_address_list
  description = "A list of outbound IP addresses."
}
output "outbound_ip_addresses" {
  value       = azurerm_windows_web_app.this.outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12."
}
output "possible_outbound_ip_addresses" {
  value       = azurerm_windows_web_app.this.possible_outbound_ip_addresses
  description = "A comma separated list of outbound IP addresses - such as 52.23.25.3,52.143.43.12,52.143.43.17 - not all of which are necessarily in use. Superset of outbound_ip_addresses."
}
output "random_suffix" {
  value       = module.bbl_win_webapp_name.random_suffix
  description = "Randomized piece of the Windows WebApp name when \"`add_random = true`\"."
}
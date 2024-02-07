#
# Copyright 2023 lhdn & Microsoft. All rights reserved.
#
output "id" {
  value       = azurerm_key_vault.this.id
  description = "The ID of the Key Vault."
}

output "vault_uri" {
  value       = azurerm_key_vault.this.vault_uri
  description = "The URI of the Key Vault, used for performing operations on keys and secrets."
}

output "name" {
  value       = azurerm_key_vault.this.name
  description = "The Name of the Key Vault."
}
output "random_suffix" {
  value       = module.lhdn_kv_name.random_suffix
  description = "Randomized piece of the Keyvault name when \"`add_random = true`\"."
}

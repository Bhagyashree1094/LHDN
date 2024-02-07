output "this" {
  value = azurerm_cosmosdb_account.this.id
}

output "connection_string" {
  value = azurerm_cosmosdb_account.this.connection_strings[0]
}

output "primary_key" {
  value = azurerm_cosmosdb_account.this.primary_key
}

output "endpoint" {
  value = azurerm_cosmosdb_account.this.endpoint
}

output "resource_group_name" {
  value = azurerm_cosmosdb_account.this.resource_group_name
}

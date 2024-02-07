output "id" {
  value       = azurerm_windows_virtual_machine_scale_set.windowsvmss.id
  description = "The ID of the Windows Virtual Machine Scale Set."
}

output "name" {
  value       = azurerm_windows_virtual_machine_scale_set.windowsvmss.name
  description = "The name of the Windows Virtual Machine Scale Set."
}

output "unique_id" {
  value       = azurerm_windows_virtual_machine_scale_set.windowsvmss.unique_id
  description = "The Unique ID for this Windows Virtual Machine Scale Set."
}

output "id" {
  value       = azurerm_linux_virtual_machine_scale_set.this.id
  description = "The ID of the Linux Virtual Machine Scale Set."
}

output "name" {
  value       = azurerm_linux_virtual_machine_scale_set.this.name
  description = "The name of the Linux Virtual Machine Scale Set."
}

output "unique_id" {
  value       = azurerm_linux_virtual_machine_scale_set.this.unique_id
  description = "The Unique ID for this Linux Virtual Machine Scale Set."
}

output "virtual_machine_scaleset" {
  value       = azurerm_linux_virtual_machine_scale_set.this
  description = "The full object of the virtual machine scale set."
  sensitive   = true
}
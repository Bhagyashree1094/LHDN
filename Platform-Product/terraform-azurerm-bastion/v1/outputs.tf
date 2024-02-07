#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------------------
# - OUTPUTS Azure bastion
#----------------------------


output "id" {
  value       = azurerm_bastion_host.this.id
  description = "The ID of the created Azure Bastion."
}
output "subnet_id" {
  value       = azurerm_subnet.this.id
  description = "The ID of the subnet created for the Azure Bastion."
}
output "subnet_name" {
  value       = azurerm_subnet.this.name
  description = "The Name of the subnet created for the Azure Bastion."
}
output "ip_address" {
  value       = azurerm_public_ip.this.ip_address
  description = "Public IP of the Azure Bastion."
}

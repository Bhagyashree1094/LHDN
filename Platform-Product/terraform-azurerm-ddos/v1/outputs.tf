#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------------------
# - OUTPUTS DDSO plan ID
#----------------------------

output "id" {
  value       =  azurerm_network_ddos_protection_plan.this.id
  description = "The DDOS ID."
}

output "name" {
  value       = azurerm_network_ddos_protection_plan.this.name
  description = "DDOS name."
}

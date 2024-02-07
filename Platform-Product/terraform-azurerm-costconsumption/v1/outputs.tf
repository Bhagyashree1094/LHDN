#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------------------
# - OUTPUTS Cost COnsumption
#----------------------------


output "id" {
  value       = azurerm_consumption_budget_subscription.this.id
  description = "The ID of the created Const Consumption.."
}


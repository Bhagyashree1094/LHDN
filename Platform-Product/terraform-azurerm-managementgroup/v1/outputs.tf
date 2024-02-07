#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

output "name" {
  value = azurerm_management_group.this.display_name
  description = "The Name of the Management Group."
}

output "id" {
  value = azurerm_management_group.this.id
  description = "The ID of the Management Group."
}

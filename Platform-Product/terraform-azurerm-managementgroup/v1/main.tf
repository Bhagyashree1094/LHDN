#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# - Creating a Management group and associating multiple subscriptions
# -
resource "azurerm_management_group" "this" {
  display_name               = var.mg_name
  parent_management_group_id = var.parent_management_group_id
  subscription_ids           = var.subscription_ids
}
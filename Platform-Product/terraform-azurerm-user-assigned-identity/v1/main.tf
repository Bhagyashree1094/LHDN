#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: October 10th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 
# Overview:
#   This module:
#   - Creates user-assigned-identity and associated resources,

#
# - Dependencies data resources
#
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#
# - Create the User Assigned Identity
#
resource "azurerm_user_assigned_identity" "this" {
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  name = "id-${var.name}"
  tags = merge(data.azurerm_resource_group.this.tags, var.additional_tags)
}
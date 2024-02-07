#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: Dec. 27th, 2021.
# Created  by: shwetayadav
# Modified on: Dec. 30th, 2021
# Modified by: shwetayadav
# Overview:
#   This module:
#   - Creates a Private DNS Zone,
#   - creates the VNet associations.

#
# - Dependencies data resources
#
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#
# - Private DNS Zone
#
resource "azurerm_private_dns_zone" "this" {
  name                = var.private_dns_zone_name
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = merge(var.dns_zone_additional_tags, data.azurerm_resource_group.this.tags)
}

#
# - Private DNS Zone to VNet Link
#
resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each              = var.private_dns_zone_vnet_links

  name                  = substr("link_to_${split("/", each.value["vnet_id"])[8]}", 0, 80)
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value["vnet_id"]
  registration_enabled  = each.value["registration_enabled"]
  tags                  = azurerm_private_dns_zone.this.tags
}

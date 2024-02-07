#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: August 02nd, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Creates virtualnetwork-peering and associated resources,

#-------------------------------------------------- 
# - Dependencies data resources
#-------------------------------------------------- 
data "azurerm_virtual_network" "spoke_vnet" {
  provider = azurerm.spoke

  resource_group_name = split("/", var.spoke_vnet_id)[4]
  name                = split("/", var.spoke_vnet_id)[8]
}

data "azurerm_virtual_network" "hub_vnet" {
  provider = azurerm.hub

  resource_group_name = split("/", var.hub_vnet_id)[4]
  name                = split("/", var.hub_vnet_id)[8]
}

data "azurerm_client_config" "spoke_spn" {
  provider = azurerm.spoke
}
data "azurerm_client_config" "hub_spn" {
  provider = azurerm.hub
}

# #------------------------------
# # - Assign required role (aim is to get permission to perform action 'peer/action')
# #------------------------------
# module "bbl_role_assignment_hubspn_on_spokevnet" {

#  source = "../../terraform-azurerm-role-assignment/v1"

#   providers = {
#     azurerm = azurerm.spoke
#   }

#   # Role Assignment Variables
#   principal_id         = data.azurerm_client_config.hub_spn.object_id
#   role_definition_name = "Network contributor"
#   scope                = data.azurerm_virtual_network.spoke_vnet.id
# }
# module "bbl_role_assignment_spokespn_on_hubvnet" {

# source = "../../terraform-azurerm-role-assignment/v1"

#   providers = {
#     azurerm = azurerm.hub
#   }

#   # Role Assignment Variables
#   principal_id         = data.azurerm_client_config.spoke_spn.object_id
#   role_definition_name = "Network contributor"
#   scope                = data.azurerm_virtual_network.hub_vnet.id
# }

#------------------------------
# - Create the peering to a Hub VNet
#------------------------------
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  provider = azurerm.spoke

  # depends_on = [
  #   module.bbl_role_assignment_spokespn_on_hubvnet
  # ]

  name                 = lower("peering_to_hub_${data.azurerm_virtual_network.hub_vnet.name}")
  resource_group_name  = data.azurerm_virtual_network.spoke_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.spoke_vnet.name

  remote_virtual_network_id    = data.azurerm_virtual_network.hub_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.use_remote_gateways
}

resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  provider = azurerm.hub

  # depends_on = [
  #   module.bbl_role_assignment_hubspn_on_spokevnet
  # ]

  name                 = lower("peering_to_spoke_${data.azurerm_virtual_network.spoke_vnet.name}")
  resource_group_name  = data.azurerm_virtual_network.hub_vnet.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.hub_vnet.name

  remote_virtual_network_id    = data.azurerm_virtual_network.spoke_vnet.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = true
  use_remote_gateways          = false
}

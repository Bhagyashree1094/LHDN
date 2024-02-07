#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: August 02nd, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Creates a Virtual Network and associated resources

#------------------------------
# - Dependencies data resource
#------------------------------
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_network_ddos_protection_plan" "this" {
  count = var.enable_ddos_pp && !var.create_ddos_pp ? 1 : 0
  name                = var.ddos_plan_name 
  resource_group_name = var.ddos_resource_group_name
}

#------------------------------
# - Generate the Virtual Network name
#------------------------------
module "bbl_vnet_name" {

   source = "../../terraform-azurerm-module/v1"

  # BBL ordered naming inputs
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name
  # au               = var.au
  country         = var.country
  org             = var.org
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  # product_version = var.product_version


  # VNet specifics settings
  resource_type_code = "vnet"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length

  # Delete during bbl intake process
  iterator = var.iterator
}

#-------------------------------------------------- 
# - Generate the locals
#-------------------------------------------------- 
locals {
  ddos_pp_id = var.enable_ddos_pp && var.create_ddos_pp ? azurerm_network_ddos_protection_plan.ddospp[0].id : var.enable_ddos_pp && !var.create_ddos_pp ? data.azurerm_network_ddos_protection_plan.this[0].id : ""
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_vnet_name.tags,
    var.additional_tags
  )
}

resource "azurerm_network_ddos_protection_plan" "ddospp" {
  count = var.create_ddos_pp && var.enable_ddos_pp ? 1 : 0

  name                = var.ddos_plan_name
  resource_group_name = data.azurerm_resource_group.this
  location            = data.azurerm_resource_group.this.location

  tags = local.tags
}


#------------------------------
# - Create the Virtual Network
#------------------------------
resource "azurerm_virtual_network" "this" {
  name                = lower(module.bbl_vnet_name.name)
  location            = module.bbl_vnet_name.location
  resource_group_name = data.azurerm_resource_group.this.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  
  dynamic "ddos_protection_plan" {
    for_each = local.ddos_pp_id != "" ? ["ddos_protection_plan"] : []
    content {
      id     = local.ddos_pp_id
      enable = true
    }
  }
  
  tags = local.tags
}

#------------------------------
# - Create the Subnets
#------------------------------
resource "azurerm_subnet" "this" {
  for_each = var.subnets

  name                                           = each.key
  resource_group_name                            = var.resource_group_name
  address_prefixes                               = each.value["address_prefixes"]
  service_endpoints                              = lookup(each.value, "service_endpoints", null)
  enforce_private_link_endpoint_network_policies = lookup(each.value, "pe_enable", false)
  enforce_private_link_service_network_policies  = lookup(each.value, "pe_enable", false)
  virtual_network_name                           = azurerm_virtual_network.this.name

  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", [])
    content {
      name = lookup(delegation.value, "name", null)
      dynamic "service_delegation" {
        for_each = lookup(delegation.value, "service_delegation", [])
        content {
          name    = lookup(service_delegation.value, "name", null)
          actions = lookup(service_delegation.value, "actions", null)
        }
      }
    }
  }

  depends_on = [azurerm_virtual_network.this]
}

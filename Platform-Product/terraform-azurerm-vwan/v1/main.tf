#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: August 06th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Creates a Virtual Wan and it associated properties.

#------------------------------
# - Dependencies data resource
#------------------------------

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}


#------------------------------
# - Generate the Virtual WAN.
#------------------------------
module "bbl_vwan_name" {

   source = "../../terraform-azurerm-module/v1"

  # BBL ordered naming inputs
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name
  au               = var.au
  country         = var.country
  org             = var.org
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  product_version = var.product_version


  # VNet specifics settings
  resource_type_code = "vwan"
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
  
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_vwan_name.tags,
    var.additional_tags
  )
}

#------------------------------
# - Create the Virtual WAN.
#------------------------------
resource "azurerm_virtual_wan" "this" {
  name                = lower(module.bbl_vwan_name.name)
  location            = module.bbl_vwan_name.location
  resource_group_name = data.azurerm_resource_group.this.name
  type                = var.vwan_type
  disable_vpn_encryption            = var.disable_vpn_encryption
  allow_branch_to_branch_traffic    = var.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.office365_local_breakout_category
  tags                = local.tags
}
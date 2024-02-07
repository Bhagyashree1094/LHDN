#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: August 02nd, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Creates a DDOS plan and associated resources,

#------------------------------
# - Dependencies data resource
#------------------------------
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#------------------------------
# - Generate the DDOS name
#------------------------------

module "bbl_ddos_name" {

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
  resource_type_code = "ddos"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length

  # Delete during bbl intake process
  iterator = var.iterator
}

#--------------------------------------
# - Generate the DDOS tags
#--------------------------------------

locals {
  
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_ddos_name.tags,
    var.additional_tags
  )
}


#--------------------------------------
# - Generate the DDOS Protection plan
#--------------------------------------

resource "azurerm_network_ddos_protection_plan" "this" {
  name                = lower(module.bbl_ddos_name.name)
  location            = module.bbl_ddos_name.location
  resource_group_name = data.azurerm_resource_group.this.name
  tags                = local.tags
}


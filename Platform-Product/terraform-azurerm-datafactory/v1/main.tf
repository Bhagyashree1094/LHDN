#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: October 10th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

#--------------------------------
# - Dependencies data resources
#-------------------------------


data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}


# ------------------------------------
# - Get the current user/app config
# ------------------------------------
data "azurerm_client_config" "current" {}

# 
# - Generate the Data Factory name
#
module "bbl_df_name" {


   source = "../../terraform-azurerm-module/v1"

  # BBL ordered naming inputs
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  au              = var.au
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  product_version = var.product_version

  # kubernetes-cluster specifics settings
  resource_type_code = "adf"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

# 
# - Generate the locals
# 
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_df_name.tags,
    var.additional_tags
  )
}

#####################################################
# Creation of Azure Data Factory
#####################################################

resource "azurerm_data_factory" "this" {

  name                                = module.bbl_df_name.name
  resource_group_name                 = data.azurerm_resource_group.this.name
  location                            = module.bbl_df_name.location

  identity {
    type = "SystemAssigned"
  }

  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  public_network_enabled = false
  tags = local.tags
 
}
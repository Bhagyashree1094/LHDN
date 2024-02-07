#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------------------
# - Referencing Resource Group module
#-------------------------------------
module "resource_group_spoke" {
  source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-resourcegroup/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name_spoke
  iterator        = "008"
  au              = var.au
  owner           = var.owner
  product_version = var.product_version
  additional_tags = var.additional_tags

}

module "ddos" {
  source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-ddos/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  iterator        = "001"
  au              = var.au
  owner           = var.owner
  product_version = var.product_version
  additional_tags = var.additional_tags

  resource_group_name = module.resource_group_hub.name

  depends_on = [ module.resource_group_hub ]
  

}

#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------------------
# - Referencing Resource Group module
#-------------------------------------
module "bbl_rg_test" {
  # Terraform Cloud/Enterprise use
  source = "../../terraform-azurerm-resourcegroup"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.rg_base_name
  additional_name = var.rg_additional_name
  iterator        = var.iterator

  au              = var.au
  owner           = var.owner
  additional_tags = var.rg_additional_tags
}

#--------------------------------------------
#   Creating Log Analytics Workspace
#--------------------------------------------
module "bbl_law_test" {
  # Local use
  source = "../../terraform-azurerm-law"


  depends_on = [
    module.bbl_rg_test
  ]

  resource_group_name = module.bbl_rg_test.name
  org                 = var.org
  country             = var.country
  env                 = var.env
  au                  = var.au
  owner               = var.owner
  region_code         = var.region_code
  base_name           = var.law_base_name
  additional_name     = var.law_additional_name
  additional_tags     = var.law_additional_tags
  add_random          = "true"
  rnd_length          = 3
  iterator            = var.iterator

  sku               = var.sku
  retention_in_days = var.retention_in_days
}

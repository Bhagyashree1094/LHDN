#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Tests for Resource Group module
#--------------------------------------------------------------
module "bbl_rg_test" {
  # Local use
  source = "../../terraform-azurerm-wf-resourcegroup"


  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code1
  base_name       = var.base_name
  additional_name = ""
  iterator        = "01"
  au              = var.au
  owner           = var.owner
  additional_tags = var.rg_additional_tags
  product_version = var.product_version
}
module "wf_rg_test2" {
  # Local use
  source = "../../terraform-azurerm-wf-resourcegroup"


  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code2
  base_name       = var.base_name
  additional_name = null
  iterator        = "v02"
  au              = "0212345"
  owner           = var.owner
  additional_tags = var.rg_additional_tags
  product_version = var.product_version

  add_random  = true
  rnd_length  = 3
}

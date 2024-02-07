#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Required pre-requisite Resource Group
#--------------------------------------------------------------
module "bbl_rg_test" {


  # Local use
  source = "../../terraform-azurerm-resource-group/v1"


  org                = var.org
  country            = var.country
  env                = var.env
  region_code        = var.region_code
  base_name          = var.base_name
  additional_name    = var.rg_additional_name
  au                 = var.au
  owner              = var.owner
  rg_additional_tags = var.rg_additional_tags
}


#--------------------------------------------------------------
#   Tests for Route Table module
#--------------------------------------------------------------

module "bbl_rt_test" {
  # Local use
  source = "../../terraform-azurerm-route-table/v1"

  depends_on = [
    module.bbl_rg_test
  ]

  resource_group_name = module.bbl_rg_test.name
  # Route Table naming Variables
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.rt_additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  add_random      = var.add_random
  rnd_length      = var.rnd_length
  route_table     = var.route_table
}



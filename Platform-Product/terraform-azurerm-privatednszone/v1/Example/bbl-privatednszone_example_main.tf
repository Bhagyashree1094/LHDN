#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Creating Resource Groups
#--------------------------------------------------------------
module "bbl_rg_test1" {
 
  source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-resourcegroup/v1"
  org                 = var.org
  country             = var.country
  env                 = var.env
  region_code         = var.region_code
  base_name           = var.base_name
  additional_name     = var.rg_additional_name
  au                  = var.au
  owner               = var.owner
  additional_tags     = var.rg_additional_tags
}

#--------------------------------------------------------------
#   Tests for Private DNS Zone module
#--------------------------------------------------------------
module "bbl_pdnsz" {
  # Local use
  source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-privatednszone/v1"

  depends_on = [
    module.bbl_rg_test1
  ]

  resource_group_name          = module.bbl_rg_test1.name
  private_dns_zone_name        = var.private_dns_zone_name
  private_dns_zone_vnet_links  = var.private_dns_zone_vnet_links
}

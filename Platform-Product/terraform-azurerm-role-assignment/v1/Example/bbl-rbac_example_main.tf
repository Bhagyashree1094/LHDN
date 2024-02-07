#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Creating Resource Group
#--------------------------------------------------------------
module "bbl_rg_1" {
  # Terraform Cloud/Enterprise use
  source  = "app.terraform.io/msftbbldeo/bbl-resourcegroup/azurerm"
  version = "1.0.3"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.rg_additional_name
  au              = var.au
  owner           = var.owner
  additional_tags = var.rg_additional_tags
  product_version = var.product_version

  add_random  = true
}

#--------------------------------------------------------------
#   Assigning built-in roles to different Azure resources
#--------------------------------------------------------------
module "bbl_role-assignment_1" {
  # Local use
  source = "../../terraform-azurerm-bbl-role-assignment"

  # Role Assignment
  principal_id         = var.spn_principal_id
  role_definition_name = var.spn_role_name
  scope                = module.bbl_rg_1.id
}

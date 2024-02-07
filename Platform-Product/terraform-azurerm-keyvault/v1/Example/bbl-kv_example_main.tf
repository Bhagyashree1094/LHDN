#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#---------------------------
# - Creating Resource Group
#---------------------------
module "bbl_rg" {
  # Terraform Local use
  source = "value"
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.rg_additional_name
  iterator        = var.iterator
  product_version = var.product_version

  au              = var.au
  owner           = var.owner
  add_random      = true
  additional_tags = var.rg_additional_tags
}

#----------------------
# - Creating Key Vault
#----------------------
module "bbl_kv" {

  # Local Use
  source = "../../terraform-azurerm-keyvault"

  depends_on = [
    module.bbl_rg
  ]

  # Key Vault naming Variables
  org             = var.org
  country         = var.country
  env             = var.env
  au              = var.au
  owner           = var.owner
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.kv_additional_name
  add_random      = true
  rnd_length      = var.rnd_length
  additional_tags = var.kv_additional_tags
  iterator        = var.iterator

  # Key Vault variables
  resource_group_name             = module.bbl_rg.name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  secrets      = var.secrets
  network_acls = var.network_acls
}

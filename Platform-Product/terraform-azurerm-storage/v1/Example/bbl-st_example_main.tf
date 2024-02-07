#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
# - Resource Group
#--------------------------------------------------------------
module "bbl_rg" {
  source = "../../terraform-azurerm-resourcegroup/v1"

  # Resource Group naming
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name
  product_version = var.product_version

  au      = var.au
  country = var.country
  org     = var.org
  owner   = var.owner

  add_random = true
  rnd_length = 2

  # Delete during bbl intake process
  iterator = var.iterator
}

#----------------------------------------
# - Key vault
#----------------------------------------
module "bbl_kv" {
 source = "../../terraform-azurerm-keyvault/v1"

  depends_on = [
    module.bbl_rg
  ]

  # Key Vault naming
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name
  product_version = var.product_version

  au      = var.au
  country = var.country
  org     = var.org
  owner   = var.owner

  add_random = true
  rnd_length = 2

  # Delete during bbl intake process
  iterator = var.iterator

  # Key Vault variables
  resource_group_name             = module.bbl_rg.name
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  network_acls                    = local.kv_network_acls

  # Secrets
  secrets = {
    "validation" = "Validated!"
  }
}
#*/

#------------------------------------------
#  - Creating Storage account
#------------------------------------------
module "bbl_st" {
  # Local use
  source = "../../terraform-azurerm-storage/v1"


  depends_on = [
    module.bbl_rg
  ]

  # Storage Account naming
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name
  product_version = var.product_version

  au      = var.au
  country = var.country
  org     = var.org
  owner   = var.owner

  add_random = true
  rnd_length = 2

  # Delete during bbl intake process
  iterator = var.iterator

  # Storage Account settings
  resource_group_name = module.bbl_rg.name
  key_vault_id        = module.bbl_kv.id

  is_log_storage     = false
  persist_access_key = true
  assign_identity    = true
  cmk_enabled        = true

  containers  = var.st1_containers
  blobs       = var.st1_blobs
  queues      = var.st1_queues
  file_shares = var.st1_file_shares
  tables      = var.st1_tables

  network_rules = local.st_network_acls
}
#*/
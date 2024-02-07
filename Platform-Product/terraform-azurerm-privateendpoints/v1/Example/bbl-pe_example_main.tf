#
# Copyright 2023 BBL & Microsoft. All rights reserved.

#--------------------------------------------------------------
#   Required pre-requisites Resource Group, Storage Account, Key Vault
#--------------------------------------------------------------
module "bbl_rg_test" {
  # Local use
  # source = "../../terraform-azurerm-bbl-resourcegroup"


  org                = var.org
  country            = var.country
  env                = var.env
  region_code        = var.region_code
  base_name          = var.base_name
  #additional_name    = var.rg_additional_name
  au                 = var.au
  owner              = var.owner
  rg_additional_tags = var.rg_additional_tags
}

module "bbl_kv_test" {
  # Local use
  # source = "../../terraform-azurerm-bbl-keyvault"

  depends_on = [
    module.bbl_rg_test
  ]
  resource_group_name = module.bbl_rg_test.name

  # Key Vault naming Variables
  org             = var.org
  country         = var.country
  env             = var.env
  au              = var.au
  owner           = var.owner
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.kv_additional_name
  randomize_name  = var.randomize_name
  rnd_length      = var.rnd_length

  # Key Vault variables
  sku_name                        = var.sku_name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  soft_delete_retention_days      = 45

  access_policies     = var.access_policies
  tf_client_object_id = var.tf_client_object_id
  secrets             = var.secrets
  network_acls        = var.network_acls
  kv_additional_tags  = var.kv_additional_tags
}

module "bbl_st_test" {
  # Local use
  # source = "../../terraform-azurerm-bbl-storage"

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
  base_name           = var.base_name
  additional_name     = var.st_additional_name
  st_additional_tags  = var.st_additional_tags
  randomize_name      = false

  containers  = var.st_containers
  blobs       = var.st_blobs
  queues      = var.st_queues
  file_shares = var.st_file_shares
  tables      = var.st_tables
}

#--------------------------------------------------------------
#   Tests for Private Endpoints module
#--------------------------------------------------------------
module "bbl_pe_test" {
  source = "../../terraform-azurerm-bbl-privateendpoints"

  depends_on = [
    module.bbl_st_test, module.bbl_kv_test
  ]

  resource_group_name = module.bbl_rg_test.name
  private_endpoints = {
    pe_kv = {
      name                          = module.bbl_kv_test.key_vault_name
      subnet_id                     = var.pe_subnet_id
      group_ids                     = ["vault"]
      approval_required             = var.pe_approval_required
      approval_message              = "Please approve Private Endpoint connection for ${module.bbl_kv_test.key_vault_name}"
      private_connection_address_id = module.bbl_kv_test.key_vault_id
    },
    pe_st = {
      name                          = module.bbl_st_test.sa_name
      subnet_id                     = var.pe_subnet_id
      group_ids                     = ["Blob"]
      approval_required             = var.pe_approval_required
      approval_message              = "Please approve Private Endpoint connection for ${module.bbl_st_test.sa_name}"
      private_connection_address_id = module.bbl_st_test.sa_id
    }
  }
}
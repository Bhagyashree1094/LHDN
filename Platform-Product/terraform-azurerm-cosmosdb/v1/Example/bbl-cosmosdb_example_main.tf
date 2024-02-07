
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
}
module "cosmos_dbs" {

  source          = "./Platform-Product/terraform-azurerm-cosmosdb-nosql"
  org             = var.org
  country         = var.country
  env             = var.env
  au              = var.au
  owner           = var.owner
  region_code     = var.region_code
  base_name       = var.base_name
  product_version = var.product_version
  additional_tags = var.additional_tags
  iterator        = "001"
  bu              = var.bu
  app_code        = var.app_code

  # CosmosDB Module Var
  resource_group_name               = var.resource_group_name
  offer_type                        = var.offer_type
  kind                              = var.kind
  enable_free_tier                  = var.enable_free_tier
  ip_range_filter                   = var.ip_range_filter
  analytical_storage_enabled        = var.analytical_storage_enabled
  bypass_for_azure_services_enabled = var.bypass_for_azure_services_enabled
  consistency_policy                = var.consistency_policy
  geo_locations                     = var.geo_locations
  total_throughput_limit            = var.total_throughput_limit
  backup                            = var.backup
  identity_type                     = var.identity_type
}

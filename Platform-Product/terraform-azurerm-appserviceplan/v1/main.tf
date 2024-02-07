#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: Oct. 04, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by:
# Overview:
#   This module:
#   - Creates app-service-plan and associated resources,

#-------------------------------
# - Dependencies data resources
#-------------------------------
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#-----------------------------
# - Generate the resource name
#-----------------------------
module "bbl_asp_name" {

source = "../../terraform-azurerm-module/v1"


  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  bu              = var.bu
  app_code        = var.app_code
  product_version = var.product_version

  # app-service specifics settings
  resource_type_code = "asp"
  max_length         = 40
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

#-----------------------------------
# - Generate the locals for ASP tags
#-----------------------------------
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_asp_name.tags,
    var.additional_tags
  )
}

#----------------------------
# - Create app-service-plan 
#----------------------------
resource "azurerm_service_plan" "this" {
  name                           = lower(module.bbl_asp_name.name)
  resource_group_name            = data.azurerm_resource_group.this.name
  location                       = module.bbl_asp_name.location
  os_type                        = var.os_type 
  sku_name                       = var.sku_name
  app_service_environment_id     = var.app_service_environment_id
  maximum_elastic_worker_count   = var.maximum_elastic_worker_count
  worker_count                   = var.worker_count 
  per_site_scaling_enabled       =  var.per_site_scaling_enabled
  zone_balancing_enabled         =  var.zone_balancing_enabled
  tags = local.tags
}

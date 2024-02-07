#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by: 
# Overview:
#   This module:
#   - Creates an Azure Log Analytics Workspace

#-------------------------------
# - Dependencies data resources
#-------------------------------
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#--------------------
# - Generating Local
#--------------------
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_law_name.tags,
    var.additional_tags
  )
}

#-------------------------------------------------------------------------
# - Generate name for the Log Analytics Workspace with BBL Naming module
#-------------------------------------------------------------------------
# PR-030, PR-031 Landing Zone: Naming Conventions.
module "bbl_law_name" {

  source = "../../terraform-azurerm-module/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  # au              = var.au
  owner           = var.owner
  # product_version = var.product_version
  bu              = var.bu
  app_code        = var.app_code

  # Log Analytics Workspace specifics settings
  resource_type_code = "law"
  max_length         = 64
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

#---------------------------
# - Log Analytics Workspace
#---------------------------
# PR-001, PR-006 Cloud Management Plane: The monitored logs get stored in Log Analytics workspace. Wells Fargo will have one central Log Analytics workspace per region for the Platform Landing Zone/MVP 1.0.
resource "azurerm_log_analytics_workspace" "this" {
  name                               = lower(module.bbl_law_name.name)
  location                           = module.bbl_law_name.location
  resource_group_name                = data.azurerm_resource_group.this.name
  sku                                = var.sku
  retention_in_days                  = var.retention_in_days
  internet_ingestion_enabled         = "false"
  internet_query_enabled             = "false"
  daily_quota_gb                     = var.sku == "Free" ? null : var.daily_quota_gb
  reservation_capacity_in_gb_per_day = var.sku == "CapacityReservation" ? var.reservation_capacity_in_gb_per_day : null
  tags                               = local.tags
}

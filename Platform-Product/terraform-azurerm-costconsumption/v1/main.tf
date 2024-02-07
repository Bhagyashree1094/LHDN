#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: September 06th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Manages a Subscription Consumption Budget.

#------------------------------
# - Dependencies data resource
#------------------------------

data "azurerm_subscription" "current" {}
data "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 0 : 1
  name = var.resource_group_name
}

#------------------------------------
# - Generate the Azure RG Name.
#------------------------------------
module "bbl_rg_name" {
  # Local uses
   #source = "git::ssh://git@ssh.dev.azure.com/v3/akashc0319/BBL-POC/Modules//Platform-Product/terraform-azurerm-module/v1"
   source = "../../terraform-azurerm-module/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  au              = var.au
  owner           = var.owner
  product_version = var.product_version
  bu              = var.bu
  app_code        = var.app_code

  # Resource Group specifics settings
  resource_type_code  = "rg"
  max_length          = 90
  no_dashes           = false
  add_random          = var.add_random
  rnd_length          = var.rnd_length
}

# -----------------------------
# - Create the Resource Group
# ----------------------------
resource "azurerm_resource_group" "this" {
  count    = var.create_resource_group ? 1 : 0
  name     = module.bbl_rg_name.name
  location = module.bbl_rg_name.location

  tags = merge(module.bbl_rg_name.tags, var.additional_tags)
}

# ----------------------------------
# - Create the Monitor Action group
# ---------------------------------

resource "azurerm_monitor_action_group" "this" {
  name                = var.action_group_name
  resource_group_name = azurerm_resource_group.this[0].name
  short_name          = "bbl${var.app_code}name"
  email_receiver {
    name = var.app_email_receiver_name
    email_address = var.app_email_receiver_address
  }
}

resource "azurerm_monitor_action_group" "finops" {
  name                = "${var.action_group_name}-finops"
  resource_group_name = azurerm_resource_group.this[0].name
  short_name          = "bbl${var.app_code}name"
  email_receiver {
    name = var.finops_email_receiver_name
    email_address = var.finops_email_receiver_address
  }
}

# ----------------------------------
# - Create the Cost Mnagement Budget
# ---------------------------------

resource "azurerm_consumption_budget_subscription" "this" {
name = var.consumption_budget_name
subscription_id = data.azurerm_subscription.current.id
amount = var.amount_consumption_budget
time_grain = "Monthly"
time_period {
  start_date =  var.start_date
  end_date = "2025-11-01T00:00:00Z"
}
notification {
  enabled = true
  operator = "GreaterThan"
  threshold = 80
  threshold_type = "Forecasted"
  contact_groups = [ azurerm_monitor_action_group.this.id ]

}

notification {
  enabled = true
  operator = "GreaterThan"
  threshold = 120
  threshold_type = "Forecasted"
  contact_groups = [ azurerm_monitor_action_group.finops.id ]
}

depends_on = [ azurerm_monitor_action_group.this, azurerm_monitor_action_group.finops ]
}




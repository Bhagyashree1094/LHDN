#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------------
# - Dependencies Resources
#-------------------------------

data "azurerm_billing_enrollment_account_scope" "this" {
  billing_account_name    = var.billing_account_name
  enrollment_account_name = var.enrollment_account_name
}

data "azurerm_management_group" "this" {
  name = var.management_group_name
}


#-------------------------------
# - Creating Subscription
#-------------------------------

resource "azurerm_subscription" "this" {

subscription_name = var.subscription_name 
billing_scope_id = data.azurerm_billing_enrollment_account_scope.this.id   
workload = var.workload
tags = var.tags
}

#-------------------------------
# - Linking to management group
#-------------------------------

resource "azurerm_management_group_subscription_association" "this" {
   
    management_group_id = data.azurerm_management_group.this.id
    subscription_id = "/subscriptions/${azurerm_subscription.this.subscription_id}"

    depends_on = [ azurerm_subscription.this ]
}

provider "azurerm" {
  features {}
  alias = "new-sub"
  partner_id = "8FAD6B47-2BC8-5140-8022-148D25942560"
  #subscription_id = azurerm_subscription.this.subscription_id 
}

data "azurerm_resource_group" "this" {
  count = var.create_resource_group ? 0 : 1
  name = var.resource_group_name
}

data "azurerm_subscription" "name" {
  subscription_id = azurerm_subscription.this.subscription_id
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
  provider = azurerm.new-sub
  name     = module.bbl_rg_name.name
  location = module.bbl_rg_name.location

  tags = merge(module.bbl_rg_name.tags, var.additional_tags)
  depends_on = [ azurerm_subscription.this ]
}

# ----------------------------------
# - Create the Monitor Action group
# ---------------------------------

resource "azurerm_monitor_action_group" "this" {
  provider = azurerm.new-sub
  name                = var.action_group_name
  resource_group_name = azurerm_resource_group.this[0].name
  short_name          = "bbl${var.app_code}name"
  email_receiver {
    name = var.app_email_receiver_name
    email_address = var.app_email_receiver_address
  }
  depends_on = [ azurerm_subscription.this ]
}

resource "azurerm_monitor_action_group" "finops" {
  provider = azurerm.new-sub
  name                = "${var.action_group_name}-finops"
  resource_group_name = azurerm_resource_group.this[0].name
  short_name          = "bbl${var.app_code}name"
  email_receiver {
    name = var.finops_email_receiver_name
    email_address = var.finops_email_receiver_address
  }
  depends_on = [ azurerm_subscription.this ]
}

# ----------------------------------
# - Create the Cost Mnagement Budget
# ---------------------------------

resource "azurerm_consumption_budget_subscription" "this" {
name = var.consumption_budget_name
subscription_id = "/subscriptions/${azurerm_subscription.this.subscription_id}"
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

depends_on = [ azurerm_monitor_action_group.this, azurerm_monitor_action_group.finops, azurerm_subscription.this ]
}


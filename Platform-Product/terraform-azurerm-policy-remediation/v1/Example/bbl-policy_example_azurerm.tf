#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Provider to access the Test Subscription
#--------------------------------------------------------------
provider "azurerm" {
  # Reference: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#argument-reference
  alias = "testSubscription" # Comment/Remove this alias as it may not be needed

  environment = "public"
  partner_id  = "adb8eac6-989a-5354-8580-19055546ec74"

  tenant_id       = ""
  subscription_id = ""
  client_id       = ""
  client_secret   = ""

  features {}
}

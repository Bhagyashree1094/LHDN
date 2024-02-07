#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Test BBL module
#--------------------------------------------------------------
module "bbl_module_rg" {
  # Local use
  source = "../../terraform-azurerm-module/v1" #path of your local repo

  # org           = ""
  # country       = ""
  env             = "core"
  region_code     = "sea"
  base_name       = "module"
  additional_name = ""
  iterator        = "001"
  au              = "00121"
  owner           = "test@test.com"
  product_version = "1.0.0"
  additional_tags = {
    app_id      = "XXYY"
    test_by     = "emberger"
  }

  # Resource naming inputs
  resource_type_code = "rg"
  max_length      = 64
  no_dashes       = false
  add_random      = true
  rnd_length      = 4
}

# Test by creating a Resource Group with the module's outputs
resource "azurerm_resource_group" "this" {
  name      = module.bbl_module_rg.name
  location  = module.bbl_module_rg.location

  tags      = module.bbl_module_rg.tags
}

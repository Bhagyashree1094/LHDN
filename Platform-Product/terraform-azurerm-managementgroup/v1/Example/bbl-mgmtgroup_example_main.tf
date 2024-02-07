#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Tests for Management Group Module
#--------------------------------------------------------------
module "management_group_level_1" {
  # Local use
  source = "../../terraform-azurerm-managementgroup"

  mg_name                     = var.display_name_level_1
  parent_management_group_id  = var.root_management_group_id
  subscription_ids            = var.subscription_ids_level_1
}

module "management_group_level_2" {
  # Local use
  source = "../../terraform-azurerm-managementgroup"

  depends_on = [
    module.management_group_level_1
  ]

  mg_name                     = var.display_name_level_2
  parent_management_group_id  = module.management_group_level_1.id
  subscription_ids            = var.subscription_ids_level_2
}

module "management_group_level_3" {
  # Local use
  source = "../../terraform-azurerm-managementgroup"

  depends_on = [
    module.management_group_level_2
  ]

  mg_name                     = var.display_name_level_3
  parent_management_group_id  = module.management_group_level_2.id
  subscription_ids            = var.subscription_ids_level_3
}

module "managementgroup_level_4" {
  # Local use
  source = "../../terraform-azurerm-managementgroup"


  depends_on = [
    module.management_group_level_3
  ]
  mg_name                     = var.display_name_level_4
  parent_management_group_id  = module.management_group_level_3.id
  subscription_ids            = var.subscription_ids_level_4
}
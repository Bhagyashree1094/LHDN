#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by: 

#-------------------------------------------
#    Policy Definition module
#------------------------------------------
module "bbl-policy-definition1" {
  # Local use
  source = "../../terraform-azurerm-policy-definition"


  # Required variable
  policyDefinitionJsonFile = "Resource_Group_Tags.json"

  # Optional variables
  name                = "Resource_Group_Tags"
  display_name        = "Resource_Group_Tags"
}
module "bbl-policy-definition2" {
  # Local use
  source = "../../terraform-azurerm-policy-definition"

  # Required variable
  policyDefinitionJsonFile = "Resource_Group_Tags.json"

  # Optional variables
  name                = "Resource_Group_Tags_mgmt"
  display_name        = "Resource_Group_Tags_mgmt"
  management_group_id = "/providers/Microsoft.Management/managementGroups/test"

}
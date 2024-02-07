#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#
# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

#-------------------------------------------
#    Policy Set Definition module
#------------------------------------------
module "bbl-policy-set-definition1" {
  # Local use
  source = "../../terraform-azurerm-policy-set-definition"


  display_name                = null
  name                        = "Deploy-MDFC-Config"
  policySetDefinitionJsonFile = "policy_set_definition_es_deploy_mdfc_config.tmpl.json"
  management_group_id         = "/providers/Microsoft.Management/managementGroups/test"
}
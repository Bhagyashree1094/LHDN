#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by: 

#------------------------------------------------------------------------------------------
# - Create Policy Exemption for assignments over policy defintion and policy set definition
#------------------------------------------------------------------------------------------

# - Below example showcases Policy Exemption for assignments over policy defintion
module "bbl_policy_exemption_1" {
  source = "../../terraform-azurerm-policy-exemption"


  name                            = "AKS PE DNS_Exemption"
  policy_assignment_id            = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyAssignments/cdcb72dbb60440708768ac19"
  scope                           = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19"
  exemption_category              = "Waiver"
  description                     = "Policy Exemption."
  expires_on                      = "2022-08-01T07:02:23Z"
  display_name                    = "Policy1"
  metadata                        = null
  policy_definition_reference_ids = null
}

# Below example showcases Policy Exemption for assignments over policy set defintion
module "bbl_policy_exemption_2" {
  source = "../../terraform-azurerm-bbl-policy-exemption"


  name                            = "Deploy-Private-DNS-Zones_Exemption"
  policy_assignment_id            = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyAssignments/883d9ae633fe41b3ae474520"
  scope                           = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19"
  exemption_category              = "Waiver"
  description                     = "Policy Exemption."
  expires_on                      = "2022-08-01T07:02:23Z"
  display_name                    = "Policy2"
  metadata                        = null
  policy_definition_reference_ids = ["DINE-Private-DNS-Azure-KeyVault"]
}

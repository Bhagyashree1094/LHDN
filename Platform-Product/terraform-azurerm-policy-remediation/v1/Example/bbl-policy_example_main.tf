#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by: 

#---------------------------------------------------
# - Create Policy Remediation for assignments over policy defintion and policy set definition
#---------------------------------------------------

# - Below example showcases Policy Remediation for assignments over policy defintion
module "bbl_policy_remediation_1" {
  source = "../../terraform-azurerm-policy-remediation"

  name                    = "AKS PE DNS_Remediation"
  policy_assignment_id    = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyAssignments/cdcb72dbb60440708768ac19"
  scope                   = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19"
  resource_discovery_mode = "ExistingNonCompliant"
  location_filters        = ["NorthCentralUS", "SouthCentralUS"]
  policy_definition_id    = "/providers/Microsoft.Authorization/policyDefinitions/4750c32b-89c0-46af-bfcb-2e4541a818d5"
}

# - Below example showcases Policy Remediation for assignments over policy set defintion
module "bbl_policy_remediation_2" {
  source = "../../terraform-azurerm-policy-remediation"

  name                    = "Deploy-Private-DNS-Zones_Remediation"
  policy_assignment_id    = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyAssignments/883d9ae633fe41b3ae474520"
  scope                   = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19"
  resource_discovery_mode = "ExistingNonCompliant"
  policy_definition_id    = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyDefinitions/App_Services_PE_DNS_Record"
}

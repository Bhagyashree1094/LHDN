# Azure Policy Remediation Module

## Overview

This terraform module creates Azure Policy Remediation to remediate non-compliant resources as per policy assignments.

## Notes

This module remediates the policy assignments consistently over policy definitions or policy set definitions to a defined scope. However, a few considerations must be made:

- While remediating the resources, if a policy assignment is provided which is linked to a policy set definition, then, providing the unique policy definition ID from the set definition, which has to be remediated, is required.
- Input variable `policy_definition_id` is optional when specifying a policy assignment associated with a policy definition.

## Security Controls

- Not Applicable.

## Security Decisions

- Not Applicable.

## Example

```yaml
module "bbl_policy_remediation" {

   # Local use
  source = "../../terraform-azurerm-policy-remediation"

  name                    = "Deploy-Private-DNS-Zones_Remediation"
  policy_assignment_id    = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyAssignments/883d9ae633fe41b3ae474520"
  scope                   = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19"
  resource_discovery_mode = "ExistingNonCompliant"
  policy_definition_id    = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyDefinitions/App_Services_PE_DNS_Record"
}
```

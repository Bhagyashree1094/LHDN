# Azure Policy Exemption Module

## Overview

This terraform module creates the Azure Policy exemptions to exempt a resource hierarchy or an individual resource from evaluation of initiatives or definitions.

## Notes

- This module exempt the policy assignments consistently over policy definitions or policy set definitions to a defined scope.
- The policy exemption name length must not exceed '64' characters."
- DisplayName has a maximum length of 128 characters and description a maximum length of 512 characters.
- To set when a resource hierarchy or an individual resource is no longer exempt from an assignment, set the expiresOn property. This optional property must be in the Universal ISO 8601 DateTime format yyyy-MM-ddTHH:mm:ss.fffffffZ.
  - The policy exemptions isn't deleted when the expiresOn date is reached. The object is preserved for record-keeping, but the exemption is no longer honored.

- For more details, refer [Policy Exemption Structure](https://docs.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure).
  
## Security Controls

- Not Applicable.

## Security Decisions

- Not Applicable.

## Example

```yaml
module "bbl_policy_exemption" {

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
```

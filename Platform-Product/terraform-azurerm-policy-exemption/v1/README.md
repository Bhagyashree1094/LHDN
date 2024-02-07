<!-- BEGIN_TF_DOCS -->
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

## Documentation
<!-- markdownlint-disable MD033 -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0 |

### Modules

No modules.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_exemption_category"></a> [exemption\_category](#input\_exemption\_category) | (Required) The category of this policy exemption. Possible values are Waiver and Mitigated. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Policy Exemption. | `string` | n/a | yes |
| <a name="input_policy_assignment_id"></a> [policy\_assignment\_id](#input\_policy\_assignment\_id) | (Required) The ID of the Policy Assignment that should be exempted. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) The scope at which the Policy Exemption should be applied. | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description to use for this Policy Exemption. | `string` | `null` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | (Optional) A friendly display name to use for this Policy Exemption. | `string` | `null` | no |
| <a name="input_expires_on"></a> [expires\_on](#input\_expires\_on) | (Optional) The expiration date and time in UTC ISO 8601 format of this policy exemption. | `string` | `null` | no |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | (Optional) The metadata for this policy exemption. This is a JSON string representing additional metadata that should be stored with the policy exemption. | `any` | `null` | no |
| <a name="input_policy_definition_reference_ids"></a> [policy\_definition\_reference\_ids](#input\_policy\_definition\_reference\_ids) | (Optional) The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. | `list(string)` | `null` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_exemption.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_exemption) | resource |
| [azurerm_resource_group_policy_exemption.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_exemption) | resource |
| [azurerm_resource_policy_exemption.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_exemption) | resource |
| [azurerm_subscription_policy_exemption.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_exemption) | resource |

### Outputs

No outputs.

<!-- END_TF_DOCS -->
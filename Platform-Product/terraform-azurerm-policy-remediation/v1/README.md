<!-- BEGIN_TF_DOCS -->
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

  source = "../../terraform-azurerm-policy-remediation"


  name                    = "Deploy-Private-DNS-Zones_Remediation"
  policy_assignment_id    = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyAssignments/883d9ae633fe41b3ae474520"
  scope                   = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19"
  resource_discovery_mode = "ExistingNonCompliant"
  policy_definition_id    = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/providers/Microsoft.Authorization/policyDefinitions/App_Services_PE_DNS_Record"
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
| <a name="input_name"></a> [name](#input\_name) | (Required) The name which should be used for this Policy Remediation. | `string` | n/a | yes |
| <a name="input_policy_assignment_id"></a> [policy\_assignment\_id](#input\_policy\_assignment\_id) | (Required) The ID of the Policy Assignment that should be remediated. | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) The scope at which the Policy Remediation should be applied. | `string` | n/a | yes |
| <a name="input_location_filters"></a> [location\_filters](#input\_location\_filters) | (Optional) A list of the resource locations that will be remediated. | `list(string)` | `null` | no |
| <a name="input_policy_definition_id"></a> [policy\_definition\_id](#input\_policy\_definition\_id) | (Optional) The unique ID for the policy definition within the policy set definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition. | `string` | `null` | no |
| <a name="input_resource_discovery_mode"></a> [resource\_discovery\_mode](#input\_resource\_discovery\_mode) | (Optional) The way that resources to remediate are discovered. Possible values are `ExistingNonCompliant`, `ReEvaluateCompliance`. Defaults to `ExistingNonCompliant`. | `string` | `null` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_management_group_policy_remediation.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group_policy_remediation) | resource |
| [azurerm_resource_group_policy_remediation.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_policy_remediation) | resource |
| [azurerm_resource_policy_remediation.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_policy_remediation) | resource |
| [azurerm_subscription_policy_remediation.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subscription_policy_remediation) | resource |

<!-- END_TF_DOCS -->
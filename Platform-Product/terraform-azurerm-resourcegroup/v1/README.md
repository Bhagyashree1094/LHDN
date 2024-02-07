<!-- BEGIN_TF_DOCS -->
# Resource Group module

## Overview

This Terraform module creates an Azure Resource Group.

A resource group is a container that holds related resources for an Azure solution.
The resource group can include all the resources for the solution, or only those resources that needs to be managed as a group.

## Notes

None.

## Example

```yaml
module "bbl_rg_test" {
  # Terraform Cloud/Enterprise use
  source = "../../terraform-azurerm-module/v1"

  org                 = var.org                 # "bbl"
  country             = var.country             # "th"
  env                 = var.env                 # "prod"
  region_code         = var.region_code         # "sea"
  base_name           = var.base_name           # "app01"
  additional_name     = var.additional_name     # "team1"
  iterator            = var.iterator            # "v01"
  owner               = var.owner               # "test@bbl.com"
  au                  = var.au                  # "0212345"
  additional_tags     = var.rg_additional_tags  # Additional tags for the Resource Group

  add_random          = true
  rnd_length          = 3
}
```

## Documentation
<!-- markdownlint-disable MD033 -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.89.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bbl_rg_name"></a> [bbl\_rg\_name](#module\_bbl\_rg\_name) | app.terraform.io/msftbbldeo/bbl-module/azurerm | ~>1.0.2 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_au"></a> [au](#input\_au) | (Required) bbl Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters. | `string` | n/a | yes |
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | (Required) Application/Infrastructure "base" name. Example: `aks`. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) bbl environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Required) bbl technology owner group. | `string` | n/a | yes |
| <a name="input_add_random"></a> [add\_random](#input\_add\_random) | (Optional) When set to `true`, the end of the Resource Group name will be randomized. | `bool` | `false` | no |
| <a name="input_additional_name"></a> [additional\_name](#input\_additional\_name) | (Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the "name's generated" suffix. Example: `lan1`. | `string` | `null` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | (Optional) Resource group additional Tags. | `map(string)` | `null` | no |
| <a name="input_country"></a> [country](#input\_country) | (Optional) bbl country code. Example: `us`. | `string` | `"us"` | no |
| <a name="input_iterator"></a> [iterator](#input\_iterator) | (Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the "name's generated + additional\_name" concatenation. Example: `001`. | `string` | `null` | no |
| <a name="input_org"></a> [org](#input\_org) | (Optional) bbl organization code. Example: `bbl`. | `string` | `"bbl"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | (Optional) bbl region code.<br></br>&#8226; Value of `region_code` must be one of: `[sea,ea]`. | `string` | `"sea"` | no |
| <a name="input_rnd_length"></a> [rnd\_length](#input\_rnd\_length) | (Optional) Set the length of the `random_number` generated. | `number` | `2` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Resource group Id. |
| <a name="output_location"></a> [location](#output\_location) | Resource group location. |
| <a name="output_name"></a> [name](#output\_name) | Resource group name. |
| <a name="output_random_suffix"></a> [random\_suffix](#output\_random\_suffix) | Randomized piece of the Resource group name when "`add_random = true`". |
| <a name="output_tags"></a> [tags](#output\_tags) | Resource group tags. |

<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
# Log Analytics Workspace module

## Overview

This Terraform module creates a Log Analytics Workspace in Azure.

A Log Analytics workspace is a unique environment for Azure Monitor log data. Each workspace has its own data repository, configuration and data sources. Solutions are configured to store their data in a particular workspace.

It can also be used to edit and run log queries with data in Azure Monitor Logs. Writing a simple query can return a set of records and then use features of Log Analytics to sort, filter, and analyze them.

## Notes

- Network Isolation feature with Azure Monitor Private Link Service (AMPLS) will be created with a separate module.
- For security lock down purposes, both public internet ingestion and query are disabled. The only way to access the Workspace is then through the AMPLS.


## Security Controls

- PR-030, PR-031 Landing Zone: Naming Conventions.
- PR-001, PR-006 Cloud Management Plane: The monitored logs get stored in Log Analytics workspace. BBL will have one central Log Analytics workspace per region for the Platform Landing Zone/MVP 1.0.

## Security Decisions

- ID 3057 SEC-04: Azure Monitor: Platform Logs will be Archived to Blob Storage After 90 Days : will be enabled using diagnostic-log terraform module.
- ID 2401 SEC-05: Centralized Log Analytics Workspaces Will Use Microsoft-Managed Keys : enabled.
- ID 3887 SEC-19: 2 Centralized Log Analytics Workspaces Will Be Deployed and Use AMPLS :  will be enabled using AMPLS terraform module.

## Example

```yaml
#--------------------------------------------
#   Creating Log Analytics Workspace
#--------------------------------------------
module "bbl_law_test" {
  # Local use
  source = "../../terraform-azurerm-law"

  depends_on = [
    module.bbl_rg_test
  ]

  resource_group_name = module.bbl_rg_test.name
  org                 = var.org
  country             = var.country
  env                 = var.env
  au                  = var.au
  owner               = var.owner
  region_code         = var.region_code
  base_name           = var.law_base_name
  additional_name     = var.law_additional_name
  additional_tags     = var.law_additional_tags
  add_random          = "true"
  rnd_length          = 3
  iterator            = var.iterator

  sku               = var.sku
  retention_in_days = var.retention_in_days
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
| <a name="module_bbl_law_name"></a> [bbl\_law\_name](#module\_bbl\_law\_name) | app.terraform.io/msftbbldeo/bbl-module/azurerm | ~>1.0.2 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_au"></a> [au](#input\_au) | (Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters. | `string` | n/a | yes |
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | (Required) Application/Infrastructure "base" name. Example: `aks`. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) BBL environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Required) BBL technology owner group. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the Resource Group in which to create the Log Analytics Workspace. | `string` | n/a | yes |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | (Required) The workspace level data retention in days. Possible values range between `30` and `730 (2 years)`. | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | (Required) Specifies the SKU of the Log Analytics Workspace. Possible values are `Free`, `PerNode`, `Premium`, `Standard`, `Standalone`, `Unlimited`, and `PerGB2018`. | `string` | n/a | yes |
| <a name="input_add_random"></a> [add\_random](#input\_add\_random) | (Optional) When set to `true`,  it will add a `rnd_length`'s long `random_number` at the name's end of the Log Analytics Workspace. | `bool` | `false` | no |
| <a name="input_additional_name"></a> [additional\_name](#input\_additional\_name) | (Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the "name's generated" suffix. Example: `lan1`. | `string` | `null` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | (Optional) Additional tags for the Log Analytics Workspace. | `map(string)` | `null` | no |
| <a name="input_country"></a> [country](#input\_country) | (Optional) BBL country code. Example: `us`. | `string` | `"us"` | no |
| <a name="input_daily_quota_gb"></a> [daily\_quota\_gb](#input\_daily\_quota\_gb) | (Optional) The workspace daily quota for ingestion in `GB`. The default value `-1` indicates `unlimited` | `number` | `-1` | no |
| <a name="input_iterator"></a> [iterator](#input\_iterator) | (Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the "name's generated + additional\_name" concatenation. Example: `001`. | `string` | `null` | no |
| <a name="input_org"></a> [org](#input\_org) | (Optional) BBL organization code. Example: `bbl`. | `string` | `"bbl"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | (Optional) BBL region code.<br></br>&#8226; Value of `region_code` must be one of: `[ncus,scus]`. | `string` | `"ncus"` | no |
| <a name="input_reservation_capacity_in_gb_per_day"></a> [reservation\_capacity\_in\_gb\_per\_day](#input\_reservation\_capacity\_in\_gb\_per\_day) | (Optional) The capacity reservation level in `GB` for this workspace. Must be in increments of `100` between `100` and `5000`. | `number` | `100` | no |
| <a name="input_rnd_length"></a> [rnd\_length](#input\_rnd\_length) | (Optional) Set the length of the `random_number` generated. | `number` | `2` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_workspace.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_daily_quota_gb"></a> [daily\_quota\_gb](#output\_daily\_quota\_gb) | The workspace daily quota for ingestion in GB. |
| <a name="output_id"></a> [id](#output\_id) | The Resource ID of the Log Analytics Workspace. |
| <a name="output_name"></a> [name](#output\_name) | Specifies the name of the Log Analytics Workspace. |
| <a name="output_primary_shared_key"></a> [primary\_shared\_key](#output\_primary\_shared\_key) | The Primary shared key for the Log Analytics Workspace. |
| <a name="output_random_suffix"></a> [random\_suffix](#output\_random\_suffix) | Randomized piece of the Log analytics workspace name when "`add_random = true`". |
| <a name="output_retention_in_days"></a> [retention\_in\_days](#output\_retention\_in\_days) | The workspace data retention in days. |
| <a name="output_secondary_shared_key"></a> [secondary\_shared\_key](#output\_secondary\_shared\_key) | The Secondary shared key for the Log Analytics Workspace. |
| <a name="output_sku"></a> [sku](#output\_sku) | The Sku of the Log Analytics Workspace. |
| <a name="output_workspace_id"></a> [workspace\_id](#output\_workspace\_id) | The Workspace (or Customer) ID for the Log Analytics Workspace. |

<!-- END_TF_DOCS -->
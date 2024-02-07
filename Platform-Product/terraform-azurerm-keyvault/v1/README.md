<!-- BEGIN_TF_DOCS -->
# Key vault with Azure role-based access control (RBAC) module

## Overview

This terraform module creates an Azure Key vault and associated resources. Azure Key vault is a cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys. This module also enables to grant permissions to user and groups to read and modify the secrets in Key vault.

## Notes

- This module creates the `Key vault` with `RBAC` role enabled.

- Please look in [documentation](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli) for the available built-in `RBAC` roles for `Key vault`.

- The **Service Principal/User** running this Terraform plan/workspace needs to have **equivalent** or **more than** of the "`User Access Administrator`" role to assign the roles using this module for managing `Key vault`. It allows the use of the `bbl-role-assignment` module to assign the "`Key vault Administrator`" role to the **Service Principal/User** running this Terraform plan/workspace.

- This module do not deploy an associated Private Endpoint for the Key vault resource. To create a Private Endpoint for this Key vault, use the `bbl-privateendpoints` module after the Key vault creation.

- This module do not have any **Integration with CCKM**. CCKM will register and interact with this Key vault after its creation.

- For testing purposes, the **Networking | Firewall** Allow access from "Selected networks" and public "IP address or CIDR" defined in the variable `network_acls.ip_rules`. This setting should be adjusted when deploying a Key vault in BBL's Azure.

## Security controls

- PR-030, PR-031 Landing Zone: Standardize Naming Conventions for Tags.
- PR-002 Cloud Management Plane : Key Vault firewall to restrict traffic and disable public network access to key-vault.
- PR-033, PR-034, PR-035, PR-039 Data Protection : Premium tier support uses HSM-backed keys where keys can be imported or generated.
- PR-09, PR-010, PR-011, PR-012 IAM : Use the principle of least privilege to grant access. Access to the Key Vault will be controlled by Azure RBAC.
- PR-026, PR-027, PR-028, PR-029 IAM : Azure Key Vault provides secure storage for sensitive information like keys, secrets, certificates.

## Security decisions

- ID 3065 SEC-02 : Secrets, Certificates and Keys will Use the Same Azure Key Vaults : enabled
- ID 2401 SEC-05: Centralized Log Analytics Workspaces Will Use Microsoft-Managed Keys : will be enabled using centralized Log Analytics workspace terraform module
- ID 3788 SEC-13 : Azure Key Vault Will Be Integrated with CipherTrust Cloud Key Manager (CCKM) : enabled
- ID 3789 SEC-14 : All Keys Provisioned for Azure Services will be HSM-Protected : enabled
- ID 3868 SEC-18 : Azure Key Vault will Use RBAC for Data Plane Authorization : enabled
- ID 4211 SEC-31 : Azure Key Vault Logging/Monitoring : will be enabled using diagnostic terraform module
- ID 4212 SEC-32 : Azure Key Vault Soft-Delete and Purge Protection : enabled
- ID 4243 SEC-35: Azure Key Vaults Will Use Private Endpoints : will be enabled using private endpoint terraform module

## Example

```yaml
#----------------------
# - Creating Key Vault
#----------------------
module "bbl_kv" {
  # Terraform local use
  source = "../../terraform-azurerm-module/v1"

  depends_on = [
    module.bbl_rg
  ]

  # Key Vault naming Variables
  org             = var.org
  country         = var.country
  env             = var.env
  au              = var.au
  owner           = var.owner
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.kv_additional_name
  add_random      = true
  rnd_length      = var.rnd_length
  additional_tags = var.kv_additional_tags
  iterator        = var.iterator

  # Key Vault variables
  resource_group_name             = module.bbl_rg.name
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  secrets      = var.secrets
  network_acls = var.network_acls
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
| <a name="module_bbl_kv_name"></a> [bbl\_kv\_name](#module\_bbl\_kv\_name) | app.terraform.io/msftbbldeo/bbl-module/azurerm | ~>1.0.2 |
| <a name="module_bbl_kv_rbac"></a> [bbl\_kv\_rbac](#module\_bbl\_kv\_rbac) | app.terraform.io/msftbbldeo/bbl-role-assignment/azurerm | ~>1.0.1 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_au"></a> [au](#input\_au) | (Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters. | `string` | n/a | yes |
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | (Required) Application/Infrastructure "base" name. Example: `aks`. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) BBL environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Required) BBL technology owner group. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the Resource Group in which to create the Key vault. | `string` | n/a | yes |
| <a name="input_add_random"></a> [add\_random](#input\_add\_random) | (Optional) When set to `true`, it will add a `rnd_length`'s long `random_number` at the name's end. | `bool` | `false` | no |
| <a name="input_additional_name"></a> [additional\_name](#input\_additional\_name) | (Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the "name's generated" suffix. Example: `lan1`. | `string` | `null` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | (Optional) Additional Key Vault resources tags, in addition to the resource group tags | `map(string)` | `null` | no |
| <a name="input_country"></a> [country](#input\_country) | (Optional) BBL country code. Example: `us`. | `string` | `"us"` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | (Optional) Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `bool` | `false` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | (Optional) Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `false` | no |
| <a name="input_enabled_for_template_deployment"></a> [enabled\_for\_template\_deployment](#input\_enabled\_for\_template\_deployment) | (Optional) Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| <a name="input_iterator"></a> [iterator](#input\_iterator) | (Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the "name's generated + additional\_name" concatenation. Example: `001`. | `string` | `null` | no |
| <a name="input_network_acls"></a> [network\_acls](#input\_network\_acls) | (Optional) Networking settings for the Key Vault:<br></br><ul><li>`default_action`: (Required) The Default Action to use when no rules match ip\_rules / virtual\_network\_subnet\_ids. Possible values are `"Allow"` and `"Deny"`,</li><li>`bypass`: (Optional) Specifies whether traffic is bypassed for None/AzureServices. Valid options are either of [`"AzureServices"`, `"None"`],</li><li>`ip_rules`: (Optional) One or more <b>Public IP Addresses or CIDR Blocks</b> which should be able to access the Key Vault,</li><li>`virtual_network_subnet_ids`: (Optional) One or more Subnet IDs which should be able to access the Key Vault.</li></ul> | <pre>object({<br>    bypass                     = string<br>    default_action             = string<br>    ip_rules                   = list(string)<br>    virtual_network_subnet_ids = list(string)<br>  })</pre> | `null` | no |
| <a name="input_org"></a> [org](#input\_org) | (Optional) BBL organization code. Example: `bbl`. | `string` | `"bbl"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | (Optional) BBL region code.<br></br>&#8226; Value of `region_code` must be one of: `[ncus,scus]`. | `string` | `"ncus"` | no |
| <a name="input_rnd_length"></a> [rnd\_length](#input\_rnd\_length) | (Optional) Set the length of the `random_number` generated. | `number` | `3` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | (Optional) A map of secrets for the Key Vault | `map(string)` | `{}` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Key Vault. |
| <a name="output_name"></a> [name](#output\_name) | The Name of the Key Vault. |
| <a name="output_random_suffix"></a> [random\_suffix](#output\_random\_suffix) | Randomized piece of the Keyvault name when "`add_random = true`". |
| <a name="output_vault_uri"></a> [vault\_uri](#output\_vault\_uri) | The URI of the Key Vault, used for performing operations on keys and secrets. |

<!-- END_TF_DOCS -->
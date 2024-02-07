# Key vault with Azure role-based access control (RBAC) module

## Overview

This terraform module creates an Azure Key vault and associated resources. Azure Key vault is a cloud service for securely storing and accessing secrets. A secret is anything that you want to tightly control access to, such as API keys, passwords, certificates, or cryptographic keys. This module also enables to grant permissions to user and groups to read and modify the secrets in Key vault.

## Notes

- This module creates the `Key vault` with `RBAC` role enabled.

- Please look in [documentation](https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide?tabs=azure-cli) for the available built-in `RBAC` roles for `Key vault`.

- The **Service Principal/User** running this Terraform plan/workspace needs to have **equivalent** or **more than** of the "`User Access Administrator`" role to assign the roles using this module for managing `Key vault`. It allows the use of the `bbl-role-assignment` module to assign the "`Key vault Administrator`" role to the **Service Principal/User** running this Terraform plan/workspace.

- This module do not deploy an associated Private Endpoint for the Key vault resource. To create a Private Endpoint for this Key vault, use the `bbl-privateendpoints` module after the Key vault creation.

- This module implements the Azure BBL Design Decisions known as of Jan. 21st, 2022. The SED work in progress will incur refactoring of this module later to match updated Design Decisions.

- This module do not have any **Integration with CCKM**. CCKM will register and interact with this Key vault after its creation.

- For testing purposes, the **Networking | Firewall** Allow access from "Selected networks" and public "IP address or CIDR" defined in the variable `network_acls.ip_rules`. This setting should be adjusted when deploying a Key vault in BBL's Azure.

## Security Controls

- PR-030, PR-031 Landing Zone: Standardize Naming Conventions for Tags.
- PR-002 Cloud Management Plane : Key Vault firewall to restrict traffic and disable public network access to key-vault.
- PR-033, PR-034, PR-035, PR-039 Data Protection : Premium tier support uses HSM-backed keys where keys can be imported or generated.
- PR-09, PR-010, PR-011, PR-012 IAM : Use the principle of least privilege to grant access. Access to the Key Vault will be controlled by Azure RBAC.
- PR-026, PR-027, PR-028, PR-029 IAM : Azure Key Vault provides secure storage for sensitive information like keys, secrets, certificates. 

## Security Decisions

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
  source =  "../../terraform-azurerm-module/v1"

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

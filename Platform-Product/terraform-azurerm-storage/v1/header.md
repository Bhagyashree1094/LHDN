# Storage Module

## Overview

This Terraform module creates a Storage account in Azure.
An Azure storage account contains all the Azure Storage data objects: blobs, file shares, queues, tables, and disks.
The storage account provides a unique namespace for Azure Storage data that's accessible from anywhere in the world over HTTPS.
Data in a storage account is durable, highly available, secure, and massively scalable.

## Notes

- Changing the `account_kind` value from `Storage` to `StorageV2` will not trigger a force new on the storage account, it will only upgrade the existing storage account from `Storage` to `StorageV2` keeping the existing storage account in place.
- Blobs with a tier of `Premium` are of account kind `StorageV2`.
- `queue_properties` cannot be set when the `account_kind` is set to `BlobStorage`,
- To use `customer managed key` encryption, set variable `cmk_enabled` to true,
- To store storage account `access key` in `key vault` set variable `persist_access_key` to `true`.


## Security Controls

- PR-030, PR-031 Conventions: Name resources accordingly
- PR-036, PR-037, PR-038 Data Protection: Azure Storage encryption is enabled for all storage accounts by default. Data in Azure Storage is encrypted and decrypted transparently using AES encryption and is FIPS 140-2 compliant. By requiring secure transfer for the storage account, all requests to the storage account must be made over HTTPS. Any requests made over HTTP are rejected.
- PR-038, PR-150, PR-040 Encryption in transit: Blob storage supports TLS 1.2 and provides encryption for data in Transit
- PR-033, PR-034 Data Protection: Protect data in Storage account using Customer-managed keys in associated Key-Vault or Managed HSM.
- PR-051, PR-052, PR-054 Infrastructure Protection: Block Internet access and restrict network connectivity to the Storage account via the Storage firewall and access the data objects in the Storage account via Private Endpoint which secures all traffic between VNet and the storage account over a Private Link.
- PR-112 Inventory: Blob storage has an inventory capability

## Security Decisions

- ID 4206 RAID 4206: SEC-26: Azure Blob Storage Will Use Microsoft-Managed Keys in MVP 1.0: Terraform code has the capability to use both Microsoft Managed Key (MMK) and Customer Managed Key (CMK)
- ID 4207 RAID 4207: SEC-27: Azure Blob Storage Will Use Immutable Storage Policies for Platform Logs: Terraform does not support immutable storage account as of now
- ID 4208 SEC-28: Azure Blob Storage Security Settings: Error in terraform code for while using Azure Active Directory (Azure AD) to authorize access to blob data and Disallowing Shared Key authorization - use Azure AD for authorization, SAS where required
- ID 4209 SEC-29: Azure Blob Storage Data Protection Settings: available in storage module
- ID 4210 SEC-30: Azure Blob Storage Logging/Monitoring: will be enabled using Terraform Diagnostic Logs module
- ID 4242 RAID 4242: SEC-34: Azure Storage Accounts Will Use Private Endpoints: will be enabled using Terraform Private Endpoints module

## Example

```yaml
#------------------------------------------
#  - Creating 1st storage account in RG #1
#------------------------------------------
module "bbl_st1" {
  # Local use
  source = "../../terraform-azurerm-storage/v1"

  # Terraform Cloud/Enterprise use
  #source  = "app.terraform.io/msftbbldeo/bbl-storage/azurerm"
  #version = "~>2.0.0"

  depends_on = [
    module.bbl_rg
  ]

  # Storage Account naming
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name

  au      = var.au
  country = var.country
  org     = var.org
  owner   = var.owner

  add_random = true
  rnd_length = 2

  # Delete during bbl intake process
  iterator = var.iterator

  # Storage Account settings
  resource_group_name = module.bbl_rg.name
  key_vault_id        = module.bbl_kv.id

  is_log_storage      = false
  persist_access_key  = true
  assign_identity     = true
  cmk_enabled         = true

  containers          = var.st1_containers
  blobs               = var.st1_blobs
  queues              = var.st1_queues
  file_shares         = var.st1_file_shares
  tables              = var.st1_tables

  network_rules       = local.st_network_acls
}
```

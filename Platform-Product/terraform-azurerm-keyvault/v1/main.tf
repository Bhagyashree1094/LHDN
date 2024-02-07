#-------------------------------
# - Dependencies data resources
#-------------------------------
# # RG in which to create the Key vault
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}
# Current user to assign to the "Key Vault Administrator" role
data "azurerm_client_config" "this" {}

#-------------------------------------------------- 
# - Generate the Key Vault name with lhdn module
#--------------------------------------------------
# PR-030, PR-031 Landing Zone: Standardize Naming Conventions for Tags.
module "lhdn_kv_name" {
  
  # Terraform Local use
  source = "../../terraform-azurerm-module/v1"


  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  # Key vault specifics settings
  resource_type_code = "kv"
  max_length         = 24
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

#-------------------------------------------
# - Generate the locals for KV Network ACLs
#-------------------------------------------
locals {
  # PR-002 Cloud Management Plane : Key Vault firewall to restrict traffic and disable public network access to key-vault.
  default_network_acls = {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }

  merged_network_acls = var.network_acls != null ? merge(local.default_network_acls, var.network_acls) : null

  kv_name = replace(module.lhdn_kv_name.name, "--", "-")

  # PR-030, PR-031 Landing Zone: Standardize Naming Conventions for Tags.
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.lhdn_kv_name.tags,
    var.additional_tags
  )
}

#-------------------
# - Setup key vault 
#-------------------
resource "azurerm_key_vault" "this" {
  name                = local.kv_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = module.lhdn_kv_name.location
  tenant_id           = data.azurerm_client_config.this.tenant_id

  # PR-033, PR-034, PR-035, PR-039 Data Protection : Premium tier support uses HSM-backed keys where keys can be imported or generated.
  sku_name                        = "premium"
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  # PR-09, PR-010, PR-011, PR-012 IAM : Use the principle of least privilege to grant access. Access to the Key Vault will be controlled by Azure RBAC.
  enable_rbac_authorization = true

  purge_protection_enabled   = true
  soft_delete_retention_days = "90"

  dynamic "network_acls" {
    for_each = local.merged_network_acls == null ? [local.default_network_acls] : [local.merged_network_acls]
    content {
      bypass                     = network_acls.value.bypass
      default_action             = network_acls.value.default_action
      ip_rules                   = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = local.tags
}

# --------------------------------------------------------------------------------------
# - Assigning Key Vault Administrator to this/self SPN using lhdn-role-assignment module
# --------------------------------------------------------------------------------------
module "lhdn_kv_rbac" {
  source = "../../terraform-azurerm-role-assignment/v1"

  depends_on = [
    azurerm_key_vault.this
  ]

  principal_id         = data.azurerm_client_config.this.object_id
  role_definition_name = "Key Vault Administrator"
  scope                = azurerm_key_vault.this.id
}

#-------------------------
# - Add Key Vault Secrets
#-------------------------
# PR-026, PR-027, PR-028, PR-029 IAM : Azure Key Vault provides secure storage for sensitive information like keys, secrets, certificates.
resource "azurerm_key_vault_secret" "this" {

  key_vault_id = azurerm_key_vault.this.id
  tags         = local.tags

  for_each = var.secrets
  name     = each.key
  value    = each.value
}
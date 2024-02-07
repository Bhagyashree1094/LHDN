data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# data "azurerm_key_vault" "this" {
#   resource_group_name = split("/", var.key_vault_id)[4]
#   name                = split("/", var.key_vault_id)[8]
# }


# --------------------------------------
# - Get the current user/app config
# -------------------------------------
data "azurerm_client_config" "current" {}

# ---------------------------------------
# - Generate the ACR name
# ---------------------------------------
module "bbl_acr_name" {


   source = "../../terraform-azurerm-module/v1"

  # BBL ordered naming inputs
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  # au              = var.au
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  # product_version = var.product_version

  # kubernetes-cluster specifics settings
  resource_type_code = "acr"
  max_length         = 50
  no_dashes          = true
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

# 
# - Generate the locals
# 
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_acr_name.tags,
    var.additional_tags
  )
}

#----------------------------------------------------------------------------
# - Create the User assigned identity from the bbl-user-assigned-identity module
#----------------------------------------------------------------------------
module "bbl_uai" {

  source = "../../terraform-azurerm-user-assigned-identity/v1"

  resource_group_name = data.azurerm_resource_group.this.name
  name                = module.bbl_acr_name.name
  additional_tags     = module.bbl_acr_name.tags

}


#------------------------------------------------------------------
# - Create Role Assignment for UAI from the bbl-role-assignment module
#------------------------------------------------------------------
# module "bbl_rbac" {

# source = "../../terraform-azurerm-role-assignment/v1"

#   principal_id         = module.bbl_uai.principal_id
#   role_definition_name = "Key Vault Crypto Service Encryption User"
#   scope                = data.azurerm_key_vault.this.id

#   description = "Assigning the `Key Vault Crypto Service Encryption User` role to the User-managed identity to allow its access to the key vault keys."
# }

#-------------------------------------------------
# - Create CMK Key for Azure Container Registry
#-------------------------------------------------

# resource "azurerm_key_vault_key" "this" {
#   name         = format("%s-key", lower(module.bbl_acr_name.name))
#   key_vault_id = data.azurerm_key_vault.this.id
#   key_type     = "RSA"
#   key_size     = 4096

#   key_opts = [
#     "decrypt", "encrypt", "sign",
#     "unwrapKey", "verify", "wrapKey"
#   ]
# }



#####################################################
# Creation of Azure container registry
#####################################################

resource "azurerm_container_registry" "this" {

  # depends_on = [ module.bbl_rbac ]

  name                = lower(module.bbl_acr_name.name)
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  sku                 =  var.sku_acr
  admin_enabled       = var.admin_enabled

  quarantine_policy_enabled  = var.quarantine_policy_enabled
  anonymous_pull_enabled     = var.anonymous_pull_enabled
  data_endpoint_enabled      = var.data_endpoint_enabled
  network_rule_bypass_option = var.network_rule_bypass_option


  identity {
    type = "UserAssigned"
    identity_ids = [
      module.bbl_uai.id
    ]
  }
    network_rule_set {
    default_action = "Allow" # Default = Allow
  }
  # encryption {
  #   enabled            = true
  #   key_vault_key_id   = azurerm_key_vault_key.this.id
  #   identity_client_id = module.bbl_uai.client_id
  # }

  tags = local.tags
}
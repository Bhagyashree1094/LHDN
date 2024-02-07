#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# RG Variables
variable "org" {}
variable "country" {}
variable "env" {}
variable "region_code" {}
variable "base_name" {}
#variable "rg_additional_name" {}
variable "au" {}
variable "owner" {}
variable "rg_additional_tags" { default = null }


# Private Endpoints variables: When not integrating with other modules
# variable "private_endpoints" {
#   type = map(object({
#     name                      = string
#     subnet_id                 = string
#     group_ids                 = list(string)
#     approval_required         = bool
#     approval_message          = string
#     private_connection_address_id = string
#   }))
#   description = "Map containing Private Endpoint details"
#   default     = {}
# }

#-
#- Key Vault variables
#-
variable "kv_additional_name" {}
variable "kv_additional_tags" { default=null}
variable "randomize_name" {}
variable "rnd_length" {}
variable "sku_name" {}
variable "enabled_for_deployment" {}
variable "enabled_for_disk_encryption" {}
variable "enabled_for_template_deployment" {}
variable "purge_protection_enabled" {}
variable "tf_client_object_id" {}

variable "access_policies" {
  type = map(object({
    group_names             = list(string)
    object_ids              = list(string)
    user_principal_names    = list(string)
    certificate_permissions = list(string)
    key_permissions         = list(string)
    secret_permissions      = list(string)
    storage_permissions     = list(string)
  }))
}
variable "secrets" {
  type = map(string)
}
variable "network_acls" {
  type = object({
    bypass                     = string       # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
    default_action             = string       # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
    ip_rules                   = list(string) # (Optional) One or more IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
    virtual_network_subnet_ids = list(string) # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
  })
  default = null
}

# 
#  Storage account variables
# 
variable "st_additional_name" { default = null }
variable "st_additional_tags" {default=null}
variable "st_containers" { default = {} }
variable "st_blobs" { default = {} }
variable "st_queues" { default = {} }
variable "st_file_shares" { default = {} }
variable "st_tables" {}
variable "st_network_rules" { default = {} }

#
# Private Endpoint Variables
#
variable "pe_subnet_id" {}
variable "pe_approval_required" {}

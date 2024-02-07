#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
# - BBL Variables
# -
variable "org" {}
variable "country" {}
variable "env" {}
variable "base_name" {}
variable "au" {}
variable "owner" {}
variable "iterator" {}
variable "region_code" {}
variable "rg_additional_tags" {}
variable "rg_additional_name" {}
variable "product_version" {}

# Key Vault variables
variable "kv_additional_name" {}
variable "add_random" {}
variable "rnd_length" {}
variable "enabled_for_deployment" {}
variable "enabled_for_disk_encryption" {}
variable "enabled_for_template_deployment" {}

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

variable "kv_additional_tags" {
  default = null
}


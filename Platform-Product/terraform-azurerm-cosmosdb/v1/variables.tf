
#--------------------------
# - Dependencies Variables
#--------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group in which to create the CosmosDB."
}

#-------------------------------
# - BBL required values
#-------------------------------
variable "env" {
  type        = string
  description = "(Required) BBL environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`."
  validation {
    condition     = contains(["nonprod", "prod", "core", "int", "uat", "stage", "dev", "test"], var.env)
    error_message = "Value of \"env\" must be one of: [nonprod,prod,core,int,uat,stage,dev,test]."
  }
}
variable "base_name" {
  type        = string
  description = "(Required) Application/Infrastructure \"base\" name. Example: `aks`."
  default     = null
}
variable "au" {
  type        = string
  description = "(Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters."
  validation {
    condition     = can(regex("^[[:digit:]]+$", var.au))
    error_message = "Value for \"au\" must be of numeric characters."
  }
}
variable "owner" {
  type        = string
  description = "(Required) BBL technology owner group."
}

variable "app_code" {
  type        = string
  description = "(Required) Application code. Example: network, mgmt, buil"
}

variable "bu" {
  type        = string
  description = "(Required) Bussiness unit code. Example: IT or BBL."
}


variable "product_version" {
  type        = string
  description = "(Required) BBL product_version."
}

#----------------------
# - Optional Variables
#----------------------
variable "org" {
  type        = string
  description = "(Optional) BBL organization code. Example: `bbl`."
  default     = "bbl"
}
variable "country" {
  type        = string
  description = "(Optional) BBL country code. Example: `bkk`."
  default     = "bkk"
}
variable "region_code" {
  type        = string
  description = "(Optional) BBL region code.<br></br>&#8226; Value of `region_code` must be one of: `[sea,ea]`."
  validation {
    condition     = contains(["sea", "ea"], var.region_code)
    error_message = "Value of region_code must be one of: [sea,ea]."
  }
  default = "sea"
}

# Name tuning variables
variable "additional_name" {
  type        = string
  description = "(Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the \"name's generated\" suffix. Example: `lan1`."
  default     = null
}
variable "iterator" {
  type        = string
  description = "(Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the \"name's generated + additional_name\" concatenation. Example: `001`."
  default     = null
}
variable "add_random" {
  type        = bool
  description = "(Optional) When set to `true`,  it will add a `rnd_length`'s long `random_number` at the name's end of the CosmosDB."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 2
}
variable "additional_tags" {
  description = "(Optional) Additional tags for the CosmosDB."
  type        = map(string)
  default     = null
}

# CosmosDB variables
variable "offer_type" {
  description = "(Required) Specifies the offer type to use for the CosmosDB account. (Required)"
  type        = string
}

variable "kind" {
  description = "(Optional) The kind of the CosmosDB to deploy. Defaults to 'GlobalDocumentDB'."
  type        = string
  default     = "GlobalDocumentDB"
}

variable "enable_free_tier" {
  description = "(Optional) Enables the Free Tier for the CosmosDB account. Defaults to false."
  type        = bool
  default     = false
}

variable "ip_range_filter" {
  description = "(Optional) The IP range filter to use for the CosmosDB account."
  type        = string
  default     = null
}

variable "enable_multiple_write_locations" {
  description = "(Optional) Enable multiple write locations for the CosmosDB account. Defaults to false."
  type        = bool
  default     = false
}

variable "enable_automatic_failover" {
  description = "(Optional) Enable automatic failover for the CosmosDB account."
  type        = bool
  default     = null
}

variable "is_virtual_network_filter_enabled" {
  description = "(Optional) Whether or not a virtual network filter is enabled for this CosmosDB account."
  type        = bool
  default     = null
}

variable "create_mode" {
  description = "(Optional) The create mode of the CosmosDB account."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "(Optional) Indicates whether public network access is enabled for this CosmosDB account. Defaults to true."
  type        = bool
  default     = true
}

variable "access_key_metadata_writes_enabled" {
  description = "(Optional) Indicates whether metadata writes are enabled on the account keys. (Optional)"
  type        = bool
  default     = null
}

variable "local_authentication_disabled" {
  description = "(Optional) Indicates whether local authentication is disabled. (Optional)"
  type        = bool
  default     = null
}

variable "analytical_storage_enabled" {
  description = "(Optional) Indicates whether analytical storage feature is enabled. (Optional)"
  type        = bool
  default     = null
}

variable "bypass_for_azure_services_enabled" {
  description = "(Optional) Specifies whether Azure Services are bypassed by the network ACLs."
  type        = bool
  default     = null
}

variable "network_acl_bypass_ids" {
  description = "(Optional) Specifies the resource IDs for which network ACLs are bypassed."
  type        = list(string)
  default     = null
}

variable "consistency_policy" {
  description = "(Required) Specifies the consistency policy for the CosmosDB account. (Required)"
  type        = map(any)
  default     = {}
}

variable "geo_locations" {
  description = "(Required) An array of geo-locations for the CosmosDB account. (Required)"
  type        = list(map(any))
}

variable "cors_rule" {
  description = "(Optional) Specifies the CORS rule for the CosmosDB account."
  type        = map(any)
  default     = null
}

variable "capabilities" {
  description = "(Optional) Specifies the capabilities for the CosmosDB account."
  type        = list(string)
  default     = []
}

variable "database" {
  description = "(Optional) The database configuration to import"
  type        = list(map(any))
  default     = []
}

variable "restore" {
  description = "(Optional) Specifies the restore properties for the CosmosDB account."
  type        = map(any)
  default     = null
}

variable "total_throughput_limit" {
  description = "(Optional) Specifies the total throughput limit for the CosmosDB account."
  type        = number
  default     = null
}

variable "backup" {
  description = "(Optional) Specifies the backup settings for the CosmosDB account."
  type        = map(any)
  default     = null
}

variable "identity_type" {
  description = "(Optional) Specifies the identity type for the CosmosDB account."
  type        = string
  default     = null
}

variable "analytical_storage_type" {
  description = "(Optional) Specifies the analytical storage type for the CosmosDB account."
  type        = string
  default     = null
}

variable "virtual_network_rule" {
  description = "(Optional) Specifies the virtual network rules for the CosmosDB account."
  type        = list(map(any))
  default     = null
}

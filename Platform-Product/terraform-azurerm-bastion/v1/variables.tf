#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------------
# - Dependencies Variables
#-------------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group in which to create the virtual network."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) Name of the Virtual Wan in which connection need to be established.."
}

#------------------------------
# - Required Variables
#------------------------------
# - BBL required values
variable "env" {
  type        = string
  description = "(Required) bbl environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`."
  validation {
    condition     = contains(["nonprod", "prod", "core", "int", "uat", "stage", "dev", "test"], var.env)
    error_message = "Value of \"env\" must be one of: [nonprod,prod,core,int,uat,stage,dev,test]."
  }
}
variable "base_name" {
  type        = string
  description = "(Required) Application/Infrastructure \"base\" name. Example: `aks`."
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

variable "product_version" {
  type        = string
  description = "(Required) BBL product version. Example: `1.0.0`."
}

variable "app_code" {
  type        = string
  description = "(Required) Application code. Example: network, mgmt, buil"
}

variable "bu" {
  type        = string
  description = "(Required) Bussiness unit code. Example: IT or BBL."
} 

# Module required variables

#----------------------
# - Optional Variables
#----------------------
variable "org" {
  type        = string
  description = "(Optional) BBLorganization code. Example: `BBL`."
  default     = "BBL"
}
variable "country" {
  type        = string
  description = "(Optional) BBLcountry code. Example: `bkk`."
  default     = "bkk"
}

variable "region_code" {
  type        = string
  description = "(Optional) bbl region code.<br></br>&#8226; Value of `region_code` must be one of: `[ea,sea]`."
  validation {
    condition     = contains(["ea", "sea"], var.region_code)
    error_message = "Value of \"region_code\" must be one of: [ea,sea]."
  }
  default     = "sea"
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
variable "additional_tags" {
  description = "(Optional) Additional tags for the virtual network."
  type        = map(string)
  default     = null
}
variable "add_random" {
  type        = bool
  description = "(Optional) When set to `true`,  it will add a `rnd_length`'s long `random_number` at the name's end."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 2
}

# Module optional variables
#   
#-------------------------------
# - Azure Bastion variables
#-------------------------------
variable "subnet_address_prefix" {
  type        = string
  description = "(Required) IPv4 CIDR for the Azure Bastion subnet. The `subnet_address_prefix` mask must be **`/26`** or larger (/25, /24, etc.). Example: `\"10.1.1.0/26\"`."
}
variable "scale_units" {
  type        = number
  description = "(Optional) Number of Scale units to allocate."
  default     = 5
}
variable "copy_paste_enabled" {
  type        = bool
  description = "(Optional) Enable clipboard copy/paste."
  default     = true
}

variable "file_copy_enabled" {
  type        = bool
  description = "(Optional) Enable file copy/paste."
  default     = false
}
variable "ip_connect_enabled" {
  type        = bool
  description = "(Optional) Enable IP connect."
  default     = false
}
variable "shareable_link_enabled" {
  type        = bool
  description = "(Optional) Enable Shareable link."
  default     = false
}
variable "tunneling_enabled" {
  type        = bool
  description = "(Optional) Enable Tunneling."
  default     = true
}


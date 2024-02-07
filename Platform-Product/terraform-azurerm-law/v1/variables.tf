#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#


# -
# Required Variables
# -

#--------------------------
# - Dependencies Variables
#--------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group in which to create the Log Analytics Workspace."
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
}
# variable "au" {
#   type        = string
#   description = "(Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters."
#   validation {
#     condition     = can(regex("^[[:digit:]]+$", var.au))
#     error_message = "Value for \"au\" must be of numeric characters."
#   }
# }
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


# variable "product_version" {
#   type        = string
#   description = "(Required) BBL product_version."
# }

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
  description = "(Optional) When set to `true`,  it will add a `rnd_length`'s long `random_number` at the name's end of the Log Analytics Workspace."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 2
}
variable "additional_tags" {
  description = "(Optional) Additional tags for the Log Analytics Workspace."
  type        = map(string)
  default     = null
}

#--------------------------
# - Log Analytics settings
#--------------------------
variable "sku" {
  type        = string
  description = "(Required) Specifies the SKU of the Log Analytics Workspace. Possible values are `Free`, `PerNode`, `Premium`, `Standard`, `Standalone`, `Unlimited`, and `PerGB2018`."
}
variable "retention_in_days" {
  type        = string
  description = "(Required) The workspace level data retention in days. Possible values range between `30` and `730 (2 years)`."
}
variable "daily_quota_gb" {
  type        = number
  description = "(Optional) The workspace daily quota for ingestion in `GB`. The default value `-1` indicates `unlimited`"
  default     = -1
}
variable "reservation_capacity_in_gb_per_day" {
  type        = number
  description = "(Optional) The capacity reservation level in `GB` for this workspace. Must be in increments of `100` between `100` and `5000`."
  default     = 100
}
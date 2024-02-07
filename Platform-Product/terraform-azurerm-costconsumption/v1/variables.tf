#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------------
# - Dependencies Variables
#-------------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group in which to create the virtual network."
  default = null
}

variable "create_resource_group" {
  description = <<-EOF
  When set to `true` it will cause a Resource Group creation. Name of the newly specified RG is controlled by `resource_group_name`.
  When set to `false` the `resource_group_name` parameter is used to specify a name of an existing Resource Group.
  EOF
  default     = true
  type        = bool
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
# #-------------------------------
# # - Azure Cost Consumption Budget
# #-------------------------------

variable "action_group_name" {
  type        = string
  description = "(Required) Name of the Action Group."
  default     = "bbl-app-cost-consumption-action-group"
}

variable "finops_email_receiver_address" {
  type        = string
  description = "(Required) Email address to type in the action group."
  default     = null
}

variable "finops_email_receiver_name" {
  type        = string
  description = "(Required) Email receiver short name."
  default     = "finopssbblcostalert" 
}

variable "app_email_receiver_address" {
  type        = string
  description = "(Required) Email address to type in the action group."
  default     = null
}

variable "app_email_receiver_name" {
  type        = string
  description = "(Required) Email receiver short name."
  default     = "appsbblcostalert" 
}

variable "consumption_budget_name" {
  type        = string
  description = "(Required) Name of the Cost Consumption Budget."
  default     = "bbl-app-cost-consumption-budget"
}

variable "amount_consumption_budget" {
  type        = number
  description = "(Required) Amount of the Cost Consumption Budget."
  default     = 2000
  
}

variable "currency_consumption_budget" {
  type        = string
  description = "(Required) Currency of the Cost Consumption Budget."
  default     = "USD"
}

variable "start_date" {
  type        = string
  description = "(Required) Start date of the Cost Consumption Budget."
  default     = "2021-10-01T00:00:00Z" 
}



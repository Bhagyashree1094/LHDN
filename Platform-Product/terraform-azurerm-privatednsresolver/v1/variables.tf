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
# - Azure DNS REsolver Variables
#-------------------------------

variable "subnet_id_outbound" {
  type = string
}

variable "subnet_id_inbound" {
  type = string
}


variable "domain_name" {
  type = string
}

variable "domain_name_2" {
  type = string
}

variable "ip_address" {
  type = string  
}

variable "port" {
  type = number
}

variable "ip_address_1" {
  type = string  
}

variable "port_1" {
  type = number
}

variable "ip_address_2" {
  type = string  
}

variable "port_2" {
  type = number
}

variable "ip_address_3" {
  type = string  
}

variable "port_3" {
  type = number
}

variable "private_dns_resolver_vnet_links" {
  type = map(object({
    vnet_id                  = string
  }))
  description = "(Optional) Map containing Private DNS Resolver vnet links Objects. <br></br>&#8226; The name must begin with a `letter` or `number`, end with a `letter`, `number or underscore`, and may contain only `letters`, `numbers`, `underscores`, `periods`, or `hyphens`."
  default = {}
}
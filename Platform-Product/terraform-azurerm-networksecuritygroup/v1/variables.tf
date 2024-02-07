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
  description = "(Required) Name of the Resource Group in which to create the Network Security Group."
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
    error_message = "Value of \"region_code\" must be one of: [sea,ea]."
  }
  default = "sea"
}

variable "app_code" {
  type        = string
  description = "(Required) Application code. Example: network, mgmt, buil"
}

variable "bu" {
  type        = string
  description = "(Required) Bussiness unit code. Example: IT or BBL."
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
  description = "(Optional) When set to `true`, it will add a `rnd_length`'s long `random_number` at the name's end of the Network Security Group."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 3
}
variable "additional_tags" {
  type        = map(string)
  description = "(Optional) Additional tags for the Network Security Group."
  default     = null
}

#
# - Network Security Group Properties
#
variable "nsg_subnet_ids" {
  type        = list(string)
  description = "(Required) The list of the subnet IDs to be associated with the NSG."
}

variable "security_rules" {
  type = map(object({
    description                  = string
    protocol                     = string
    direction                    = string
    access                       = string
    priority                     = number
    source_address_prefix        = string
    source_address_prefixes      = list(string)
    destination_address_prefix   = string
    destination_address_prefixes = list(string)
    source_port_range            = string
    source_port_ranges           = list(string)
    destination_port_range       = string
    destination_port_ranges      = list(string)
  }))
  description = <<EOT
    <p>(Optional) The Network Security rules with their properties:</p>
    <ul>
      <li>[map key] used as `name`: (Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group.</li>
      <li>`description`: (Optional) A description for this rule. Restricted to 140 characters.</li>
      <li>`protocol`: (Required) Network protocol this rule applies to. Possible values include `Tcp`, `Udp`, `Icmp`, `Esp`, `Ah` or `*` (which matches all).</li>
      <li>`direction`: (Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are `Inbound` and `Outbound`.</li>
      <li>`access`: (Required) Specifies whether network traffic is alloed or denied. Possible values are `Allow` and `Deny`.</li>
      <li>`priority`: (Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.</li>
      <li>`source_address_prefix`: (Optional) CIDR or source IP range or `*` to match any IP. Tags such as `VirtualNetwork`, `AzureLoadBalancer` and `Internet` can also be used. This is required if `source_address_prefixes` is not specified.</li>
      <li>`source_address_prefixes`: (Optional) List of source address prefixes. Tags may not be used. This is required if `source_address_prefix` is not specified.</li>
      <li>`destination_address_prefix`: (Optional) CIDR or destination IP range or `*` to match any IP. Tags such as `VirtualNetwork`, `AzureLoadBalancer` and `Internet` can also be used. Besides, it also supports all available Service Tags like `Sql.WestEurope`, `Storage.EastUS`, etc. You can list the available service tags with: `az network list-service-tags --location northcentralus`. This is required if `destination_address_prefixes` is not specified.</li>
      <li>`destination_address_prefixes`: (Optional) List of destination address prefixes. Tags may not be used. This is required if `destination_address_prefix` is not specified.</li>
      <li>`source_port_range`: (Optional) Source Port or Range. Integer or range between `0` and `65535` or `*` to match any. This is required if `source_port_ranges` is not specified.</li>
      <li>`source_port_ranges`: (Optional) List of source ports or port ranges. This is required if `source_port_range` is not specified.</li>
      <li>`destination_port_range`: (Optional) Destination Port or Range. Integer or range between `0` and `65535` or `*` to match any. This is required if `destination_port_ranges` is not specified.</li>
      <li>`destination_port_ranges`: (Optional) List of destination ports or port ranges. This is required if `destination_port_range` is not specified.</li>
    </ul>
  EOT
  default = {
    "IBD-DenyAll" = {
      description                                  = "Inbound Deny All Traffic"
      priority                                     = 4090
      direction                                    = "Inbound"
      access                                       = "Deny"
      protocol                                     = "*"
      source_port_range                            = "*"
      source_port_ranges                           = null
      destination_port_range                       = "*"
      destination_port_ranges                      = null
      source_address_prefix                        = "*"
      source_address_prefixes                      = null
      destination_address_prefix                   = "*"
      destination_address_prefixes                 = null
      source_application_security_group_names      = null
      destination_application_security_group_names = null
    },
    "OBD-DenyAll" = {
      description                                  = "Outbound Deny All Traffic"
      priority                                     = 4090
      direction                                    = "Outbound"
      access                                       = "Deny"
      protocol                                     = "*"
      source_port_range                            = "*"
      source_port_ranges                           = null
      destination_port_range                       = "*"
      destination_port_ranges                      = null
      source_address_prefix                        = "*"
      source_address_prefixes                      = null
      destination_address_prefix                   = "*"
      destination_address_prefixes                 = null
      source_application_security_group_names      = null
      destination_application_security_group_names = null
    }
  }
}
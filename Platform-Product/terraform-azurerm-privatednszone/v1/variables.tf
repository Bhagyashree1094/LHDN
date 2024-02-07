#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
# Required Variables
# -

# ##  Dependencies
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group in which to create the Private DNS Zone."
}

# 
# - Private DNS Zone variables
# 
variable "private_dns_zone_name" {
  type        = string
  description = "(Required) The name of the Private DNS Zone. <br></br>&#8226; Name must have `1-63 characters`, `2 to 34 labels`, Each label is a set of characters separated by a period. For example, contoso.com has 2 labels."
}

variable "dns_zone_additional_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the Private DNS Zone resource."
  default     = {}
}

variable "private_dns_zone_vnet_links" {
  type = map(object({
    vnet_id                  = string
    registration_enabled     = bool
  }))
  description = "(Optional) Map containing Private DNS Zone vnet links Objects. <br></br>&#8226; The name must begin with a `letter` or `number`, end with a `letter`, `number or underscore`, and may contain only `letters`, `numbers`, `underscores`, `periods`, or `hyphens`."
  default = {}
}

#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# RG Variables
variable "org" {}
variable "country" {}
variable "env" {}
variable "base_name" {}
variable "au" {}
variable "owner" {}
variable "region_code" {}

# -
# - Resource Group for route-table tests
# -
variable "rg_additional_tags" {}
variable "rg_additional_name" {}

# Route Table variables
variable "rt_additional_name" {}
variable "iterator" {}
variable "add_random" {}
variable "rnd_length" {}

variable "route_table" {
  type = object({
    disable_bgp_route_propagation = bool
    subnet_ids                    = list(string)
    routes = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))
  })
  description = "(Required) The route table with its properties."
}
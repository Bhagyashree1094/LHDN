#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
# - BBL Variables
# -
variable "org"            {}
variable "country"        {}
variable "env"            {}
variable "base_name"      {}
variable "au"             {}
variable "owner"          {}
variable "region_code"    {}

# -
# - Resource Group for Private DNS Zone tests
# -
variable "rg_additional_name" {}
variable "rg_additional_tags" {}

# -
# Private DNS Zone 1 variables
# -
variable "private_dns_zone_name"        { default = null }
variable "private_dns_zone_vnet_links" { default = null }
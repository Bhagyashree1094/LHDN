#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------
# - Wells Fargo Variables
#-------------------------
variable "org" {}
variable "country" {}
variable "env" {}
variable "base_name" {}
variable "au" {}
variable "owner" {}
variable "region_code" {}
variable "rg_additional_tags" {}
variable "rg_additional_name" {}
variable "product_version" {}


#-----------------------------
# - Role assignment variables
#-----------------------------
variable "spn_principal_id" {
  type = string
}
variable "spn_role_name" {
  type = string
}

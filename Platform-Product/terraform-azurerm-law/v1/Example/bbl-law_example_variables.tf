#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# RG Variables
variable "org" {}
variable "country" {}
variable "env" {}
variable "region_code" {}
variable "au" {}
variable "owner" {}
variable "iterator" {}

variable "rg_base_name" {}
variable "rg_additional_name" {}
variable "rg_additional_tags" { default = null }

# Log Analytics Workspace variables
variable "law_base_name" { default = null }
variable "law_additional_name" { default = null }
variable "law_additional_tags" { default = null }
variable "sku" { default = {} }
variable "retention_in_days" { default = {} }

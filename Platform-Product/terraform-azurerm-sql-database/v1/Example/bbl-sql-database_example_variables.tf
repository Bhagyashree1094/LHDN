#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Variables
#--------------------------------------------------------------

variable "org" {}
variable "country" {}
variable "env" {}
variable "region_code" {}
variable "base_name" {}
variable "au" {}
variable "owner" {}
variable "additional_tags" { default = null }
variable "product_version" {}
variable "app_code" {}
variable "app_code_sec" {}
variable "bu" {}
variable "env_nprd" {}

variable "mssql_server_resource_group_name" {}
variable "mssql_server_name" {}
variable "max_size_gb" {}
variable "sku_name" {}
variable "collation" {}
variable "geo_backup_enabled" {}
variable "zone_redundant" {}
variable "maintenance_configuration_name" {}


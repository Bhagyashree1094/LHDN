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

variable "resource_group_name" {}
variable "offer_type" {}
variable "kind" {}
variable "enable_free_tier" {}
variable "ip_range_filter" {}
variable "analytical_storage_enabled" {}
variable "bypass_for_azure_services_enabled" {}
variable "consistency_policy" {}
variable "geo_locations" {}
variable "total_throughput_limit" {}
variable "backup" {}
variable "identity_type" {}
variable "enable_multiple_write_locations" {}
variable "public_network_access_enabled" {}


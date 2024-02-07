#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
# - BBL Variables
# -
variable "org" {}
variable "country" {}
variable "env" {}
variable "base_name" {}
variable "au" {}
variable "owner" {}
variable "additional_name" {}
variable "iterator" {}
variable "product_version" {}

# -
# - Resource Group for Storage Account tests
# -
variable "additional_tags" {}

# Test network ACLs
variable "ca_ip_prefixes" {}
variable "in_ip_prefixes" {}

# -
# - Storage account common variables
# -
variable "region_code" {}

# -
# - Storage account 1 variables
# -
variable "st1_containers" { default = {} }
variable "st1_blobs" { default = {} }
variable "st1_queues" { default = {} }
variable "st1_file_shares" { default = {} }
variable "st1_tables" { default = {} }
variable "is_log_storage" {}
variable "assign_identity" {}

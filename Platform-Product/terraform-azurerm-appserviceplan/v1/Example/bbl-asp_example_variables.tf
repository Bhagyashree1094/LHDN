#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------
# - BBL Variables
#-------------------------
variable "org" {}
variable "country" {}
variable "env" {}
variable "region_code" {}
variable "base_name" { default = null }
variable "additional_name" { default = null }
variable "iterator" { default = null }

variable "add_random" { default = null }
variable "rnd_length" { default = null }

variable "owner" {}
variable "au" {}
variable "rg_additional_tags" { default = null }
variable "ase_additional_tags" { default = null }
variable "asp_additional_tags" { default = null }

#------------------
# - ASP Variables
#------------------
variable "kind" {}
variable "maximum_elastic_worker_count" {}
variable "app_service_environment_v3_id" {}
variable "per_site_scaling" {}
variable "capacity" {}
variable "size" {}

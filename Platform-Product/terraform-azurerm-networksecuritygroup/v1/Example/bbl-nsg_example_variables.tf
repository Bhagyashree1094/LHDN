#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#  Wells Fargo Variables
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
variable "additional_tags" { default = null }

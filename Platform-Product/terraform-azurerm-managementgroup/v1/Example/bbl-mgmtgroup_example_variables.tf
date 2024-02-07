#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Parent management group variable
variable "root_management_group_id" {}

# Subscription ids to associate with the management group
variable "subscription_ids_platform" { default = [] }
variable "subscription_ids_platform_securtiy" { default = [] }
variable "subscription_ids_platform_automation" { default = [] }
variable "subscription_ids_platform_network" { default = [] }
variable "subscription_ids_platform_identity" { default = [] }
variable "subscription_ids_platform_management" { default = [] }
variable "subscription_ids_landingzone" { default = [] }
variable "subscription_ids_decommissioned" { default = [] }
variable "subscription_ids_sandbox" { default = [] }


# Management group level naming variables
variable "display_name_platform" {}
variable "display_name_platform_securtiy" {}
variable "display_name_platform_automation" {}
variable "display_name_platform_network" {}
variable "display_name_platform_identity" {}
variable "display_name_platform_management" {}
variable "display_name_landingzone" {}
variable "display_name_decommissioned" {}
variable "display_name_sandbox" {}

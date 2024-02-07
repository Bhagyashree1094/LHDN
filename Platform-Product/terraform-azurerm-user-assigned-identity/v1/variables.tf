#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# ##  Dependencies
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group in which to create the User Assigned Identity."
}

# ##  User Assigned Identity
variable "name" {
  type        = string
  description = "(Required) The name of the User Assigned Identity. The module will add the recommended abbreviation prefix `id-` to the actual resource name. Changing this forces a new identity to be created."
}
variable "additional_tags" {
  description = "(Optional) A mapping of tags to assign to the User Assigned Identity resource."
  type        = map(string)
  default     = null
}
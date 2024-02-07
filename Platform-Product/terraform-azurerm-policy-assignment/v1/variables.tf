#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
# Required Variables
# -

variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Policy Assignment. "
}
variable "policy_definition_id" {
  type        = string
  description = "(Required) The ID of the Policy Definition or Policy Definition Set."
}
variable "scope" {
  type        = string
  description = "(Required) The scope where this Policy Assignment should be created."
}

# -
# Optional Variables
# -
variable "description" {
  type        = string
  description = "(Optional) A description which should be used for this Policy Assignment."
  default     = null
}
variable "display_name" {
  type        = string
  description = "(Optional) The Display Name for this Policy Assignment."
  default     = null
}
variable "not_scopes" {
  type        = list(string)
  description = "(Optional) Specifies a list of Resource Scopes (for example a Subscription, or a Resource Group) within this Management Group which are excluded from this Policy."
  default     = null
}
variable "metadata" {
  type        = any
  description = "(Optional) A JSON mapping of any Metadata for this Policy."
  default     = null
}
variable "parameters" {
  type        = any
  description = "(Optional) A JSON mapping of any Parameters for this Policy."
  default     = null
}
variable "enforcement_mode" {
  type        = string
  description = "(Optional) Specifies if this Policy should be enforced or not?"
  default     = null
}
variable "location" {
  type        = string
  description = "(Optional) The Azure Region where the Policy Assignment should exist."
  default     = null
}
variable "assign_identity" {
  type        = bool
  description = "(Optional) Whether or not to assign System Assigned Identity to the Policy Assignment. It is required to enable this for enabling role assignments on Managed Identity."
  default     = null
}
variable "management_group_set_definition" {
  type        = string
  description = "(Optional) Name of management group from which policy set definition will be fetched."
  default     = null
}
variable "management_group_policy_definition" {
  type        = string
  description = "(Optional) Name of management group from which policy definition will be fetched."
  default     = null
}
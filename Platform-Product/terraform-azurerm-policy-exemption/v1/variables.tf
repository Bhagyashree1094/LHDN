#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------------
# - Required Variables
#----------------------
variable "name" {
  type        = string
  description = "(Required) The name which should be used for this Policy Exemption."
}
variable "policy_assignment_id" {
  type        = string
  description = "(Required) The ID of the Policy Assignment that should be exempted."
}
variable "scope" {
  type        = string
  description = "(Required) The scope at which the Policy Exemption should be applied."
}
variable "exemption_category" {
  type        = string
  description = "(Required) The category of this policy exemption. Possible values are Waiver and Mitigated."
}

#----------------------
# - Optional Variables
#----------------------
variable "description" {
  type        = string
  description = "(Optional) A description to use for this Policy Exemption."
  default     = null
}
variable "display_name" {
  type        = string
  description = "(Optional) A friendly display name to use for this Policy Exemption."
  default     = null
}
variable "expires_on" {
  type        = string
  description = "(Optional) The expiration date and time in UTC ISO 8601 format of this policy exemption."
  default     = null
}
variable "policy_definition_reference_ids" {
  type        = list(string)
  description = "(Optional) The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition."
  default     = null
}
variable "metadata" {
  type        = any
  description = "(Optional) The metadata for this policy exemption. This is a JSON string representing additional metadata that should be stored with the policy exemption."
  default     = null
}
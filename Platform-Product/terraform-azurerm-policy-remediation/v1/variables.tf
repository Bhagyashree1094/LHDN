#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
# Required Variables
# -
variable "name" {
  type = string
  description = "(Required) The name which should be used for this Policy Remediation. "
}
variable "policy_assignment_id" {
  type = string
  description = "(Required) The ID of the Policy Assignment that should be remediated."
}
variable "scope" {
  type = string
  description = "(Required) The scope at which the Policy Remediation should be applied."
}

# -
# Optional Variables
# -
variable "policy_definition_id" {
  type = string
  description = "(Optional) The unique ID for the policy definition within the policy set definition that should be remediated. Required when the policy assignment being remediated assigns a policy set definition."
  default = null
}
variable "location_filters" {
  type = list(string)
  description = "(Optional) A list of the resource locations that will be remediated."
  default = null
}
variable "resource_discovery_mode" {
  type = string
  description = "(Optional) The way that resources to remediate are discovered. Possible values are `ExistingNonCompliant`, `ReEvaluateCompliance`. Defaults to `ExistingNonCompliant`."
  default = null
}

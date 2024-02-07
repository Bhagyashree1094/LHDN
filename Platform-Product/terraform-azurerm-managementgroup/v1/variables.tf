
# Management Group variables
variable "mg_name" {
  type        = string
  description = "(Required) Name of the Management group."
}

variable "parent_management_group_id" {
  type        = string
  description = "(Optional) ID of the parent Management group."
  default     = null
}

variable "subscription_ids" {
  type        = list(string)
  description = "(Optional) provide the list of the existing subscription IDs to be associated with the newly created Management group."
  default     = []
}
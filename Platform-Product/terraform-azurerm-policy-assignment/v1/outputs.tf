#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# # #############################################################################
# # # OUTPUTS Policy Assignment
# # #############################################################################

output "id" {
  value       = local.policy_assignment[0].id
  description = "The ID of the Azure Policy Assignment."
}

output "role_assignment_ids" {
  value       = [for x in module.bbl_role_assignments : x.id]
  description = "The ID(s) of the Role Assignment(s)."
}

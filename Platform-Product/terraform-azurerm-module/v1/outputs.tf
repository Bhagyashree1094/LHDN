#
# Copyright 2023 lhdn & Microsoft. All rights reserved.
#

output "name" {
  value       = local.resource_name
  description = "The generated name of the resource by the module."
}
output "location" {
  value       = local.location_names[var.region_code]
  description = "Location name compliant with `Azure Regions`' names. The list can be fetched with `az account list-locations --query '[].name'`."
}
output "tags" {
  value       = local.base_tags
  description = "Set of Azure tags for the resource."
}

output "random_suffix" {
  value       = local.random_suffix
  description = "Randomized piece of the name, if used, for any name manipulation."
}

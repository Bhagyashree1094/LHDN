#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by: 
# Overview:
#   This module:
#   - Creates policy-set-definition and associated resources,

# 
# - Generate the locals
# 
locals {
  filepath              = "${path.module}/policy_set_definitions/${var.policySetDefinitionJsonFile}"
  policy_set_definition = jsondecode(file(local.filepath))
}

#
# - Create policy-set-definition resources
#

resource "azurerm_policy_set_definition" "this" {
  # Mandatory resource attributes
  name         = coalesce(var.name, local.policy_set_definition.name)
  display_name = coalesce(var.display_name, local.policy_set_definition.properties.displayName)
  policy_type  = "Custom"

  dynamic "policy_definition_reference" {
    for_each = [
      for item in local.policy_set_definition.properties.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        parameters                  = try(jsonencode(item.parameters), null)
        policyDefinitionReferenceId = try(item.policyDefinitionReferenceId, null)
      }
    ]
    content {
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = policy_definition_reference.value["parameters"]
      reference_id         = policy_definition_reference.value["policyDefinitionReferenceId"]
    }
  }
  # Optional Resource attributes
  description         = try(length(local.policy_set_definition.properties.description) > 0 ? jsonencode(local.policy_set_definition.properties.description) : null)
  parameters          = try(length(local.policy_set_definition.properties.parameters) > 0 ? jsonencode(local.policy_set_definition.properties.parameters) : null)
  metadata            = try(length(local.policy_set_definition.properties.metadata) > 0 ? jsonencode(local.policy_set_definition.properties.metadata) : null)
  management_group_id = var.management_group_id
}
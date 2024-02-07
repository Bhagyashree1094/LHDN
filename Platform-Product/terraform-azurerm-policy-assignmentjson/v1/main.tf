#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 31th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by: 

# Overview:
#   This module creates policy_assignment

# - Generate the locals for policy assignment
#
locals {
  filepath          = "${path.module}/policy_assignment_json/${var.policyDefinitionJsonFile}"
  policy_assignment = jsondecode(file(local.filepath))
}

#
# - Create policy_assignment resources
#
resource "azurerm_management_group_policy_assignment" "this" {
  # Required Resource attributes
  name                = length(var.name) > 24 ? "The policy assignment name '${var.name}' is invalid. The policy assignment name length must not exceed '24' characters." : var.name
  display_name        = coalesce(var.display_name, local.policy_assignment.properties.displayName)
  policy_definition_id = coalesce(var.policy_definition_id, local.policy_assignment.properties.policyDefinitionId)
  management_group_id =  var.management_group_id
  not_scopes          = coalesce(var.not_scopes, local.policy_assignment.properties.notScopes)
  enforce             = coalesce(var.enforcement_mode, local.policy_assignment.properties.enforcementMode)
  location            = coalesce(var.location, local.policy_assignment.location)
  identity {
    type = coalesce(var.identity_type, local.policy_assignment.identity.type)
  }

  # Optional Resource attributes
  description = var.description != null ? var.description : try(length(local.policy_assignment.properties.description) > 0 ? local.policy_assignment.properties.description : null)
  parameters  = try(length(local.policy_assignment.properties.parameters) > 0 ? jsonencode(local.policy_assignment.properties.parameters) : null)
  metadata    = try(length(local.policy_assignment.properties.metadata) > 0 ? jsonencode(local.policy_assignment.properties.metadata) : null)
}


module "azurerm_role_assignment" {

source = "../../terraform-azurerm-role-assignment/v1"

# Required Resource attributes
  scope                = var.management_group_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_management_group_policy_assignment.this.identity[0].principal_id
  depends_on           = [azurerm_management_group_policy_assignment.this]
  
}
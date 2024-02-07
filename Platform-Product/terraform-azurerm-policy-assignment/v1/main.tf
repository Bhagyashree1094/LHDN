#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by: 
# Overview:
#   This module:
#   - Creates policy-assignment and assign the remediation required role to the policy assignment identity

# 
# - Generate the locals for filtering the scope against the below resource blocks and creates a map of Role Definition Ids 
#   when found in the policy definition.
# 
locals {
  # The following regex is designed to consistently split a resource_id into the following capture
  # groups, regardless of resource type:
  # [0] Resource scope, type substring (e.g. "/providers/Microsoft.Management/managementGroups/")
  # [1] Resource scope, name substring (e.g. "group1")
  # [2] Resource, type substring (e.g. "/providers/Microsoft.Authorization/policyAssignments/")
  # [3] Resource, name substring (e.g. "assignment1")
  regex_scope_is_management_group = "(?i)(/providers/Microsoft.Management/managementGroups/)([^/]+)$"
  regex_scope_is_subscription     = "(?i)(/subscriptions/)([^/]+)$"
  regex_scope_is_resource_group   = "(?i)(/subscriptions/[^/]+/resourceGroups/)([^/]+)$"
  regex_scope_is_resource         = "(?i)(/subscriptions/[^/]+/resourceGroups(?:/[^/]+){4}/)([^/]+)$"

  scope_is_management_group = length(regexall(local.regex_scope_is_management_group, var.scope)) > 0 ? true : false
  scope_is_subscription     = local.scope_is_management_group == false ? length(regexall(local.regex_scope_is_subscription, var.scope)) > 0 ? true : false : false
  scope_is_resource_group   = local.scope_is_management_group == false ? length(regexall(local.regex_scope_is_resource_group, var.scope)) > 0 ? true : false : false
  scope_is_resource         = local.scope_is_management_group == false ? length(regexall(local.regex_scope_is_resource, var.scope)) > 0 ? true : false : false

  ######################################## Role definition Id parsing logic ########################################

  # Extracting policy definition name
  policy_set_def_name = basename(var.policy_definition_id)

  all_policy_definitions = concat([
    for policy_def in try(data.azurerm_policy_set_definition.this.0.policy_definition_reference, []) : {
      policy_key    = policy_def.reference_id
      policy_def_id = basename(policy_def.policy_definition_id)
    }
    if(contains(split("/", var.policy_definition_id), "policySetDefinitions"))
    ],
    [
      for v in [var.policy_definition_id] : {
        policy_key    = v
        policy_def_id = basename(v)
      }
      if(contains(split("/", var.policy_definition_id), "policySetDefinitions")) == false
    ]
  )

  policy_definition = {
    for policy_def in local.all_policy_definitions : policy_def.policy_key => policy_def
  }

  # # Extracting policy rules from policy definitions

  policy_rule_json = [
    for policy in local.policy_definition : {
      policy_rule_map = jsondecode(lookup(data.azurerm_policy_definition.this, policy.policy_key)["policy_rule"])
    }
  ]

  # Fetching Role assignments
  map_role_definition_id = flatten([
    for policy in try(local.policy_rule_json) : [
      for role_def in try(policy.policy_rule_map.then.details.roleDefinitionIds, []) : {
        role_def_key = basename(role_def)
        role_def_id  = "/providers/Microsoft.Authorization/roleDefinitions/${basename(role_def)}"
      }
    ]
  ])

  role_assignments = {
    for k in try(local.map_role_definition_id, []) : k.role_def_id => k...
    if length(try(local.map_role_definition_id, [])) > 0 && var.assign_identity == true
  }

  ######## For Output variable and role assignments ########
  policy_assignment = concat(
    azurerm_management_group_policy_assignment.this,
    azurerm_subscription_policy_assignment.this,
    azurerm_resource_group_policy_assignment.this,
    azurerm_resource_policy_assignment.this,
  )
}

#
# - Dependencies data resources
#
data "azurerm_policy_definition" "this" {
  for_each = local.policy_definition

  name                  = each.value.policy_def_id
  management_group_name = var.management_group_policy_definition
}

data "azurerm_policy_set_definition" "this" {
  count = contains(split("/", var.policy_definition_id), "policySetDefinitions") ? 1 : 0

  name                  = local.policy_set_def_name
  management_group_name = var.management_group_set_definition
}

#
# - If scope is Management Group, create a Management Group policy assignment
#
resource "azurerm_management_group_policy_assignment" "this" {
  count = local.scope_is_management_group == true ? 1 : 0

  # Mandatory resource attributes
  name                 = length(var.name) > 128 ? "The policy assignment name '${var.name}' is invalid. The policy assignment name length must not exceed '128' characters." : var.name
  management_group_id  = var.scope
  policy_definition_id = var.policy_definition_id

  # Optional resource attributes
  location     = var.location
  description  = var.description
  display_name = var.display_name
  metadata     = try(length(var.metadata) > 0, false) ? jsonencode(var.metadata) : null
  parameters   = try(length(var.parameters) > 0, false) ? jsonencode(var.parameters) : null
  not_scopes   = var.not_scopes
  enforce      = var.enforcement_mode

  # Dynamic configuration blocks
  # The identity block only supports a single value for type = "SystemAssigned" 
  # so the following logic ensures the block is only created when this values specified in the source template
  dynamic "identity" {
    for_each = var.assign_identity == false ? [] : tolist([var.assign_identity])
    content {
      type = "SystemAssigned"
    }
  }
}

#
# - If scope is Subscription, create a Subscription policy assignment
#
resource "azurerm_subscription_policy_assignment" "this" {
  count = local.scope_is_subscription == true ? 1 : 0

  # Mandatory resource attributes
  name                 = length(var.name) > 128 ? "The policy assignment name '${var.name}' is invalid. The policy assignment name length must not exceed '128' characters." : var.name
  subscription_id      = var.scope
  policy_definition_id = var.policy_definition_id

  # Optional resource attributes
  location     = var.location
  description  = var.description
  display_name = var.display_name
  metadata     = try(length(var.metadata) > 0, false) ? jsonencode(var.metadata) : null
  parameters   = try(length(var.parameters) > 0, false) ? jsonencode(var.parameters) : null
  not_scopes   = var.not_scopes
  enforce      = var.enforcement_mode

  # Dynamic configuration blocks
  # The identity block only supports a single value for type = "SystemAssigned" 
  # so the following logic ensures the block is only created when this valueis specified in the source template
  dynamic "identity" {
    for_each = var.assign_identity == false ? [] : tolist([var.assign_identity])
    content {
      type         = "SystemAssigned"
      identity_ids = []
    }
  }
}

#
# - If scope is Resource Group, create a Resource Group policy assignment
#
resource "azurerm_resource_group_policy_assignment" "this" {
  count = local.scope_is_resource_group == true ? 1 : 0

  # Mandatory resource attributes
  name                 = length(var.name) > 128 ? "The policy assignment name '${var.name}' is invalid. The policy assignment name length must not exceed '128' characters." : var.name
  resource_group_id    = var.scope
  policy_definition_id = var.policy_definition_id

  # Optional resource attributes
  location     = var.location
  description  = var.description
  display_name = var.display_name
  metadata     = try(length(var.metadata) > 0, false) ? jsonencode(var.metadata) : null
  parameters   = try(length(var.parameters) > 0, false) ? jsonencode(var.parameters) : null
  not_scopes   = var.not_scopes
  enforce      = var.enforcement_mode

  # Dynamic configuration blocks
  # The identity block only supports a single value for type = "SystemAssigned" 
  # so the following logic ensures the block is only created when this valueis specified in the source template
  dynamic "identity" {
    for_each = var.assign_identity == false ? [] : tolist([var.assign_identity])
    content {
      type = "SystemAssigned"
    }
  }
}

#
# - If scope is Resource, create a Resource policy assignment
#
resource "azurerm_resource_policy_assignment" "this" {
  count = local.scope_is_resource == true ? 1 : 0

  # Mandatory resource attributes
  name                 = length(var.name) > 128 ? "The policy assignment name '${var.name}' is invalid. The policy assignment name length must not exceed '128' characters." : var.name
  resource_id          = var.scope
  policy_definition_id = var.policy_definition_id

  # Optional resource attributes
  location     = var.location
  description  = var.description
  display_name = var.display_name
  metadata     = try(length(var.metadata) > 0, false) ? jsonencode(var.metadata) : null
  parameters   = try(length(var.parameters) > 0, false) ? jsonencode(var.parameters) : null
  not_scopes   = var.not_scopes
  enforce      = var.enforcement_mode


  # Dynamic configuration blocks
  # The identity block only supports a single value for type = "SystemAssigned" 
  # so the following logic ensures the block is only created when this valueis specified in the source template
  dynamic "identity" {
    for_each = var.assign_identity == false ? [] : tolist([var.assign_identity])
    content {
      type = "SystemAssigned"
    }
  }
}

#
# - If roleAssignments found AND assign_identity == true => Assign the Role(s) required to the Policy assignment Identity
#
module "bbl_role_assignments" {

  source = "../../terraform-azurerm-role-assignment/v1"
  depends_on = [
    azurerm_resource_group_policy_assignment.this,
    azurerm_subscription_policy_assignment.this,
    azurerm_resource_policy_assignment.this,
    azurerm_management_group_policy_assignment.this
  ]

  for_each = local.role_assignments

  # Role Assignment Variables
  scope              = var.scope
  role_definition_id = each.key
  principal_id       = local.policy_assignment[0].identity[0].principal_id
}

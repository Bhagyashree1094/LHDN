#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: July. 19th, 2023.
# Created  by: Akash Choudhary
# Modified on:
# Modified by:   
# Overview:
#   This module:
#   - Creates policy exemption for the policy exemptions associated with policy definition and policy set defintions ate various scopes

# 
# - Generate the locals for filtering the scope against the below resource blocks 
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

}

#
# - Create Policy Exemption resources
# - Create the Azure Policy Exemption on Management Group level
#
resource "azurerm_management_group_policy_exemption" "this" {
  count                           = local.scope_is_management_group == true ? 1 : 0
  name                            = length(var.name) > 64 ? "The policy exemption name '${var.name}' is invalid. The policy exemption name length must not exceed '64' characters." : lower(var.name)
  management_group_id             = var.scope
  exemption_category              = var.exemption_category
  policy_assignment_id            = var.policy_assignment_id
  description                     = var.description
  display_name                    = var.display_name
  expires_on                      = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata                        = jsonencode(var.metadata)
}

# 
# - Create the Azure Policy Exemption on Subscription level
#
resource "azurerm_subscription_policy_exemption" "this" {
  count                           = local.scope_is_subscription == true ? 1 : 0
  name                            = length(var.name) > 64 ? "The policy exemption name '${var.name}' is invalid. The policy exemption name length must not exceed '64' characters." : lower(var.name)
  subscription_id                 = var.scope
  policy_assignment_id            = var.policy_assignment_id
  exemption_category              = var.exemption_category
  description                     = var.description
  display_name                    = var.display_name
  expires_on                      = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata                        = jsonencode(var.metadata)
}

# 
# - Create the Azure Policy Exemption on Resource Group level
#
resource "azurerm_resource_group_policy_exemption" "this" {
  count                           = local.scope_is_resource_group == true ? 1 : 0
  name                            = length(var.name) > 64 ? "The policy exemption name '${var.name}' is invalid. The policy exemption name length must not exceed '64' characters." : lower(var.name)
  resource_group_id               = var.scope
  policy_assignment_id            = var.policy_assignment_id
  exemption_category              = var.exemption_category
  description                     = var.description
  display_name                    = var.display_name
  expires_on                      = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata                        = jsonencode(var.metadata)
}

# 
# - Create the Azure Policy Exemption on Resource level
#
resource "azurerm_resource_policy_exemption" "this" {
  count                           = local.scope_is_resource == true ? 1 : 0
  name                            = length(var.name) > 64 ? "The policy exemption name '${var.name}' is invalid. The policy exemption name length must not exceed '64' characters." : lower(var.name)
  resource_id                     = var.scope
  policy_assignment_id            = var.policy_assignment_id
  exemption_category              = var.exemption_category
  description                     = var.description
  display_name                    = var.display_name
  expires_on                      = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata                        = jsonencode(var.metadata)
}


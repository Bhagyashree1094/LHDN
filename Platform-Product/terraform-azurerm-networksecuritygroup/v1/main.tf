#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: August. 09th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 
# Overview:
#   This module:
#   - Creates Network Security group and IBD, OBD rules.

#-------------------------
# - Dependencies data resources
#-------------------------
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#-------------------------
# - Get the Network Security Group name with bbl module
#-------------------------

module "bbl_nsg_name" {

  source = "../../terraform-azurerm-module/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  product_version = var.product_version
  bu              = var.bu
  app_code        = var.app_code

  # NSG specifics settings
  resource_type_code = "nsg"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

#-------------------------
# - Generate the locals
#-------------------------
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_nsg_name.tags,
    var.additional_tags
  )
}

#-------------------------
# - Network Security Group and its Inbound, Outbound rules
#-------------------------
# PR-001, PR-002 Cloud Management Plane : NSGs are used to control network traffic. No implicit network rules should exist.
# PR-052, PR-054, PR-057 Infrastructure Protection : NSGs help in filtering network traffic to Azure resources deployed in Virtual Networks. Inbound and Outbound rules can be created to restrict traffic.
resource "azurerm_network_security_group" "this" {
  name                = lower(module.bbl_nsg_name.name)
  location            = data.azurerm_resource_group.this.location
  resource_group_name = var.resource_group_name

  tags = local.tags
}

resource "azurerm_network_security_rule" "this" {
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.this.name

  for_each = coalesce(var.security_rules, {})

  name                         = each.key
  description                  = lookup(each.value, "description", null)
  protocol                     = lookup(each.value, "protocol", null)
  direction                    = lookup(each.value, "direction", null)
  access                       = lookup(each.value, "access", null)
  priority                     = lookup(each.value, "priority", null)
  source_address_prefix        = lookup(each.value, "source_address_prefix", null)
  source_address_prefixes      = lookup(each.value, "source_address_prefixes", null)
  destination_address_prefix   = lookup(each.value, "destination_address_prefix", null)
  destination_address_prefixes = lookup(each.value, "destination_address_prefixes", null)
  source_port_range            = lookup(each.value, "source_port_range", null)
  source_port_ranges           = lookup(each.value, "source_port_ranges", null)
  destination_port_range       = lookup(each.value, "destination_port_range", null)
  destination_port_ranges      = lookup(each.value, "destination_port_ranges", null)
}

#-------------------------
#- Associates a Network Security Group with Subnets within a Virtual Network
#-------------------------

resource "azurerm_subnet_network_security_group_association" "this" {
  count = length(var.nsg_subnet_ids)

  network_security_group_id = azurerm_network_security_group.this.id
  subnet_id                 = var.nsg_subnet_ids[count.index]
}

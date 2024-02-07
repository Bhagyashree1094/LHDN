#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: September 28th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Creates a Private DNS resolver and it associated properties.

#------------------------------
# - Dependencies data resource
#------------------------------

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "this" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "inbound" {

  name                 = var.subnet_id_inbound
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}

data "azurerm_subnet" "outbound" {

  name                 = var.subnet_id_outbound
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}


#-------------------------------------------
# - Generate the Privtae DNS resolver Name.
#-------------------------------------------
module "bbl_dnsresolver_name" {

   source = "../../terraform-azurerm-module/v1"

  # BBL ordered naming inputs
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name
  au               = var.au
  country         = var.country
  org             = var.org
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  product_version = var.product_version


  # VNet specifics settings
  resource_type_code = "dnspr"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length

  # Delete during bbl intake process
  iterator = var.iterator
}

#-------------------------------------------------- 
# - Generate the locals
#-------------------------------------------------- 
locals {
  
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_dnsresolver_name.tags,
    var.additional_tags
  )
}

#--------------------------------------
# - Create the Azure dnsresolver.
#--------------------------------------

resource "azurerm_private_dns_resolver" "this" {
  name                   = lower(module.bbl_dnsresolver_name.name)
  location               = module.bbl_dnsresolver_name.location
  resource_group_name    = data.azurerm_resource_group.this.name
  virtual_network_id     = data.azurerm_virtual_network.this.id
  tags                   = local.tags
}

#-----------------------------------------
# - Create the Azure dnsresolver Inbound.
#------------------------------------------

resource "azurerm_private_dns_resolver_inbound_endpoint" "this" {
  name                    = "bbldnsinbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = module.bbl_dnsresolver_name.location
  tags                    = local.tags
   ip_configurations {
      private_ip_allocation_method = "Dynamic"
      subnet_id                    = data.azurerm_subnet.inbound.id
  } 
 }


#------------------------------------------
# - Create the Azure dnsresolver Outbound.
#------------------------------------------

resource "azurerm_private_dns_resolver_outbound_endpoint" "this" {

  name                    = "bbldnsoutbound"
  private_dns_resolver_id = azurerm_private_dns_resolver.this.id
  location                = module.bbl_dnsresolver_name.location
  tags                    = local.tags
  subnet_id               = data.azurerm_subnet.outbound.id
  
}

#-----------------------------------------
# - Create the Azure dnsresolver ruleset.
#------------------------------------------

resource "azurerm_private_dns_resolver_dns_forwarding_ruleset" "this" {
    name                    = "bblforwardingruleset"
    resource_group_name     = data.azurerm_resource_group.this.name
    private_dns_resolver_outbound_endpoint_ids = [azurerm_private_dns_resolver_outbound_endpoint.this.id]
    location                = module.bbl_dnsresolver_name.location
    tags                    = local.tags
}

#------------------------------------------------
# - Create the Azure dnsresolver forwarding rule.
#------------------------------------------------

resource "azurerm_private_dns_resolver_forwarding_rule" "this" {
    name                      = "bblforwardingrule-1"
    dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
    domain_name               = var.domain_name
    target_dns_servers {
      ip_address = var.ip_address
      port       = var.port
  }
      target_dns_servers {
      ip_address = var.ip_address_1
      port       = var.port_1
  }
}

resource "azurerm_private_dns_resolver_forwarding_rule" "this2" {
    name                      = "bblforwardingrule-2"
    dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
    domain_name               = var.domain_name_2
    target_dns_servers {
      ip_address = var.ip_address_2
      port       = var.port_2
    }
    target_dns_servers {
      ip_address = var.ip_address_3
      port       = var.port_3
    }
}

#-----------------------------------------
# - Create the Azure Vnet Link
#------------------------------------------

resource "azurerm_private_dns_resolver_virtual_network_link" "this" {
  for_each              = var.private_dns_resolver_vnet_links
  name                  = substr("link_to_${split("/", each.value["vnet_id"])[8]}", 0, 80)
  dns_forwarding_ruleset_id = azurerm_private_dns_resolver_dns_forwarding_ruleset.this.id
  virtual_network_id = each.value["vnet_id"]
}
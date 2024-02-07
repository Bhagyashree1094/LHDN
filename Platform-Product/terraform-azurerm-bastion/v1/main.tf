#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: September 06th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Creates a Azure Abstion and it associated properties.

#------------------------------
# - Dependencies data resource
#------------------------------

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data azurerm_virtual_network "this" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}


#------------------------------------
# - Generate the Azure Bastion Name.
#------------------------------------
module "bbl_bastion_name" {

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
  resource_type_code = "bas"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length

  # Delete during bbl intake process
  iterator = var.iterator
}

#----------------------------------------------
# - Generate the Azure Bastion Public IP Name.
#----------------------------------------------
module "bbl_bastion_pip_name" {

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
  resource_type_code = "pip-bas"
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
    module.bbl_bastion_name.tags,
    var.additional_tags
  )
}

#--------------------------------------
# - Create the Azure Bastion Subnet
#--------------------------------------
resource "azurerm_subnet" "this" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = data.azurerm_resource_group.this.name
  virtual_network_name = data.azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_address_prefix]
}

#--------------------------------------
# - Create the Azure Bastion Public IP.
#--------------------------------------
resource "azurerm_public_ip" "this" {
  name                = lower(module.bbl_bastion_pip_name.name)
  location            = module.bbl_bastion_pip_name.location
  resource_group_name = data.azurerm_resource_group.this.name
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = local.tags
}


#--------------------------------------
# - Create the Azure Bastion.
#--------------------------------------

resource "azurerm_bastion_host" "this" {
  name                   = lower(module.bbl_bastion_name.name)
  location               = module.bbl_bastion_name.location
  resource_group_name    = data.azurerm_resource_group.this.name
  sku                    = "Standard"      # ["Basic", "Standard"]
  scale_units            = var.scale_units # [2..50], always 2 when Basic sku
  copy_paste_enabled     = var.copy_paste_enabled
  file_copy_enabled      = var.file_copy_enabled
  ip_connect_enabled     = var.ip_connect_enabled
  shareable_link_enabled = var.shareable_link_enabled
  tunneling_enabled      = var.tunneling_enabled
  ip_configuration {
    name                 = "bas-ip-configuration"
    subnet_id            = azurerm_subnet.this.id
    public_ip_address_id = azurerm_public_ip.this.id
  }
}
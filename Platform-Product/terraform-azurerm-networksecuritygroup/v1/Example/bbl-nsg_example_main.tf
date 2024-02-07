#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#   Resource Group
#--------------------------------------------------------------
module "bbl_test_rg" {

  source = "../../terraform-azurerm-resourcegroup/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  additional_tags = var.additional_tags

  add_random = var.add_random
  rnd_length = var.rnd_length
}

#--------------------------------------------------------------
#   Virtual Network
#--------------------------------------------------------------
module "bbl_test_vnet" {

    source = "../../terraform-azurerm-virtualnetwork/v1"

  # Required because this module uses 1 or more azurerm data block(s).
  depends_on = [
    module.bbl_test_rg
  ]

  # Virtual Network naming
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  additional_tags = var.additional_tags

  add_random = var.add_random
  rnd_length = var.rnd_length

  # Virtual Network settings
  resource_group_name = module.bbl_test_rg.name
  address_space       = ["10.12.0.0/16"]
  subnets = {
    "workload-snet" = {
      name              = "workload-snet"
      address_prefixes  = ["10.12.1.0/24"]
      service_endpoints = null
      pe_enable         = false
      delegation        = []
    },
    "pe-snet" = {
      name              = "pe-snet"
      address_prefixes  = ["10.12.2.0/24"]
      pe_enable         = true
      service_endpoints = null
      delegation        = []
    }
  }
}

#--------------------------------------------------------------
#   Blank NSG
#--------------------------------------------------------------
module "bbl_test_nsg1" {
  # Local use
  source = "../../terraform-azurerm-networksecuritygroup/v1"

  depends_on = [
    module.bbl_test_rg
  ]

  # NSG naming
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = "blank"
  owner           = var.owner
  au              = var.au
  additional_tags = var.additional_tags

  add_random = var.add_random
  rnd_length = var.rnd_length

  # NSG settings
  resource_group_name = module.bbl_test_rg.name
  nsg_subnet_ids = [
    module.bbl_test_vnet.map_subnet_ids["pe-snet"],
  ]
  security_rules = null
}

#--------------------------------------------------------------
#   NSG with rules
#--------------------------------------------------------------
module "bbl_test_nsg2" {
  # Local use
  source = "../../terraform-azurerm-networksecuritygroup/v1"

  depends_on = [
    module.bbl_test_rg
  ]

  # NSG naming
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = "wRules"
  owner           = var.owner
  au              = var.au
  additional_tags = var.additional_tags

  add_random = var.add_random
  rnd_length = var.rnd_length

  # NSG settings
  resource_group_name = module.bbl_test_rg.name
  nsg_subnet_ids = [
    module.bbl_test_vnet.map_subnet_ids["workload-snet"],
  ]
  security_rules = {
    # ================================  INBOUND ALLOW rules  ================================
    # ======  Default Azure NSG rules
    #   IBA_Any_Any_VNet-to-VNet
    IBA_Any_Any_VNet-to-VNet = {
      description = "Inbound Allow: Any Protocols, Any Ports, VNet to VNet"
      priority    = 4080
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "*"

      source_port_range       = "*"
      source_port_ranges      = null
      source_address_prefix   = "VirtualNetwork"
      source_address_prefixes = null

      destination_port_range       = "*"
      destination_port_ranges      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    },
    # ======  Other rules

    # ================================  OUTBOUND ALLOW rules  ================================
    # ======  Default Azure NSG rules
    #   OBA_Any_Any_VNet-to-VNet
    OBA_Any_Any_VNet-to-VNet = {
      description = "Outbound Allow: Any Protocols, Any Ports, VNet to VNet"
      priority    = 4080
      direction   = "Outbound"
      access      = "Allow"
      protocol    = "*"

      source_port_range       = "*"
      source_port_ranges      = null
      source_address_prefix   = "VirtualNetwork"
      source_address_prefixes = null

      destination_port_range       = "*"
      destination_port_ranges      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    },
    # ======  Other rules

    # ================================  DENY rules   ================================
    #   IBD-DenyAll
    IBD-DenyAll = {
      name                                         = "IBD-DenyAll"
      description                                  = "Inbound Deny: ALL Traffic"
      priority                                     = 4090
      direction                                    = "Inbound"
      access                                       = "Deny"
      protocol                                     = "*"
      source_port_range                            = "*"
      source_port_ranges                           = null
      destination_port_range                       = "*"
      destination_port_ranges                      = null
      source_address_prefix                        = "*"
      source_address_prefixes                      = null
      destination_address_prefix                   = "*"
      destination_address_prefixes                 = null
      source_application_security_group_names      = null
      destination_application_security_group_names = null
    },
    #   OBD-DenyAll
    OBD-DenyAll = {
      name                                         = "OBD-DenyAll"
      description                                  = "Outbound Deny: ALL Traffic"
      priority                                     = 4090
      direction                                    = "Outbound"
      access                                       = "Deny"
      protocol                                     = "*"
      source_port_range                            = "*"
      source_port_ranges                           = null
      destination_port_range                       = "*"
      destination_port_ranges                      = null
      source_address_prefix                        = "*"
      source_address_prefixes                      = null
      destination_address_prefix                   = "*"
      destination_address_prefixes                 = null
      source_application_security_group_names      = null
      destination_application_security_group_names = null
    }
  }
}
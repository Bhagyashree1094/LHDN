#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#


#----------------------------
# - Create a Resource Group
#----------------------------

module "resource_group_hub" {
  source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-resourcegroup/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name_hub
  iterator        = "008"
  au              = var.au
  owner           = var.owner
  product_version = var.product_version
  additional_tags = var.additional_tags

}

#----------------------------
# - Create a DDOS Plan
#----------------------------
module "ddos" {
  source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-ddos/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  iterator        = "001"
  au              = var.au
  owner           = var.owner
  product_version = var.product_version
  additional_tags = var.additional_tags

  resource_group_name = module.resource_group_hub.name

  depends_on = [ module.resource_group_hub ]
  

}


#----------------------------
# - Create a Vnet
#----------------------------

module "virtual_network_hub" {

 source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-virtualnetwork/v1"

      providers = {
        azurerm = azurerm.hubcon

      }

    env = var.env
    base_name = var.base_name
    au = var.au
    owner = var.owner
    org = var.org
    region_code = var.region_code
    additional_name = var.additional_name_hub
    iterator = "001"
    product_version = var.product_version
    ddos_plan_name = module.ddos.name
    ddos_protection_plan_enable =  true
    ddos_resource_group_name = module.resource_group_hub.name

    resource_group_name = module.resource_group_hub.name
      address_space       = ["10.3.0.0/16"]
      dns_servers         = ["10.3.1.4"]
      subnets = {
        "application-snet" = {
          address_prefixes  = ["10.3.1.0/24"]
          pe_enable         = false
          service_endpoints = ["Microsoft.Sql", "Microsoft.ServiceBus", "Microsoft.Web"]
          delegation        = []
        },
        "devops-snet" = {
          address_prefixes  = ["10.3.2.0/24"]
          service_endpoints = null
          pe_enable         = false
          delegation        = []
        },
        "pe-snet" = {
          address_prefixes  = ["10.3.3.0/24"]
          pe_enable         = true
          service_endpoints = null
          delegation        = []
        }
      }
depends_on = [ module.resource_group_spoke, module.ddos ]
}
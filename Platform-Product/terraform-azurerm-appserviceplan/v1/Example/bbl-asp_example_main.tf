#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#


#----------------------------
# - Resource Group
#----------------------------
module "bbl_rg_test" {
  # Terraform Cloud/Enterprise use
  source = "../../terraform-azurerm-storage/v1"


  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  additional_tags = var.rg_additional_tags

  add_random = var.add_random
  rnd_length = var.rnd_length
}

#----------------------------
# - Virtual Network
#----------------------------
module "test_ase_vnet" {
  # Terraform Cloud/Enterprise use
   source = "../../terraform-azurerm-vnet/v1"

  # Required because this module uses 1 or more azurerm data block(s).
  depends_on = [
    module.bbl_rg_test
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
  #additional_tags = var.additional_tags

  add_random = var.add_random
  rnd_length = var.rnd_length

  # Virtual Network settings
  resource_group_name = module.bbl_rg_test.name
  #hub_vnet_id         = var.hub_vnet_id
  #dns_servers         = [ "10.2.4.4"  ]     # Azure Firewall's Private IP, with DNS Proxy enabled
  use_remote_gateways = false

  address_space = ["10.38.0.0/16"]
  subnets = {
    "snet-ase" = {
      name              = "snet-ase"
      address_prefixes  = ["10.38.0.0/24"]
      service_endpoints = null
      pe_enable         = false
      delegation = [{
        name = "ASE-delegation"
        service_delegation = [{
          name    = "Microsoft.Web/hostingEnvironments"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }]
      }]
    },
    "snet-pe" = {
      name              = "snet-pe"
      address_prefixes  = ["10.38.1.0/24"]
      service_endpoints = null
      pe_enable         = true
      delegation        = []
    }
  }
}


#-------------------------------
# - App Service Plan
#-------------------------------
module "bbl_asp_test" {
  # Local use
  source = "../../terraform-azurerm-bbl-app-service-plan/v1"


  depends_on = [
    module.bbl_rg_test
  ]
  resource_group_name = module.bbl_rg_test.name
  org                 = var.org
  country             = var.country
  env                 = var.env
  region_code         = var.region_code
  base_name           = var.base_name
  additional_name     = var.additional_name
  iterator            = var.iterator
  owner               = var.owner
  au                  = var.au
  additional_tags     = var.asp_additional_tags

  add_random = var.add_random
  rnd_length = var.rnd_length

  # ASP settings
  kind                          = var.kind
  app_service_environment_v3_id = module.test_ase_ase.id
  maximum_elastic_worker_count  = var.maximum_elastic_worker_count
  per_site_scaling              = var.per_site_scaling
  size                          = var.size
  capacity                      = var.capacity
}

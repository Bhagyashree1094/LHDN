# Virtual Network Module

## Overview

This module creates a Virtual Network in Azure.

Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks.

VNet is similar to a traditional network that you'd operate in your own data center, but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.

## Notes

- This module only creates a single VNet with multiple subnets & subnets delegations.
- To perform the deployment, the following are required:
  - a **Resource Group** (to deploy the VNet),
  - The Service Principal (SPN) used to deploy this module **must have `Network Contributor` role or equivalent assigned** on the **subscription scope**,
- This module does not enable a `DDoS Protection Plan` on the `VNet`. If `DDoS Protection plan` enabling is required, a separate module will be used,
- This module does not create `VNet peering`. If `VNet peering` is required, a separate module will be used.

## Example

```yaml
#------------------------------------------
# - Creating VNet and associated resources
#------------------------------------------
module "bbl_vnet_test" {
  # Terraform Cloud/Enterprise use
  source  = "app.terraform.io/msftbbldeo/bbl-virtualnetwork/azurerm"
  version = "~>3.0.0"

  # Required because this module uses 1 or more azurerm data block(s).
  depends_on = [
    module.bbl_rg_test
  ]

  # Virtual Network naming
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name

  au      = var.au
  org     = var.org
  country = var.country
  owner   = var.owner

  additional_tags = var.rg_additional_tags
  add_random      = var.add_random
  rnd_length      = var.rnd_length

  # Delete during intake process
  iterator = var.iterator

  # Virtual Network settings
  resource_group_name = module.bbl_rg_test.name
  address_space       = ["10.3.0.0/16"]
  dns_servers         = ["10.3.1.4"]
  subnets = {
    "application-snet" = {
      address_prefixes  = ["10.3.1.0/24"]
      pe_enable         = false
      service_endpoints = ["Microsoft.Sql", "Microsoft.ServiceBus", "Microsoft.Web"]
      delegation        = []
    },
    "loadblancer-snet" = {
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
}
```

# Virtual Network peering module

## Overview

This terraform module creates a Virtual Network peering and associated resources in a Hub & Spoke relationship.

## Notes

- This module takes specific settings for the Hub and the Spoke peering,
- This module can be used cross-subscriptions and declares 2 `azurerm` providers:
  - `azurerm.spoke`,
  - `azurerm.hub`,
- The requires role for the SPN to establish the VNet peerings is assigned in the module,
- For peerings across subscriptions, more information are available in the article [create peering in different subscriptions](https://docs.microsoft.com/en-us/azure/virtual-network/create-peering-different-subscriptions),
- For scenarios in the same subscription, use the same provider for both.

## Security Controls

- None available as of May 30th 2022.

## Security Decisions

- None available as of May 30th 2022.

## Example

```yaml
#-----------------------------------
# - VNets peering
#-----------------------------------
module "bbl_test_vnetp" {
  providers = {
    azurerm.spoke = azurerm.spokedev
    azurerm.hub   = azurerm.hubconn
  }

  source = "../../terraform-azurerm-virtualnetwork-peering/v1"

  # virtualnetwork-peering settings
  spoke_vnet_id = module.bbl_test_vnet_spoke.id
  hub_vnet_id   = module.bbl_test_vnet_hub.id
}
```

# route-table Module

## Overview

This terraform module creates a Route table and associated resources.

Azure Virtual Network routing routes traffic between Azure, on-premises, and Internet resources. Azure automatically creates a route table for each subnet within an Azure Virtual Network and adds system default routes to the table.

Users can create custom, or user-defined (static), routes in Azure to override Azure's default system routes, or to add additional routes to a subnet's route table. They are often referred as `UDR` for User-Defined Routes.

In Azure, users can create a route table, then associate the route table to zero or more virtual network **subnets**. Each subnet can have zero or one route table associated to it.

If multiple routes contain the same address prefix, Azure selects the route type, based on the following priority:

1. User-defined route (= UDR or Route table),
2. BGP route,
3. System route.

For a more detailed discussion of these concepts, like BGP (Border Gateway Protocol) propagation or Next hop types, please refer to [Virtual network traffic routing](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview).

## Notes

- The module creates 1 Route table and multiple subnets associations,
- The Next hop IP can be fetched from previous modules outputs, like the Azure Firewall one.

## Example

```yaml
module "bbl_rt_test" {

  source = "../../terraform-azurerm-route-table/v1"

  # Required because this module uses 1 or more azurerm data block(s).
  depends_on = [
    module.bbl_aks_afw,
    module.bbl_aks_vnet
  ]

  # Route Table naming Variables
  org                 = var.org
  country             = var.country
  env                 = var.env
  region_code         = var.region_code
  base_name           = var.additional_name
  additional_tags     = var.additional_tags

  au                  = var.au
  owner               = var.owner

  # Route Table resource variables
  resource_group_name = module.bbl_rg_test.name
  route_table = {
    disable_bgp_route_propagation = true
    subnet_ids = module.bbl_aks_vnet.subnet_ids
    routes = [{
      name                   = "routeToAzFbblorInternet"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.bbl_aks_afw.private_ip_addresses[0]
    }]
  }
}
```

# Private Endpoints Module

## Overview

This terraform module creates Private Endpoint(s) for a set of resources' instance(s) compatible with:

- Either Azure Private Link enabled Azure PaaS Services, like Key Vault, Storage Accounts ([Azure Private Link availability](https://docs.microsoft.com/en-us/azure/private-link/availability)),
- Or a Private Link Service linked Azure Load Balancer ([Azure Private Link Service](https://docs.microsoft.com/en-us/azure/private-link/private-link-service-overview)).

A Private Endpoint:

- Is a network interface (NIC) that uses a private IP address from a set Virtual Network's subnet,
- This network interface allows the consumers that can access this VNet's subnet to connect to the target service privately and securely,
- By enabling a private endpoint, users can bring the service into their Virtual Network,
- Private Endpoints are generally used in conjunction with **appropriate DNS resolution** that will redirect public FQDN/URI calls by consumers to the Private endpoint NIC IP address.

## Notes

- The **subnet** the Private Endpoint(s) are deployed to must have `"privateEndpointNetworkPolicies": "Disabled"`,
- This can be verified with this [`az cli` command](https://docs.microsoft.com/en-us/cli/azure/network/vnet/subnet?view=azure-cli-latest#az-network-vnet-subnet-show):

```cli
az network vnet subnet show --resource-group <rg_name> --vnet-name <vnet_name> --name <subnet_name> --query "privateEndpointNetworkPolicies"
```

- For more information, see: [Manage network policies for private endpoints](https://docs.microsoft.com/en-us/azure/private-link/disable-private-endpoint-network-policy).

This module:

- is a major element to align with the recommended secure practices from Microsoft to use Private Endpoints for securely accessing various resources in Azure.

- is designed to be integrated with other modules that deploy secured Azure resources from a network standpoint. When integrated with other modules, the module is designed to create multiple Private Endpoints using the same private link resource.

To help the use of this design, please refer to the `\Example` folder showcasing the Private Endpoint integration with one Key Vault and one Storage Account modules.

## Example

```yaml
module "bbl_pe_test" {
  source = "../../terraform-azurerm-bbl-privateendpoints"


  depends_on = [
    module.bbl_st_test, module.bbl_kv_test
  ]

  resource_group_name = module.bbl_rg_test.name
  private_endpoints = {
    pe_kv = {
      name                          = module.bbl_kv_test.key_vault_name
      subnet_id                     = var.pe_subnet_id
      group_ids                     = ["vault"]
      approval_required             = var.pe_approval_required
      approval_message              = "Please approve Private Endpoint connection for ${module.bbl_kv_test.key_vault_name}"
      private_connection_address_id = module.bbl_kv_test.key_vault_id
    },
    pe_ampls = {
      name                          = module.bbl_ampls.name
      subnet_id                     = module.bbl_vnet.map_subnets["subnet-pe"].id
      group_ids                     = ["azuremonitor"]
      approval_required             = false
      approval_message              = "Please approve Private Endpoint connection for ${module.bbl_ampls.name}"
      private_connection_address_id = module.bbl_ampls.id
      dns_zone_group_name           = "default"
      private_dns_zone_ids          = module.bbl_pdnszones[*].id
    }
  }
}
```

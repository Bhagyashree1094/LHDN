<!-- BEGIN_TF_DOCS -->
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

## Documentation
<!-- markdownlint-disable MD033 -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.89.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bbl_rt_name"></a> [bbl\_rt\_name](#module\_bbl\_rt\_name) | app.terraform.io/msftbbldeo/bbl-module/azurerm | ~>1.0.2 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_au"></a> [au](#input\_au) | (Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters. | `string` | n/a | yes |
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | (Required) Application/Infrastructure "base" name. Example: `aks`. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) BBL environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Required) BBL technology owner group. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the resource group in which to create the Route Table. | `string` | n/a | yes |
| <a name="input_route_table"></a> [route\_table](#input\_route\_table) | (Required) The route table with its properties. | <pre>object({<br>    disable_bgp_route_propagation = bool<br>    subnet_ids                    = list(string)<br>    routes = list(object({<br>      name                   = string<br>      address_prefix         = string<br>      next_hop_type          = string<br>      next_hop_in_ip_address = string<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_add_random"></a> [add\_random](#input\_add\_random) | (Optional) When set to `true`, it will add a `rnd_length`'s long `random_number` at the name's end. | `bool` | `false` | no |
| <a name="input_additional_name"></a> [additional\_name](#input\_additional\_name) | (Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the "name's generated" suffix. Example: `lan1`. | `string` | `null` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | (Optional) Additional tags for the Route Table. | `map(string)` | `null` | no |
| <a name="input_country"></a> [country](#input\_country) | (Optional) BBL country code. Example: `us`. | `string` | `"us"` | no |
| <a name="input_iterator"></a> [iterator](#input\_iterator) | (Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the "name's generated + additional\_name" concatenation. Example: `001`. | `string` | `null` | no |
| <a name="input_org"></a> [org](#input\_org) | (Optional) BBL organization code. Example: `bbl`. | `string` | `"bbl"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | (Optional) BBL region code.<br></br>&#8226; Value of `region_code` must be one of: `[ncus,scus]`. | `string` | `"ncus"` | no |
| <a name="input_rnd_length"></a> [rnd\_length](#input\_rnd\_length) | (Optional) Set the length of the `random_number` generated. | `number` | `3` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_route_table.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table) | resource |
| [azurerm_subnet_route_table_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_route_table_association) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The Route Table ID. |

<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
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

- None

## Security Decisions

- None

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

## Documentation
<!-- markdownlint-disable MD033 -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bbl_role_assignment_hubspn_on_spokevnet"></a> [bbl\_role\_assignment\_hubspn\_on\_spokevnet](#module\_bbl\_role\_assignment\_hubspn\_on\_spokevnet) | app.terraform.io/msftbbldeo/bbl-role-assignment/azurerm | ~>1.0.1 |
| <a name="module_bbl_role_assignment_spokespn_on_hubvnet"></a> [bbl\_role\_assignment\_spokespn\_on\_hubvnet](#module\_bbl\_role\_assignment\_spokespn\_on\_hubvnet) | app.terraform.io/msftbbldeo/bbl-role-assignment/azurerm | ~>1.0.1 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hub_vnet_id"></a> [hub\_vnet\_id](#input\_hub\_vnet\_id) | (Required) The VNet ID of the HUB VNet to peer the Spoke VNet with, in a Hub to Spoke connection type. | `string` | n/a | yes |
| <a name="input_spoke_vnet_id"></a> [spoke\_vnet\_id](#input\_spoke\_vnet\_id) | (Required) The VNet ID of the SPOKE VNet to peer, in a Spoke to Hub connection type. | `string` | n/a | yes |
| <a name="input_use_remote_gateways"></a> [use\_remote\_gateways](#input\_use\_remote\_gateways) | (Optional) Allow the use of remote gateways from this VNet. | `bool` | `false` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_virtual_network_peering.hub_to_spoke](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_virtual_network_peering.spoke_to_hub](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) | resource |
| [azurerm_client_config.hub_spn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_client_config.spoke_spn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_virtual_network.hub_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
| [azurerm_virtual_network.spoke_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id_hub"></a> [id\_hub](#output\_id\_hub) | The ID of the created Virtual Network peering on the HUB side. |
| <a name="output_id_spoke"></a> [id\_spoke](#output\_id\_spoke) | The ID of the created Virtual Network peering on the SPOKE side. |

<!-- END_TF_DOCS -->
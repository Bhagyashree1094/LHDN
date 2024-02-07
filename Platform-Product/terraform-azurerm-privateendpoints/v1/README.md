<!-- BEGIN_TF_DOCS -->
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

## Documentation
<!-- markdownlint-disable MD033 -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.89.0 |

### Modules

No modules.

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints) | (Required) Map containing Private Endpoint details:<br></br><ul><li>`name`: (Required) Name of the private endpoint to be created.</li><li>`subnet_id `: (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.</li><li>`group_ids `: (Optional) A list of subresource names which the Private Endpoint is able to connect to. </li>	<li>`approval_required `: (Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.</li><li>`approval_message `: (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The request message can be a maximum of 140 characters in length. Only valid if `is_manual_connection` is set to `true`.</li><li>`private_connection_address_id `: (Required) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. </li><li>`dns_zone_group_name`: (Required) Specifies the Name of the Private DNS Zone Group. Changing this forces a new `private_dns_zone_group` resource to be created.</li><li>`private_dns_zone_ids`: (Required) Specifies the list of Private DNS Zones to include within the `private_dns_zone_group`.</li></ul> | <pre>map(object({<br>    name                          = string<br>    subnet_id                     = string<br>    group_ids                     = list(string)<br>    approval_required             = bool<br>    approval_message              = string<br>    private_connection_address_id = string<br>    dns_zone_group_name           = string<br>    private_dns_zone_ids          = list(string)<br><br>  }))</pre> | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Resource Group to create the Private Endpoint(s) in. | `string` | n/a | yes |
| <a name="input_default_approval_message"></a> [default\_approval\_message](#input\_default\_approval\_message) | (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. This is passed when the `approval_message` in the `private_endpoints` object is empty and an approval is required. | `string` | `"Please approve this private endpoint connection request"` | no |
| <a name="input_pe_additional_tags"></a> [pe\_additional\_tags](#input\_pe\_additional\_tags) | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_endpoint_ids"></a> [private\_endpoint\_ids](#output\_private\_endpoint\_ids) | Private Endpoint Id(s). |
| <a name="output_private_ip_addresses_map"></a> [private\_ip\_addresses\_map](#output\_private\_ip\_addresses\_map) | Map of Private Endpoint IP Address(es). |

<!-- END_TF_DOCS -->
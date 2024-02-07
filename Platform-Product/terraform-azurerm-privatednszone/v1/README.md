<!-- BEGIN_TF_DOCS -->
# Private DNS Zone Module

## Overview

- Azure Private DNS provides a reliable, secure DNS service to manage and resolve domain names in a virtual network without the need to add a custom DNS solution.
- By using private DNS zones, you can use your own custom domain names rather than the Azure-provided names available today.
- You can link a private DNS zone to one or more virtual networks by creating virtual network links. You can also enable the auto-registration feature to automatically manage the life cycle of the DNS records for the virtual machines that get deployed in a virtual network.

## Notes

- This module is not leveraging the BBL module because the naming restrictions for a Private DNS Zone name are:
  - The resource name must be the name of the DNS Zone itself,
  - Single-labeled private DNS zones (like `.com`, `.ca`) are NOT supported,
  - Private DNS zone must have two or more labels. For example `contoso.com` has two labels separated by a dot,
  - A private DNS zone can have a maximum of 34 labels.

## Example

```yaml
#--------------------------------------------------------------
#   Tests for Private DNS Zone module
#--------------------------------------------------------------
module "bbl_pdnsz" {
  # Terraform Cloud/Enterprise use
  source  = "app.terraform.io/msftbbldeo/bbl-privatednszone/azurerm"
  version = "~>1.1.0"

  # Private DNS Zone settings
  resource_group_name          = module.bbl_rg_test1.name
  private_dns_zone_name        = "test.bbl.com"
  private_dns_zone_vnet_links = {
    vnet1 = {
      vnet_id                   = module.bbl_aks_vnet.id
      registration_enabled      = false
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
| <a name="input_private_dns_zone_name"></a> [private\_dns\_zone\_name](#input\_private\_dns\_zone\_name) | (Required) The name of the Private DNS Zone. <br></br>&#8226; Name must have `1-63 characters`, `2 to 34 labels`, Each label is a set of characters separated by a period. For example, contoso.com has 2 labels. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the Resource Group in which to create the Private DNS Zone. | `string` | n/a | yes |
| <a name="input_dns_zone_additional_tags"></a> [dns\_zone\_additional\_tags](#input\_dns\_zone\_additional\_tags) | (Optional) A mapping of tags to assign to the Private DNS Zone resource. | `map(string)` | `{}` | no |
| <a name="input_private_dns_zone_vnet_links"></a> [private\_dns\_zone\_vnet\_links](#input\_private\_dns\_zone\_vnet\_links) | (Optional) Map containing Private DNS Zone vnet links Objects. <br></br>&#8226; The name must begin with a `letter` or `number`, end with a `letter`, `number or underscore`, and may contain only `letters`, `numbers`, `underscores`, `periods`, or `hyphens`. | <pre>map(object({<br>    vnet_id                  = string<br>    registration_enabled     = bool<br>  }))</pre> | `{}` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_zone.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_vnet_link_ids"></a> [dns\_zone\_vnet\_link\_ids](#output\_dns\_zone\_vnet\_link\_ids) | Resource Id's of the Private DNS Zone Virtual Network Link. |
| <a name="output_dns_zone_vnet_link_ids_map"></a> [dns\_zone\_vnet\_link\_ids\_map](#output\_dns\_zone\_vnet\_link\_ids\_map) | Map of Resource Id's of the Private DNS Zone Virtual Network Link. |
| <a name="output_id"></a> [id](#output\_id) | id of the DNZ zone. |
| <a name="output_name"></a> [name](#output\_name) | The DNS zone name. |

<!-- END_TF_DOCS -->
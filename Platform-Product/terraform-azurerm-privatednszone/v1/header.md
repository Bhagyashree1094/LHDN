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

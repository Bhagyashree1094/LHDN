# Copyright 2023 BBL & Microsoft. All rights reserved.

# Resource Group module

## Overview

This Terraform module creates an Azure Resource Group.

A resource group is a container that holds related resources for an Azure solution.
The resource group can include all the resources for the solution, or only those resources that needs to be managed as a group.

## Notes

None.

## Example

```yaml
module "bbl_rg_test" {
  # Terraform Cloud/Enterprise use
  source  = "../../terraform-azurerm-wf-resourcegroup"

  org                 = var.org                 # "bbl"
  country             = var.country             # "th"
  env                 = var.env                 # "prod"
  region_code         = var.region_code         # "sea"
  base_name           = var.base_name           # "app01"
  additional_name     = var.additional_name     # "team1"
  iterator            = var.iterator            # "v01"
  owner               = var.owner               # "test@bbl.com"
  au                  = var.au                  # "0212345"
  additional_tags     = var.rg_additional_tags  # Additional tags for the Resource Group
  product_version     = var.product_version

  add_random          = true
  rnd_length          = 3
}
```

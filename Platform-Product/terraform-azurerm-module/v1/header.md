# BBL module

## Overview

This BBL module provides the following features:

- From a BBL `region_code`, the module gives the Azure `location name` to use in resource's creation,
- From the BBL inputs (org, country, env, base_name, etc.) and an Azure resource abbreviation ([Recommended abbreviations for Azure resource types](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)), the module generates the resource name, according to this BBL Naming Standard:
  - [`resource_type_code`]`-`[`env`]`-`[`region_code`]`-`[`base_name`][(optional)`-additional_name`][(optional)`-iterator`][(optional - see below)`-random_number`]
- Some resources require their **name to be globally unique**:
  - To support that case, the option to set `add_random = true` is available. When activated, a `random_number`, padding 0, is added to the resource name generated. The length of the numbers added is set by the variable `rnd_length`.
- Some resources require a **maximum name length** ([Naming rules and restrictions for Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)):
  - To accommodate this need, the option `max_length` is available to set the maximum length of the generated name. It trims the name keeping its left portion. If a random number is required, it will replace the last characters of the name with the random number.
- Some resources require to be **named with characters only**:
  - To accommodate this requirement, the option `no_dashes = true` is available. When activated, dashes are removed from the generated name, even if some dashes were provided in the variables' values.

From the inputs provided to the BBL module, the following `tags` are automatically generated:

- `country = ""`
- `org = ""`
- `environment = ""`
- `owner = ""`
- `au = ""`
- `created_on = ""`
- `prodcut_version = ""`

The generated `tags` are completed with the tags eventually provided to the variable `additional_tags`,

The 3 main outputs to use in the resource(s) to create are:

- `name`
- `location`
- `tags`

## Notes

The management of the `created_on` tag is done with the help of the `time` Terraform provider. It captures the **FIRST time** the BBL module was used to generate the name and stores the date in both the tag value and the module state.

## Example

This module is used within another module to generate the resource(s) name(s) through BBL naming convention, when relevant for the resource(s).
To use it:

1. The module is called to generate a resource outputs (name, tags, location),
2. The module's outputs are used to create the resources.

### 1. Call the BBL module

```yaml
module "bbl_module_rg" {
  # Local use
  #source = "../../terraform-azurerm-wf-module"

  # org           = ""
  # country       = ""
  env             = "core"
  region_code     = "sea"
  base_name       = "bblmodule"
  additional_name = ""
  iterator        = "001"
  au              = "00121"
  owner           = "test@test.com"
  product_version = "1.0.0"
  additional_tags = {
    app_id      = "XXYY"
    test_by     = "emberger"
  }

  # Resource naming inputs
  resource_type_code  = "rg"
  max_length          = 64
  no_dashes           = false
  add_random          = true
  rnd_length          = 4
}

```

### 2. Use the module's outputs in a resource

```yaml
# Test by creating a Resource Group with the module's outputs
resource "azurerm_resource_group" "this" {
  name      = module.bbl_module_rg.name
  location  = module.bbl_module_rg.location

  tags      = module.bbl_module_rg.tags
}
```

# Network Security Group Module

## Overview

- A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources.
- For each rule, you can specify name, priority, direction, action, source, destination, ports, and protocols.
- A network security group contains zero, or as many rules as desired, within [Azure subscription limits](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/azure-subscription-service-limits?toc=/azure/virtual-network/toc.json#azure-resource-manager-virtual-networking-limits).

## Notes

- This module is major to implement the recommended secure practices from Microsoft to access resources on azure with networking rules,
- This module doesn't leverage integration with Application Security Groups currently (can be done in a future version),
- The subnets or NICs to associate to a NSG must be in the same region,
- The rule's `name` is the key given to the map entry for the rule. For example, the following rule will create a rule named `IBA_Any_Any_VNet-to-VNet`:

```
    security_rules = {
      "IBA_Any_Any_VNet-to-VNet" = {
        description = "Inbound Allow Any Protocols & Ports, VNet to VNet"
        priority    = 4080
        direction   = "Inbound"
        access      = "Allow"
        ........
      }
    }
```

- This approach allows Terraform to link its reference to the Azure one.
- This link enables rules to be changed without a destroy/create replacement pattern.
- This pattern should be avoided because of its 2 non desirable effects:

  - the necessity to run multiple times `terraform apply` to reach the end state,
  - while terraform destroys/creates the rules, the linked resource may get more connectivity than planned, **especially unwanted direct Public Internet exposure and access**.

- The prefix suggested for rules names are:
  - **IBA**: Inbound Allow,
  - **IBD**: Inbound Deny,
  - **OBA**: Outbound Allow,
  - **OBD**: Outbound Deny,

- The rule's name format suggested is:

  `<prefix>_<Protocol>_<Port>_<Source>-to-<Destination>`

  Example: `IBA_Tcp_443_Internet-to-VNet`.

## Security Controls

- None as of 09-08-2023

## Security Decisions

- None as of 09-08-2023

## Example

```yaml
#--------------------------------------------------------------
#   Tests for Network Security Group module
#--------------------------------------------------------------
module "bbl_test_nsg2" {

  source = "../../terraform-azurerm-networksecuritygroup/v1"
  depends_on = [
    module.bbl_test_rg
  ]

  # NSG naming
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = "wRules"
  owner           = var.owner
  au              = var.au
  additional_tags = var.additional_tags

  add_random      = var.add_random
  rnd_length      = var.rnd_length

  # NSG settings
  resource_group_name = module.bbl_test_rg.name
  nsg_subnet_ids      = [
    module.bbl_test_vnet.map_subnet_ids["workload-snet"],
  ]
  security_rules  = {
    "IBA_Any_Any_VNet-to-VNet" = {
      description = "Inbound Allow Any Protocols, Any Ports, VNet to VNet"
      priority    = 4080
      direction   = "Inbound"
      access      = "Allow"
      protocol    = "*"

      source_port_range       = "*"
      source_port_ranges      = null
      source_address_prefix   = "VirtualNetwork"
      source_address_prefixes = null

      destination_port_range       = "*"
      destination_port_ranges      = null
      destination_address_prefix   = "VirtualNetwork"
      destination_address_prefixes = null
    }
  }
}
```

<!-- BEGIN_TF_DOCS -->
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

- PR-030, PR-031 Conventions : Name resources accordingly.
- PR-001, PR-002 Cloud Management Plane : NSGs are used to control network traffic. No implicit network rules should exist.
- PR-052, PR-054, PR-057 Infrastructure Protection : NSGs help in filtering network traffic to Azure resources deployed in Virtual Networks. Inbound and Outbound rules can be created to restrict traffic.
- PR-053 Infrastructure Protection, Networking : Cloud resources and network traffic should be segmented based on business purpose, risk profile, security requirements, and logical environments (for example, development, test, production).
- PR-052, PR-053, PR-055, PR-056, PR-051, PR-058 Networking : Use NSGs to restrict the ingress\egress traffic to\from VNets.

## Security Decisions

- ID 3800 NW-09	The Base NSG rules (Core services allow list and deny rules) will be created and deployed by Terraform team on Spokes. Use an Azure policy to deny subnet creation without NSGs. : will be enabled using azure policy.
- ID 3801 NW-10 Start with minimum flow logs fields:  time, category, resource id, operation name, rule, Mac, flowTuples, Source IP, Destination IP, Source Port, Destination Port, Protocol, Traffic flow, Traffic decision. : will be enabled using nsg flow logs terraform module.

## Example

```yaml
#--------------------------------------------------------------
#   Tests for Network Security Group module
#--------------------------------------------------------------
module "network_security_group1" {
  source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-networksecuritygroup/v1"
    env = var.env
    base_name = var.base_name
    au = var.au
    owner = var.owner
    org = var.org
    region_code = var.region_code
    additional_name = var.additional_name_hub
    iterator = "002"
    resource_group_name = module.resource_group_hub.name
    product_version = var.product_version
    nsg_subnet_ids = [
      module.virtual_network_hub.map_subnet_ids["devops-snet"],module.virtual_network_hub.map_subnet_ids["application-snet"],
    ]
    security_rules = {
    # ================================  INBOUND ALLOW rules  ================================
    # ======  Default Azure NSG rules
    #   IBA_Any_Any_VNet-to-VNet
    IBA_Any_Any_VNet-to-VNet = {
      description = "Inbound Allow: Any Protocols, Any Ports, VNet to VNet"
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
    },
    # ======  Other rules

    # ================================  OUTBOUND ALLOW rules  ================================
    # ======  Default Azure NSG rules
    #   OBA_Any_Any_VNet-to-VNet
    OBA_Any_Any_VNet-to-VNet = {
      description = "Outbound Allow: Any Protocols, Any Ports, VNet to VNet"
      priority    = 4080
      direction   = "Outbound"
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
    },
    # ======  Other rules

    # ================================  DENY rules   ================================
    #   IBD-DenyAll
    IBD-DenyAll = {
      name                                         = "IBD-DenyAll"
      description                                  = "Inbound Deny: ALL Traffic"
      priority                                     = 4090
      direction                                    = "Inbound"
      access                                       = "Deny"
      protocol                                     = "*"
      source_port_range                            = "*"
      source_port_ranges                           = null
      destination_port_range                       = "*"
      destination_port_ranges                      = null
      source_address_prefix                        = "*"
      source_address_prefixes                      = null
      destination_address_prefix                   = "*"
      destination_address_prefixes                 = null
      source_application_security_group_names      = null
      destination_application_security_group_names = null
    },
    #   OBD-DenyAll
    OBD-DenyAll = {
      name                                         = "OBD-DenyAll"
      description                                  = "Outbound Deny: ALL Traffic"
      priority                                     = 4090
      direction                                    = "Outbound"
      access                                       = "Deny"
      protocol                                     = "*"
      source_port_range                            = "*"
      source_port_ranges                           = null
      destination_port_range                       = "*"
      destination_port_ranges                      = null
      source_address_prefix                        = "*"
      source_address_prefixes                      = null
      destination_address_prefix                   = "*"
      destination_address_prefixes                 = null
      source_application_security_group_names      = null
      destination_application_security_group_names = null
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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_wf_nsg_name"></a> [wf\_nsg\_name](#module\_wf\_nsg\_name) | app.terraform.io/msftwfdeo/wf-module/azurerm | ~>1.0.2 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_au"></a> [au](#input\_au) | (Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters. | `string` | n/a | yes |
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | (Required) Application/Infrastructure "base" name. Example: `aks`. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) BBL environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`. | `string` | n/a | yes |
| <a name="input_nsg_subnet_ids"></a> [nsg\_subnet\_ids](#input\_nsg\_subnet\_ids) | (Required) The list of the subnet IDs to be associated with the NSG. | `list(string)` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Required) BBL technology owner group. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the Resource Group in which to create the Network Security Group. | `string` | n/a | yes |
| <a name="input_add_random"></a> [add\_random](#input\_add\_random) | (Optional) When set to `true`, it will add a `rnd_length`'s long `random_number` at the name's end of the Network Security Group. | `bool` | `false` | no |
| <a name="input_additional_name"></a> [additional\_name](#input\_additional\_name) | (Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the "name's generated" suffix. Example: `lan1`. | `string` | `null` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | (Optional) Additional tags for the Network Security Group. | `map(string)` | `null` | no |
| <a name="input_country"></a> [country](#input\_country) | (Optional) BBL country code. Example: `us`. | `string` | `"us"` | no |
| <a name="input_iterator"></a> [iterator](#input\_iterator) | (Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the "name's generated + additional\_name" concatenation. Example: `001`. | `string` | `null` | no |
| <a name="input_org"></a> [org](#input\_org) | (Optional) BBL organization code. Example: `wf`. | `string` | `"wf"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | (Optional) BBL region code.<br></br>&#8226; Value of `region_code` must be one of: `[ncus,scus]`. | `string` | `"ncus"` | no |
| <a name="input_rnd_length"></a> [rnd\_length](#input\_rnd\_length) | (Optional) Set the length of the `random_number` generated. | `number` | `3` | no |
| <a name="input_security_rules"></a> [security\_rules](#input\_security\_rules) | <p>(Optional) The Network Security rules with their properties:</p><ul><li>[map key] used as `name`: (Required) The name of the security rule. This needs to be unique across all Rules in the Network Security Group.</li><li>`description`: (Optional) A description for this rule. Restricted to 140 characters.</li><li>`protocol`: (Required) Network protocol this rule applies to. Possible values include `Tcp`, `Udp`, `Icmp`, `Esp`, `Ah` or `*` (which matches all).</li><li>`direction`: (Required) The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are `Inbound` and `Outbound`.</li><li>`access`: (Required) Specifies whether network traffic is allowed or denied. Possible values are `Allow` and `Deny`.</li><li>`priority`: (Required) Specifies the priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.</li><li>`source_address_prefix`: (Optional) CIDR or source IP range or `*` to match any IP. Tags such as `VirtualNetwork`, `AzureLoadBalancer` and `Internet` can also be used. This is required if `source_address_prefixes` is not specified.</li><li>`source_address_prefixes`: (Optional) List of source address prefixes. Tags may not be used. This is required if `source_address_prefix` is not specified.</li><li>`destination_address_prefix`: (Optional) CIDR or destination IP range or `*` to match any IP. Tags such as `VirtualNetwork`, `AzureLoadBalancer` and `Internet` can also be used. Besides, it also supports all available Service Tags like `Sql.WestEurope`, `Storage.EastUS`, etc. You can list the available service tags with: `az network list-service-tags --location northcentralus`. This is required if `destination_address_prefixes` is not specified.</li><li>`destination_address_prefixes`: (Optional) List of destination address prefixes. Tags may not be used. This is required if `destination_address_prefix` is not specified.</li><li>`source_port_range`: (Optional) Source Port or Range. Integer or range between `0` and `65535` or `*` to match any. This is required if `source_port_ranges` is not specified.</li><li>`source_port_ranges`: (Optional) List of source ports or port ranges. This is required if `source_port_range` is not specified.</li><li>`destination_port_range`: (Optional) Destination Port or Range. Integer or range between `0` and `65535` or `*` to match any. This is required if `destination_port_ranges` is not specified.</li><li>`destination_port_ranges`: (Optional) List of destination ports or port ranges. This is required if `destination_port_range` is not specified.</li></ul> | <pre>map(object({<br>    description                  = string<br>    protocol                     = string<br>    direction                    = string<br>    access                       = string<br>    priority                     = number<br>    source_address_prefix        = string<br>    source_address_prefixes      = list(string)<br>    destination_address_prefix   = string<br>    destination_address_prefixes = list(string)<br>    source_port_range            = string<br>    source_port_ranges           = list(string)<br>    destination_port_range       = string<br>    destination_port_ranges      = list(string)<br>  }))</pre> | <pre>{<br>  "IBD-DenyAll": {<br>    "access": "Deny",<br>    "description": "Inbound Deny All Traffic",<br>    "destination_address_prefix": "*",<br>    "destination_address_prefixes": null,<br>    "destination_application_security_group_names": null,<br>    "destination_port_range": "*",<br>    "destination_port_ranges": null,<br>    "direction": "Inbound",<br>    "priority": 4090,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_address_prefixes": null,<br>    "source_application_security_group_names": null,<br>    "source_port_range": "*",<br>    "source_port_ranges": null<br>  },<br>  "OBD-DenyAll": {<br>    "access": "Deny",<br>    "description": "Outbound Deny All Traffic",<br>    "destination_address_prefix": "*",<br>    "destination_address_prefixes": null,<br>    "destination_application_security_group_names": null,<br>    "destination_port_range": "*",<br>    "destination_port_ranges": null,<br>    "direction": "Outbound",<br>    "priority": 4090,<br>    "protocol": "*",<br>    "source_address_prefix": "*",<br>    "source_address_prefixes": null,<br>    "source_application_security_group_names": null,<br>    "source_port_range": "*",<br>    "source_port_ranges": null<br>  }<br>}</pre> | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_subnet_network_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The generated ID of the Network Security Group. |
| <a name="output_name"></a> [name](#output\_name) | The generated name of the Network Security Group. |

<!-- END_TF_DOCS -->
<!-- BEGIN_TF_DOCS -->
# Virtual Network Module

## Overview

This module creates a Virtual Network in Azure.

Azure Virtual Network (VNet) is the fundamental building block for your private network in Azure. VNet enables many types of Azure resources, such as Azure Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks.

VNet is similar to a traditional network that you'd operate in your own data center, but brings with it additional benefits of Azure's infrastructure such as scale, availability, and isolation.

## Notes

- This module only creates a single VNet with multiple subnets & subnets delegations.
- To perform the deployment, the following are required:
  - a **Resource Group** (to deploy the VNet),
  - The Service Principal (SPN) used to deploy this module **must have `Network Contributor` role or equivalent assigned** on the **subscription scope**,
- This module does not enable a `DDoS Protection Plan` on the `VNet`. If `DDoS Protection plan` enabling is required, a separate module will be used,
- This module does not create `VNet peering`. If `VNet peering` is required, a separate module will be used.

## Example

```yaml
#----------------------------
# - Create a Vnet
#----------------------------

module "virtual_network_hub" {

 source = "../../Platform-Level/networking/Platform-Product/terraform-azurerm-virtualnetwork/v1"

      providers = {
        azurerm = azurerm.hubcon

      }

    env = var.env
    base_name = var.base_name
    au = var.au
    owner = var.owner
    org = var.org
    region_code = var.region_code
    additional_name = var.additional_name_hub
    iterator = "001"
    product_version = var.product_version
    ddos_plan_name = module.ddos.name
    ddos_protection_plan_enable =  true
    ddos_resource_group_name = module.resource_group_hub.name

    resource_group_name = module.resource_group_hub.name
      address_space       = ["10.3.0.0/16"]
      dns_servers         = ["10.3.1.4"]
      subnets = {
        "application-snet" = {
          address_prefixes  = ["10.3.1.0/24"]
          pe_enable         = false
          service_endpoints = ["Microsoft.Sql", "Microsoft.ServiceBus", "Microsoft.Web"]
          delegation        = []
        },
        "devops-snet" = {
          address_prefixes  = ["10.3.2.0/24"]
          service_endpoints = null
          pe_enable         = false
          delegation        = []
        },
        "pe-snet" = {
          address_prefixes  = ["10.3.3.0/24"]
          pe_enable         = true
          service_endpoints = null
          delegation        = []
        }
      }
depends_on = [ module.resource_group_spoke, module.ddos ]
}
```

## Documentation
<!-- markdownlint-disable MD033 -->

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.90.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bbl_vnet_name"></a> [bbl\_vnet\_name](#module\_bbl\_vnet\_name) | app.terraform.io/msftbbldeo/bbl-module/azurerm | ~>1.0.2 |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | (Required) Virtual network address space in the format of CIDR range. | `list(string)` | n/a | yes |
| <a name="input_au"></a> [au](#input\_au) | (Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters. | `string` | n/a | yes |
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | (Required) Application/Infrastructure "base" name. Example: `aks`. | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) BBL environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | (Required) BBL technology owner group. | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required) Name of the Resource Group in which to create the virtual network. | `string` | n/a | yes |
| <a name="input_add_random"></a> [add\_random](#input\_add\_random) | (Optional) When set to `true`,  it will add a `rnd_length`'s long `random_number` at the name's end. | `bool` | `false` | no |
| <a name="input_additional_name"></a> [additional\_name](#input\_additional\_name) | (Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the "name's generated" suffix. Example: `lan1`. | `string` | `null` | no |
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | (Optional) Additional tags for the virtual network. | `map(string)` | `null` | no |
| <a name="input_country"></a> [country](#input\_country) | (Optional) BBL country code. Example: `us`. | `string` | `"us"` | no |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | (Optional) Virtual network DNS server IP address. | `list(string)` | `[]` | no |
| <a name="input_iterator"></a> [iterator](#input\_iterator) | (Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the "name's generated + additional\_name" concatenation. Example: `001`. | `string` | `null` | no |
| <a name="input_org"></a> [org](#input\_org) | (Optional) BBL organization code. Example: `bbl`. | `string` | `"bbl"` | no |
| <a name="input_region_code"></a> [region\_code](#input\_region\_code) | (Optional) BBL region code.<br></br>&#8226; Value of `region_code` must be one of: `[ncus,scus]`. | `string` | `"ncus"` | no |
| <a name="input_rnd_length"></a> [rnd\_length](#input\_rnd\_length) | (Optional) Set the length of the `random_number` generated. | `number` | `2` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | (Optional) The virtual network subnets with their properties:<br></br><ul><li>[map key] used as `name`: (Required) The name of the subnet. </li><li>`address_prefixes`: (Optional) The address prefixes to use for the subnet. </li><li>`pe_enable`: (Optional) Enable or Disable network policies for the private link endpoint & private link service on the subnet. </li><li>`service_endpoints`: (Optional) The list of Service endpoints to associate with the subnet. Possible values include: `Microsoft.AzureActiveDirectory`, `Microsoft.AzureCosmosDB`, `Microsoft.ContainerRegistry`, `Microsoft.EventHub`, `Microsoft.KeyVault`, `Microsoft.ServiceBus`, `Microsoft.Sql`, `Microsoft.Storage` and `Microsoft.Web`. </li><li>`delegation` </li><ul><li>`name`: (Required) A name for this delegation. </li><li>`service_delegation` </li><ul><li>`name`: (Required) The name of service to delegate to. Possible values include `Microsoft.ApiManagement/service`, `Microsoft.AzureCosmosDB/clusters`, `Microsoft.BareMetal/AzureVMware`, `Microsoft.BareMetal/CrayServers`, `Microsoft.Batch/batchAccounts`, `Microsoft.ContainerInstance/containerGroups`, `Microsoft.ContainerService/managedClusters`, `Microsoft.Databricks/workspaces`, `Microsoft.DBforMySQL/flexibleServers`, `Microsoft.DBforMySQL/serversv2`, `Microsoft.DBforPostgreSQL/flexibleServers`, `Microsoft.DBforPostgreSQL/serversv2`, `Microsoft.DBforPostgreSQL/singleServers`, `Microsoft.HardwareSecurityModules/dedicatedHSMs`, `Microsoft.Kusto/clusters`, `Microsoft.Logic/integrationServiceEnvironments`, `Microsoft.MachineLearningServices/workspaces`, `Microsoft.Netapp/volumes`, `Microsoft.Network/managedResolvers`, `Microsoft.PowerPlatform/vnetaccesslinks`, `Microsoft.ServiceFabricMesh/networks`, `Microsoft.Sql/managedInstances`, `Microsoft.Sql/servers`, `Microsoft.StoragePool/diskPools`, `Microsoft.StreamAnalytics/streamingJobs`, `Microsoft.Synapse/workspaces`, `Microsoft.Web/hostingEnvironments`, and `Microsoft.Web/serverFarms`. </li><li>`actions`:(Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include `Microsoft.Network/networkinterfaces/*`, `Microsoft.Network/virtualNetworks/subnets/action`, `Microsoft.Network/virtualNetworks/subnets/join/action`, `Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action` and `Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action`.</ul></ul> | <pre>map(object({<br>    address_prefixes  = list(string)<br>    pe_enable         = bool<br>    service_endpoints = list(string)<br>    delegation = list(object({<br>      name = string<br>      service_delegation = list(object({<br>        name    = string<br>        actions = list(string)<br>      }))<br>    }))<br>  }))</pre> | `{}` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) | resource |
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The Virtual network ID. |
| <a name="output_location"></a> [location](#output\_location) | The location of the Virtual network. |
| <a name="output_map_subnet_ids"></a> [map\_subnet\_ids](#output\_map\_subnet\_ids) | Map of the subnet IDs. |
| <a name="output_map_subnets"></a> [map\_subnets](#output\_map\_subnets) | Map of the created subnets. |
| <a name="output_map_subnets_service_endpoints"></a> [map\_subnets\_service\_endpoints](#output\_map\_subnets\_service\_endpoints) | Map of Subnets with Service Endpoints enabled. |
| <a name="output_name"></a> [name](#output\_name) | The name of the Virtual network. |
| <a name="output_random_suffix"></a> [random\_suffix](#output\_random\_suffix) | Randomized piece of the virtual network name when "`add_random = true`". |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of Resource group in which the Virtual Network has been created. |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | IDs of the subnets. |
| <a name="output_subnets_enabled_for_private_endpoints"></a> [subnets\_enabled\_for\_private\_endpoints](#output\_subnets\_enabled\_for\_private\_endpoints) | Subnets with Private Link Endpoint AND Private Link Service policies enabled. |
| <a name="output_subnets_with_service_endpoints"></a> [subnets\_with\_service\_endpoints](#output\_subnets\_with\_service\_endpoints) | Subnets with Service Endpoints enabled. |
| <a name="output_vnet"></a> [vnet](#output\_vnet) | Details of the Virtual network. |

<!-- END_TF_DOCS -->
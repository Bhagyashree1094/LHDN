<!-- BEGIN_TF_DOCS -->
# Role-assignment Module

## Overview

This terraform module assigns Roles onto Azure Resource (scope) for an Object. Azure Role-Based access Control (Azure RBAC) is the authorization system used to manage access to Azure resources.

To grant access, **roles** are assigned to **users, groups, service principals** at a particular **scope**.

## Notes

- This module requires the `object_id` of the `Service Principal/User/Group`.
- This module does not utilize bbl naming module as no resource is being created with this module, only `built-in role` is being assigned using this module.
- This module assigns built-in `role` to `User/Service Principal/Group` for different `Azure Resource`. Please look in [documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles) for the available `built-in roles`.
- The **Service Principal/User/Group** needs to have **equivalent** or **more than** `User Access Administrator` role to assign the roles using this module.
- **Only one** value between `role_definition_id` & `role_definition_name` must be provided. If `both` or 'none' are provided, it'll return an error.
- `condition` & `condition_version` attribute are in [preview](https://docs.microsoft.com/en-us/azure/role-based-access-control/conditions-role-assignments-portal#:~:text=An%20Azure%20role%20assignment%20condition,tag%20to%20read%20the%20object.).

## Example

```yaml
#--------------------------------------------------------------
#   Assigning built-in roles to different Azure resources
#--------------------------------------------------------------
module "bbl_role_assignment_1" {
  # Local use
  source = "../../terraform-azurerm-bbl-role-assignment"


  # Role Assignment Variables
  principal_id         = var.principal_id_rg
  role_definition_name = var.role_definition_name_rg
  scope                = module.bbl_resourcegroup_1.id
}

module "bbl_role_assignment_2" {
  # Local use
  #source = "../../terraform-azurerm-bbl-role-assignment"


  # Role Assignment Variables
  principal_id       = var.principal_id_kv
  scope              = module.bbl_keyvault_1.id
  role_definition_id = var.role_definition_id_kv
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
| <a name="input_principal_id"></a> [principal\_id](#input\_principal\_id) | (Required) Provide the `Object ID` of the `Principal` `(User, Group or Service Principal)` to assign the Role to. The Principal ID is also known as the `Object ID` (for `App registrations`, it is the **`Object ID` of the underlying Managed/Enterprise Application**). | `string` | n/a | yes |
| <a name="input_scope"></a> [scope](#input\_scope) | (Required) Provide the `Resource ID` of the `Resource` in which built-in Role needs to be assigned. | `string` | n/a | yes |
| <a name="input_condition"></a> [condition](#input\_condition) | (Optional) Provide the condition that limits the resources that the role can be assigned to. | `string` | `null` | no |
| <a name="input_condition_version"></a> [condition\_version](#input\_condition\_version) | (Optional) The version of the condition. Possible values are `1.0` or `2.0`. | `string` | `null` | no |
| <a name="input_delegated_managed_identity_resource_id"></a> [delegated\_managed\_identity\_resource\_id](#input\_delegated\_managed\_identity\_resource\_id) | (Optional) Provide the delegated `Azure Resource Id` which contains a `Managed Identity`. This field is used in cross tenant scenario. The `principal_id` in this scenario must be the `object_id` of the `Managed Identity` | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | (Optional) A description for this Role Assignment. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Optional) A unique UUID/GUID for this Role Assignment - one will be generated if not specified. | `string` | `null` | no |
| <a name="input_role_definition_id"></a> [role\_definition\_id](#input\_role\_definition\_id) | (Required*) Provide the "ID" of a built-in Role. See [list of built-in Roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles). Only one of `role_definition_name` or `role_definition_id` is required: if both are provided, it will return an error (valid input is: Id XOR Name). | `string` | `null` | no |
| <a name="input_role_definition_name"></a> [role\_definition\_name](#input\_role\_definition\_name) | (Required*) Provide the "Name" of a built-in Role. See [list of built-in Roles](https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles). Only one of `role_definition_name` or `role_definition_id` is required: if both are provided, it will return an error (valid input is: Id XOR Name). | `string` | `null` | no |
| <a name="input_skip_service_principal_aad_check"></a> [skip\_service\_principal\_aad\_check](#input\_skip\_service\_principal\_aad\_check) | (Optional) If the `principal_id` is a newly provisioned `Service Principal` set this value to `true` to skip the `Azure Active Directory` check: it may fail due to replication lag. This argument is only valid if the `principal_id` is of type `Service Principal`. | `bool` | `false` | no |

### Resources

| Name | Type |
|------|------|
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The Role Assignment ID. |
| <a name="output_principal_type"></a> [principal\_type](#output\_principal\_type) | The `principal_id`'s type: e.g. `User`, `Group`, `Service Principal`, `Application`, `etc`. |

<!-- END_TF_DOCS -->
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

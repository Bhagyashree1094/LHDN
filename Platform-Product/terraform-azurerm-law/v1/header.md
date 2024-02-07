# Log Analytics Workspace module

## Overview

This Terraform module creates a Log Analytics Workspace in Azure.

A Log Analytics workspace is a unique environment for Azure Monitor log data. Each workspace has its own data repository, configuration and data sources. Solutions are configured to store their data in a particular workspace.

It can also be used to edit and run log queries with data in Azure Monitor Logs. Writing a simple query can return a set of records and then use features of Log Analytics to sort, filter, and analyze them.

## Notes

- Network Isolation feature with Azure Monitor Private Link Service (AMPLS) will be created with a separate module.
- For security lock down purposes, both public internet ingestion and query are disabled. The only way to access the Workspace is then through the AMPLS.

## Security Controls

- PR-030, PR-031 Landing Zone: Naming Conventions.
- PR-001, PR-006 Cloud Management Plane: The monitored logs get stored in Log Analytics workspace. BBL will have one central Log Analytics workspace per region for the Platform Landing Zone/MVP 1.0.

## Security Decisions

- ID 3057 SEC-04: Azure Monitor: Platform Logs will be Archived to Blob Storage After 90 Days : will be enabled using diagnostic-log terraform module.
- ID 2401 SEC-05: Centralized Log Analytics Workspaces Will Use Microsoft-Managed Keys : enabled.
- ID 3887 SEC-19: 2 Centralized Log Analytics Workspaces Will Be Deployed and Use AMPLS :  will be enabled using AMPLS terraform module.

## Example

```yaml
#--------------------------------------------
#   Creating Log Analytics Workspace
#--------------------------------------------
module "bbl_law_test" {
  # Local use
  source = "../../terraform-azurerm-law"

  depends_on = [
    module.bbl_rg_test
  ]

  resource_group_name = module.bbl_rg_test.name
  org                 = var.org
  country             = var.country
  env                 = var.env
  au                  = var.au
  owner               = var.owner
  region_code         = var.region_code
  base_name           = var.law_base_name
  additional_name     = var.law_additional_name
  additional_tags     = var.law_additional_tags
  add_random          = "true"
  rnd_length          = 3
  iterator            = var.iterator

  sku               = var.sku
  retention_in_days = var.retention_in_days
}
```

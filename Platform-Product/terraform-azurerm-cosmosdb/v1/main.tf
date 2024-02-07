#-------------------------------
# - Dependencies data resources
#-------------------------------
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#--------------------
# - Generating Local
#--------------------
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_cosmos_name.tags,
    var.additional_tags
  )
}
#-------------------------------------------------------------------------
# - Generate name for the CosmosDB with BBL Naming module
#-------------------------------------------------------------------------
# PR-030, PR-031 Landing Zone: Naming Conventions.

module "bbl_cosmos_name" {

  source = "../../terraform-azurerm-module/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  au              = var.au
  owner           = var.owner
  product_version = var.product_version
  bu              = var.bu
  app_code        = var.app_code

  # CosmosDB specifics settings
  resource_type_code = "cosmos"
  max_length         = 64
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

## CosmosDB account
resource "azurerm_cosmosdb_account" "this" {

  name                = lower(module.bbl_cosmos_name.name)
  location            = module.bbl_cosmos_name.location
  resource_group_name = data.azurerm_resource_group.this.name
  offer_type          = var.offer_type #  (Required)
  kind                = try(var.kind, "GlobalDocumentDB")
  tags                = local.tags

  enable_free_tier                      = try(var.enable_free_tier, false)
  ip_range_filter                       = try(var.ip_range_filter, null)
  enable_multiple_write_locations       = try(var.enable_multiple_write_locations, false)
  enable_automatic_failover             = try(var.enable_automatic_failover, null)
  is_virtual_network_filter_enabled     = try(var.is_virtual_network_filter_enabled, null)
  create_mode                           = try(var.create_mode, null)
  public_network_access_enabled         = try(var.public_network_access_enabled, true)
  access_key_metadata_writes_enabled    = try(var.access_key_metadata_writes_enabled, null)
  local_authentication_disabled         = try(var.local_authentication_disabled, null)
  analytical_storage_enabled            = try(var.analytical_storage_enabled, null)
  network_acl_bypass_for_azure_services = try(var.bypass_for_azure_services_enabled, null)
  network_acl_bypass_ids                = try(var.network_acl_bypass_ids, null)

  dynamic "consistency_policy" {
    for_each = try(var.consistency_policy, {}) != {} ? [var.consistency_policy] : []

    content {
      consistency_level       = var.consistency_policy.consistency_level
      max_interval_in_seconds = try(var.consistency_policy.max_interval_in_seconds, null)
      max_staleness_prefix    = try(var.consistency_policy.max_staleness_prefix, null)
    }
  }

  dynamic "geo_location" {
    for_each = var.geo_locations

    content {
      location          = try(geo_location.value.region, geo_location.value.location)
      failover_priority = geo_location.value.failover_priority
      zone_redundant    = try(geo_location.value.zone_redundant, null)
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rule != null && var.cors_rule != {} ? [var.cors_rule] : []
    content {
      allowed_headers    = try(cors_rule.value.allowed_headers, [])
      allowed_methods    = try(cors_rule.value.allowed_methods, [])
      allowed_origins    = try(cors_rule.value.allowed_origins, [])
      exposed_headers    = try(cors_rule.value.exposed_headers, [])
      max_age_in_seconds = try(cors_rule.value.exposed_headers, 3600)
    }
  }

  dynamic "capabilities" {
    for_each = try(toset(var.capabilities), [])

    content {
      name = capabilities.value
    }
  }
  dynamic "restore" {
    for_each = try(var.restore, null) != null ? [var.restore] : []
    content {
      source_cosmosdb_account_id = try(restore.value.source_cosmosdb_account_id, null)
      restore_timestamp_in_utc   = try(restore.value.restore_timestamp_in_utc, null)
      dynamic "database" {
        for_each = try(var.database, null) != null ? [var.database] : []
        content {
          name             = try(database.value.name, null)
          collection_names = try(database.value.collection_names, null)
        }
      }
    }
  }
  dynamic "capacity" {
    for_each = var.total_throughput_limit != null ? [var.total_throughput_limit] : []
    content {
      total_throughput_limit = var.total_throughput_limit
    }
  }

  dynamic "backup" {
    for_each = var.backup != null ? [var.backup] : []
    content {
      type                = try(backup.value.type, null)
      interval_in_minutes = try(backup.value.interval_in_minutes, null)
      retention_in_hours  = try(backup.value.retention_in_hours, null)
      storage_redundancy  = try(backup.value.storage_redundancy, null)
    }
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? [var.identity_type] : []
    content {
      type = var.identity_type
    }
  }
  dynamic "analytical_storage" {
    for_each = var.analytical_storage_type != null ? [var.analytical_storage_type] : []
    content {
      schema_type = var.analytical_storage_type
    }
  }
  dynamic "virtual_network_rule" {
    for_each = var.virtual_network_rule != null ? toset(var.virtual_network_rule) : []
    content {
      id                                   = try(virtual_network_rule.id, null)
      ignore_missing_vnet_service_endpoint = try(virtual_network_rule.ignore_missing_vnet_service_endpoint, null)
    }
  }
}


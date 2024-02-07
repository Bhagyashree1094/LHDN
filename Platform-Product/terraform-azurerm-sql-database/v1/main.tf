#-------------------------------
# - Dependencies data resources
#-------------------------------
data "azurerm_resource_group" "this" {
  name = var.mssql_server_resource_group_name
}

data "azurerm_mssql_server" "this" {
  name                = var.mssql_server_name
  resource_group_name = var.mssql_server_resource_group_name
}

#--------------------
# - Generating Local
#--------------------
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_sqldb_name.tags,
    var.additional_tags
  )
}

#-------------------------------------------------------------------------
# - Generate name for the MSSQL DB with BBL Naming module
#-------------------------------------------------------------------------
# PR-030, PR-031 Landing Zone: Naming Conventions.

module "bbl_sqldb_name" {

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

  # SqlDB specifics settings
  resource_type_code = "sqldb"
  max_length         = 64
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

## MSSQL Database
resource "azurerm_mssql_database" "this" {
  auto_pause_delay_in_minutes         = try(var.auto_pause_delay_in_minutes, null)
  collation                           = try(var.collation, null)
  create_mode                         = try(var.create_mode, null)
  creation_source_database_id         = try(var.creation_source_database_id, null)
  elastic_pool_id                     = try(var.elastic_pool_id, null)
  geo_backup_enabled                  = try(var.geo_backup_enabled, false)
  ledger_enabled                      = try(var.ledger_enabled, false)
  license_type                        = try(var.license_type, null)
  max_size_gb                         = try(var.max_size_gb, null)
  min_capacity                        = try(var.min_capacity, null)
  name                                = lower(module.bbl_sqldb_name.name) # (Required)
  read_replica_count                  = try(var.read_replica_count, null)
  read_scale                          = try(var.read_scale, null)
  recover_database_id                 = try(var.recover_database_id, null)
  restore_dropped_database_id         = try(var.restore_dropped_database_id, null)
  restore_point_in_time               = try(var.restore_point_in_time, null)
  sample_name                         = try(var.sample_name, null)
  server_id                           = data.azurerm_mssql_server.this.id
  sku_name                            = try(var.sku_name, null)
  storage_account_type                = try(var.storage_account_type, null)
  transparent_data_encryption_enabled = try(var.transparent_data_encryption_enabled, null)
  maintenance_configuration_name      = try(var.maintenance_configuration_name, null)


  tags           = local.tags
  zone_redundant = try(var.zone_redundant, null)

  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_policy != null ? [var.short_term_retention_policy] : []
    content {
      retention_days           = try(short_term_retention_policy.retention_days, null)
      backup_interval_in_hours = try(short_term_retention_policy.backup_interval_in_hours, null)
    }
  }

  dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention_policy != null ? [var.long_term_retention_policy] : []

    content {
      weekly_retention  = try(long_term_retention_policy.weekly_retention, null)
      monthly_retention = try(long_term_retention_policy.monthly_retention, null)
      yearly_retention  = try(long_term_retention_policy.yearly_retention, null)
      week_of_year      = try(long_term_retention_policy.week_of_year, null)
    }
  }

  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy != null ? [var.threat_detection_policy] : []

    content {
      state                      = threat_detection_policy.state
      disabled_alerts            = try(threat_detection_policy.disabled_alerts, null)
      email_account_admins       = try(threat_detection_policy.email_account_admins, null)
      email_addresses            = try(threat_detection_policy.email_addresses, null)
      retention_days             = try(threat_detection_policy.retention_days, null)
      storage_endpoint           = try(data.azurerm_storage_account.mssqldb_tdp.0.primary_blob_endpoint, null)
      storage_account_access_key = try(data.azurerm_storage_account.mssqldb_tdp.0.primary_access_key, null)
    }
  }
}

data "azurerm_storage_account" "mssqldb_tdp" {
  count = try(var.threat_detection_policy.storage_account.key, null) == null ? 0 : 1

  name                = var.storage_accounts[var.threat_detection_policy.storage_account.key].name
  resource_group_name = var.storage_accounts[var.threat_detection_policy.storage_account.key].resource_group_name
}

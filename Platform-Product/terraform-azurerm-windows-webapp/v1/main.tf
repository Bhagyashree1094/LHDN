#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: Oct. 10th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by:
# Overview:
#   This module:
#   - Creates App Service (Windows WebApp) and associated resources.

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_service_plan" "this" {
  name                = var.service_plan_id
  resource_group_name = var.resource_group_name
}

data azurerm_virtual_network "this" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "this" {

  name                 = var.subnet_id
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.resource_group_name
}


#--------------------------------------------
# - Generate the Windows Web App resource name
#--------------------------------------------
# PR-030, PR-031 Landing Zone: Standardize Naming Conventions.
module "bbl_win_webapp_name" {
  # Terraform Cloud/Enterprise use
  source = "../../terraform-azurerm-module/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  bu              = var.bu
  app_code        = var.app_code
  product_version = var.product_version

  # Windows Web App specifics settings
  resource_type_code = "as"
  max_length         = 60
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

#--------------------------------------------------
# - Generate the locals for the Windows WebApp tags
#--------------------------------------------------
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_win_webapp_name.tags,
    var.additional_tags
  )
}

#-----------------------------------
# - Azure Windows WebApp App Service
#-----------------------------------
resource "azurerm_windows_web_app" "this" {
  name                      = lower(module.bbl_win_webapp_name.name)
  resource_group_name       = data.azurerm_resource_group.this.name
  location                  = data.azurerm_resource_group.this.location
  service_plan_id           = data.azurerm_service_plan.this.id
  virtual_network_subnet_id = data.azurerm_subnet.this.id
  app_settings              = var.app_settings
  client_affinity_enabled   = var.client_affinity_enabled
  client_certificate_mode   = var.client_certificate_mode
  enabled                   = var.enabled
  https_only                = var.https_only
  zip_deploy_file = var.zip_deploy_file

  site_config {
    always_on         = lookup(var.site_config, "always_on", null)
    use_32_bit_worker = lookup(var.site_config, "use_32_bit_worker", false)

    application_stack {
      current_stack  = lookup(var.site_config.application_stack, "current_stack", null)
      dotnet_version = lookup(var.site_config.application_stack, "dotnet_version", null)
    }
    cors {
      allowed_origins     = lookup(var.site_config.cors, "allowed_origins", null)
      support_credentials = lookup(var.site_config.cors, "support_credentials", null)
    }
    virtual_application {
      physical_path = lookup(var.site_config.virtual_application, "physical_path", null)
      preload       = lookup(var.site_config.virtual_application, "preload", null)
      virtual_path  = lookup(var.site_config.virtual_application, "virtual_path", null)
      dynamic "virtual_directory" {
        for_each = var.site_config.virtual_application.virtual_directory != null ? var.site_config.virtual_application.virtual_directory : {}
        content {
          physical_path = lookup(virtual_directory.value, "physical_path", null)
          virtual_path  = lookup(virtual_directory.value, "virtual_path", null)
        }
      }
    }
    http2_enabled         = lookup(var.site_config, "http2_enabled", null)
    ftps_state            = lookup(var.site_config, "ftps_state", "FtpsOnly")
    managed_pipeline_mode = lookup(var.site_config, "managed_pipeline_mode", null)
    worker_count          = lookup(var.site_config, "worker_count", null)
    minimum_tls_version   = "1.2"
    # PR-038, PR-040 Landing zone: Encryption of data in use and in transit.
  }
  auth_settings {
    enabled                       = lookup(var.auth_settings, "enabled", false)
    runtime_version               = lookup(var.auth_settings, "runtime_version", null)
    token_refresh_extension_hours = lookup(var.auth_settings, "token_refresh_extension_hours", 1)
    token_store_enabled           = lookup(var.auth_settings, "token_store_enabled", false)
    unauthenticated_client_action = lookup(var.auth_settings, "unauthenticated_client_action", null)
  }
  logs {
    detailed_error_messages = lookup(var.logs, "detailed_error_messages", false)
    failed_request_tracing  = lookup(var.logs, "failed_request_tracing", false)
    application_logs {
      file_system_level = lookup(var.logs.application_logs, "file_system_level", null)
    }
    http_logs {
      file_system {
        retention_in_days = lookup(var.logs.http_logs.file_system, "retention_in_days", null)
        retention_in_mb   = lookup(var.logs.http_logs.file_system, "retention_in_mb", null)
      }
    }
  }
  dynamic "connection_string" {
    for_each = coalesce(var.connection_string, [])
    content {
      name  = connection_string.value["name"]
      type  = connection_string.value["type"]
      value = connection_string.value["value"]
    }
  }
  sticky_settings {
    app_setting_names       = lookup(var.sticky_settings, "app_setting_names", null)
    connection_string_names = lookup(var.sticky_settings, "connection_string_names", null)
  }

  dynamic "identity" {
    for_each = var.identity == false ? [] : tolist([var.assign_identity])
    content {
      type = var.assign_identity
    }
  }
  tags = local.tags
}

#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: November. 20st, 2023.
# Created  by: Akash
# Modified on:
# Modified by:
# Overview:
#   This module:
#   - Creates Azure Windows Virtual Machine Scale Set and associated resources,

#--------------------------------------------------
# - Dependencies data resources
#--------------------------------------------------
# RG in which to create the resource
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#-----------------------------------------------------------
# - Generate the Windows VMSS resource name with BBL module
#-----------------------------------------------------------
# Landing Zone: Standardize Naming Conventions for Tags.

module "bbl_vmss_name" {

   source = "../../terraform-azurerm-module/v1"

  # BBL ordered naming inputs
  region_code     = var.region_code
  env             = var.env
  base_name       = var.base_name
  additional_name = var.additional_name
  au               = var.au
  country         = var.country
  org             = var.org
  owner           = var.owner
  bu              = var.bu
  app_code        = var.app_code
  product_version = var.product_version


  # VNet specifics settings
  resource_type_code = "vnet"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length

  # Delete during bbl intake process
  iterator = var.iterator
}

#-------------------------------------------------- 
# - Generate the locals
#-------------------------------------------------- 
locals {

    # Identity Type for the Windows VMSS
  identityType = var.system_managed_identity_enabled == true && length(var.user_managed_identity_ids) != 0 ? (
    "SystemAssigned, UserAssigned"
    ) : (
    var.system_managed_identity_enabled == true && length(var.user_managed_identity_ids) == 0) ? (
    "SystemAssigned"
    ) : (
    var.system_managed_identity_enabled == false && length(var.user_managed_identity_ids) != 0) ? (
    "UserAssigned"
    ) : (
    null
  )

  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_vnet_name.tags,
    var.additional_tags
  )
}

#--------------------------------------------------
# - Creating a Windows VMSS
#--------------------------------------------------
resource "azurerm_windows_virtual_machine_scale_set" "windowsvmss" {
  #checkov:skip=CKV_AZURE_97:"Ensure that Virtual machine scale sets have encryption at host enabled"
  name                                              = module.bbl_vmss_name.name
  location                                          = data.azurerm_resource_group.this.location
  resource_group_name                               = data.azurerm_resource_group.this.name
  instances                                         = var.instances
  sku                                               = var.sku
  single_placement_group                            = var.single_placement_group
  computer_name_prefix                              = var.computer_name_prefix
  custom_data                                       = var.custom_data
  overprovision                                     = var.overprovision
  admin_username                                    = var.admin_username
  admin_password                                    = var.admin_password
  secure_boot_enabled                               = var.secure_boot_enabled
  do_not_run_extensions_on_overprovisioned_machines = var.overprovision == true ? true : false
  edge_zone                                         = var.edge_zone
  #encryption_at_host_enabled                        = true # 'Microsoft.Compute/EncryptionAtHost' feature should be enabled for the subscription to use Encryption at host level.
  extension_operations_enabled = false # Currently the module has no extensions hence we are keeping it as False
  platform_fault_domain_count  = var.platform_fault_domain_count
  priority                     = var.priority
  upgrade_mode                 = var.upgrade_mode
  proximity_placement_group_id = var.proximity_placement_group_id
  zone_balance                 = var.proximity_placement_group_id == null && var.zones != null ? true : false
  zones                        = var.proximity_placement_group_id == null ? var.zones : [1]
  source_image_id              = var.source_image_reference == null ? var.source_image_id : null
  user_data                    = var.user_data
  vtpm_enabled                 = var.vtpm_enabled
  provision_vm_agent           = true
  health_probe_id              = var.upgrade_mode == "Automatic" || var.upgrade_mode == "Rolling" ? var.health_probe_id : null

  dynamic "network_interface" {
    for_each = var.network_interfaces
    content {
      name                          = "${module.bbl_vmss_name.name}-nic-${index(var.network_interfaces, network_interface.value)}"
      primary                       = network_interface.value["primary"]
      dns_servers                   = network_interface.value["dns_servers"]
      enable_accelerated_networking = network_interface.value["enable_accelerated_networking"]
      enable_ip_forwarding          = network_interface.value["enable_ip_forwarding"]
      network_security_group_id     = network_interface.value["network_security_group_id"]
      ip_configuration {
        name                                         = "${module.bbl_vmss_name.name}-ip-1"
        primary                                      = true
        subnet_id                                    = network_interface.value["subnet_id"]
        application_gateway_backend_address_pool_ids = network_interface.value["application_gateway_backend_address_pool_ids"]
        application_security_group_ids               = network_interface.value["application_security_group_ids"]
        load_balancer_backend_address_pool_ids       = network_interface.value["load_balancer_backend_address_pool_ids"]
        load_balancer_inbound_nat_rules_ids          = network_interface.value["load_balancer_inbound_nat_rules_ids"]
      }
    }
  }
  os_disk {
    storage_account_type = var.os_disk.storage_account_type
    caching              = var.os_disk.caching
    dynamic "diff_disk_settings" {
      for_each = var.os_disk.caching == "ReadOnly" ? [1] : []
      content {
        option    = var.os_disk.diff_disk_settings[0].option
        placement = var.os_disk.diff_disk_settings[0].placement
      }
    }
    disk_size_gb              = var.os_disk.disk_size_gb
    disk_encryption_set_id    = var.os_disk.disk_encryption_set_id
    write_accelerator_enabled = var.os_disk.storage_account_type == "Premium_LRS" && var.os_disk.caching == "None" && substr(var.sku, 0, 9) == "Standard_M" ? true : false
  }
  additional_capabilities {
    ultra_ssd_enabled = false # It cannot be used when Encryption at host is enabled
  }
  dynamic "automatic_instance_repair" {
    for_each = var.instances == null ? [] : [1]
    content {
      enabled      = var.automatic_instance_repair[0].enabled
      grace_period = var.automatic_instance_repair[0].grace_period
    }
  }
  scale_in {
    rule                   = var.scale_in.rule
    force_deletion_enabled = var.scale_in.force_deletion_enabled
  }
  dynamic "identity" {
    for_each = local.identityType == null ? [] : ["foo"]
    content {
      type         = local.identityType
      identity_ids = length(var.user_managed_identity_ids) != 0 ? var.user_managed_identity_ids : null
    }
  }
  dynamic "plan" {
    for_each = var.image_marketplace == false || var.image_marketplace == null ? [] : [1]
    content {
      name      = var.plan.name
      publisher = var.plan.publisher
      product   = var.plan.product
    }
  }
  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }
  boot_diagnostics {
    storage_account_uri = null # It will use a Managed Storage Account to store Boot Diagnostics
  }
  termination_notification {
    enabled = var.termination_notification.enabled
    timeout = var.termination_notification.timeout
  }
  lifecycle {
    ignore_changes = [
      instances,
      os_disk[0].disk_encryption_set_id
    ]
  }
  tags = local.tags
}

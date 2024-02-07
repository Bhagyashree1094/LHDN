data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

data "azurerm_key_vault" "this" {
  resource_group_name = split("/", var.key_vault_id)[4]
  name                = split("/", var.key_vault_id)[8]
}

data "azurerm_subnet" "this" {
  resource_group_name  = split("/", var.default_nodepool_subnet_id)[4]
  virtual_network_name = split("/", var.default_nodepool_subnet_id)[8]
  name                 = split("/", var.default_nodepool_subnet_id)[10]
}
# Extracting the VNet from the subnet for the Role assignments
data "azurerm_virtual_network" "this" {
  resource_group_name = split("/", data.azurerm_subnet.this.id)[4]
  name                = split("/", data.azurerm_subnet.this.id)[8]
}

data "azurerm_log_analytics_workspace" "this" {
  count = var.log_analytics_workspace_id != null ? 1 : 0

  resource_group_name = split("/", var.log_analytics_workspace_id)[4]
  name                = split("/", var.log_analytics_workspace_id)[8]
}

data "azurerm_container_registry" "this" {
  count = var.acr_id != null ? 1 : 0

  resource_group_name = split("/", var.acr_id)[4]
  name                = split("/", var.acr_id)[8]
}

# # - To accomodate a BYO Private DNS Zone from another subscription, comment this block
# data "azurerm_private_dns_zone" "this" {
#   # providers = {
#   #   azurerm = azurerm.hub
#   # }

#   count = var.private_dns_zone_id != null ? 1 : 0

#   name                = reverse(split("/", var.private_dns_zone_id))[0]
#   resource_group_name = split("/", var.private_dns_zone_id)[4]
# }

# -
# - Get the current user/app config
# -
data "azurerm_client_config" "current" {}

# 
# - Generate the AKS cluster name
# 
# PR-030, PR-031 Landing Zone: Standardize Naming Conventions.
module "lhdn_kubernetes_cluster_name" {


  source = "../../terraform-azurerm-module/v1"

  # lhdn ordered naming inputs
  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  # au              = var.au
  owner    = var.owner
  bu       = var.bu
  app_code = var.app_code
  # product_version = var.product_version

  # kubernetes-cluster specifics settings
  resource_type_code = "aks"
  max_length         = 63
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

# 
# - Generate the locals
# 
locals {
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.lhdn_kubernetes_cluster_name.tags,
    var.additional_tags
  )
}


# -
# - Generate Private/Public SSH Key for AKS Nodes and store it in Key vault
# -
# PR-150, PR-040 Encryption in transit: Create an HTTPS ingress controller and use your own TLS certificates for your Azure Kubernetes Service (AKS) deployments 
# PR-057: Infrastructure Protection: SSH to the AKS nodes, use kubectl debug or the private IP address. lhdn can also route connections through a bastion host or jump box.
resource "tls_private_key" "this" {

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "random_password" "this" {

  length           = 16
  min_lower        = 16 - 4
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_%@"
}

resource "azurerm_key_vault_secret" "pem" {
  name         = "${module.lhdn_kubernetes_cluster_name.name}-pem"
  value        = tls_private_key.this.private_key_pem
  key_vault_id = data.azurerm_key_vault.this.id
}

# resource "azurerm_key_vault_secret" "wp" {
#   name         = "${module.lhdn_kubernetes_cluster_name.name}-windowspass"
#   value        = random_password.this.result
#   key_vault_id = data.azurerm_key_vault.this.id
# }

resource "random_pet" "this" {
  length    = 2
  separator = "-"
}

resource "azurerm_key_vault_secret" "login" {
  name         = "${module.lhdn_kubernetes_cluster_name.name}-login"
  value        = random_pet.this.id
  key_vault_id = data.azurerm_key_vault.this.id
}

#####################################################
# Creation of Azure Kubernetes Cluster 
#####################################################
# - Create kubernetes-cluster with default node pool
resource "azurerm_kubernetes_cluster" "this" {

  name                                = module.lhdn_kubernetes_cluster_name.name
  resource_group_name                 = data.azurerm_resource_group.this.name
  node_resource_group                 = "${data.azurerm_resource_group.this.name}-MC"
  location                            = module.lhdn_kubernetes_cluster_name.location
  sku_tier                            = var.sku_kubernetes_cluster
  private_cluster_enabled             = true
  kubernetes_version                  = var.aks_cluster.kubernetes_version
  private_dns_zone_id                 = var.private_dns_zone_id != null ? var.private_dns_zone_id : "None"
  dns_prefix_private_cluster          = var.private_dns_zone_id != null ? var.aks_cluster.dns_prefix : null
  dns_prefix                          = var.private_dns_zone_id == null ? var.aks_cluster.dns_prefix : null
  local_account_disabled              = true
  automatic_channel_upgrade           = var.aks_cluster.automatic_channel_upgrade # https://docs.microsoft.com/en-us/azure/aks/upgrade-cluster#set-auto-upgrade-channel
  azure_policy_enabled                = true                                      # coalesce(var.aks_cluster.azure_policy_enabled, true)
  private_cluster_public_fqdn_enabled = var.private_dns_zone_id == null ? true : false
  http_application_routing_enabled    = false
  open_service_mesh_enabled           = coalesce(var.aks_cluster.open_service_mesh_enabled, false)

  # maintenance_window {
  #   allowed {
  #     day = "Sunday"
  #     hour = 1
  #   }
  # }

  default_node_pool {
    name    = var.aks_cluster.default_node_pool.name
    vm_size = var.aks_cluster.default_node_pool.vm_size
    # orchestrator_version   = coalesce(var.aks_cluster.default_node_pool.orchestrator_version, var.aks_cluster.kubernetes_version)
    enable_auto_scaling    = true
    enable_host_encryption = false # Must be enabled at Subscription level to be used.
    enable_node_public_ip  = false
    # kubelet_config {
    #   container_log_max_size_mb = 10
    # }
    # linux_os_config {
    # }
    fips_enabled                 = false
    kubelet_disk_type            = "OS"
    max_pods                     = var.aks_cluster.default_node_pool.max_pods # [10..250]
    node_labels                  = var.aks_cluster.default_node_pool.node_labels
    only_critical_addons_enabled = false
    # node_taints                  = coalesce(var.aks_cluster.default_node_pool.node_taints, [])
    os_disk_type      = var.aks_cluster.default_node_pool.os_disk_type
    os_disk_size_gb   = var.aks_cluster.default_node_pool.os_disk_size_gb
    os_sku            = coalesce(var.aks_cluster.default_node_pool.os_sku, "Ubuntu")
    type              = "VirtualMachineScaleSets"
    tags              = local.tags
    ultra_ssd_enabled = coalesce(var.aks_cluster.default_node_pool.ultra_ssd_enabled, false)
    upgrade_settings {
      max_surge = 3
    }
    # PR-052 Infrastructure Protection : Deploy AKS cluster into existing Azure virtual network subnets to connect to lhdn on premises network via the Virtual Hub in both the regions. 
    vnet_subnet_id = data.azurerm_subnet.this.id

    max_count  = var.aks_cluster.default_node_pool.max_count  # [1..1000]
    min_count  = var.aks_cluster.default_node_pool.min_count  # [1..1000]
    node_count = var.aks_cluster.default_node_pool.node_count # [min_count..max_count]
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = random_pet.this.id
    ssh_key {
      key_data = tls_private_key.this.public_key_openssh
    }
  }

  # windows_profile {
  #   admin_username = random_pet.this.id
  #   admin_password = random_password.this.result
  #   license = "Windows_Server"
  # }

  network_profile {
    network_plugin    = "azure"
    outbound_type     = "loadBalancer"
    service_cidr      = coalesce(var.aks_cluster.service_address_range, "10.0.0.0/16")
    dns_service_ip    = coalesce(var.aks_cluster.dns_service_ip, "10.0.0.10")
    network_policy    = "azure"
    load_balancer_sku = "standard"
  }
  # PR-022, PR-023, PR-024 IAM : Azure role-based access control can grant users and groups only the amount of access users 
  role_based_access_control_enabled = true
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = var.aad_admin_group_object_ids
    tenant_id              = data.azurerm_client_config.current.tenant_id
  }

  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id == null ? toset([]) : toset([1])
    content {
      log_analytics_workspace_id = data.azurerm_log_analytics_workspace.this[0].id
    }
  }

  # PR-034- Data protection: Rotate cryptographic keys.
  dynamic "key_vault_secrets_provider" {
    for_each = var.aks_cluster.secret_rotation_enabled == true ? toset([1]) : toset([])
    content {
      secret_rotation_enabled  = true
      secret_rotation_interval = var.aks_cluster.secret_rotation_interval # var.aks_cluster.secret_rotation_enabled != null ? var.aks_cluster.secret_rotation_interval : null
    }
  }

  # PR-051: Azure Platform: Configure AKS node with an HTTP proxy.
  # dynamic "http_proxy_config" {
  #   for_each = var.aks_cluster.http_proxy != null || var.aks_cluster.https_proxy != null ? toset([1]) : toset([])
  #   content {
  #     http_proxy  = var.aks_cluster.http_proxy
  #     https_proxy = var.aks_cluster.https_proxy
  #     no_proxy    = var.aks_cluster.no_proxy
  #     trusted_ca  = var.aks_cluster.https_proxy != null ? filebase64("trustedca.pem") : null
  #   }
  # }

  auto_scaler_profile {
    balance_similar_node_groups  = var.aks_cluster.auto_scaler_profile.balance_similar_node_groups
    max_graceful_termination_sec = var.aks_cluster.auto_scaler_profile.max_graceful_termination_sec
    # scale_down_delay_after_add       = var.aks_cluster.auto_scaler_profile.scale_down_delay_after_add
    # scale_down_delay_after_delete    = var.aks_cluster.auto_scaler_profile.scale_down_delay_after_delete
    # scale_down_delay_after_failure   = var.aks_cluster.auto_scaler_profile.scale_down_delay_after_failure
    # scan_interval                    = var.aks_cluster.auto_scaler_profile.scan_interval
    # scale_down_unneeded              = var.aks_cluster.auto_scaler_profile.scale_down_unneeded
    # scale_down_unready               = var.aks_cluster.auto_scaler_profile.scale_down_unready
    # scale_down_utilization_threshold = var.aks_cluster.auto_scaler_profile.scale_down_utilization_threshold
  }

  tags = local.tags

  # lifecycle {
  #   ignore_changes = [
  #     http_proxy_config.0.no_proxy,
  #     default_node_pool.0.node_count
  #   ]
  # }
}

#-----------------------------------------
# - Create additional node pools for AKS
#-----------------------------------------
resource "azurerm_kubernetes_cluster_node_pool" "this" {
  for_each = var.aks_extra_node_pools == null ? {} : var.aks_extra_node_pools

  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  name                  = each.value["name"]
  vm_size               = each.value["vm_size"]
  orchestrator_version  = lookup(each.value, "orchestrator_version", var.aks_cluster.kubernetes_version)
  vnet_subnet_id        = each.value["subnet_id"]

  enable_auto_scaling = true
  mode                = "User"

  os_sku            = lookup(each.value, "os_sku", null)
  os_disk_type      = lookup(each.value, "os_disk_type", null)
  os_disk_size_gb   = lookup(each.value, "os_disk_size_gb", null)
  ultra_ssd_enabled = lookup(each.value, "ultra_ssd_enabled", false)

  max_pods   = lookup(each.value, "max_pods", null)
  min_count  = each.value.min_count
  max_count  = each.value.max_count
  node_count = each.value.node_count

  node_labels = each.value["node_labels"]
  # node_taints = coalesce(each.value["node_taints"], [])

  tags = local.tags

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}

# -
# - Assigning required roles for Key vault secrets (CSI) provider to access Key vault and expose CSI to K8S
# -
module "lhdn_role-assignment_aksmsi_on_kv" {
  # Local use
  source = "../../terraform-azurerm-role-assignment/v1"

  count = var.aks_cluster.secret_rotation_enabled == true ? 1 : 0

  # Role Assignment 
  principal_id         = azurerm_kubernetes_cluster.this.key_vault_secrets_provider.0.secret_identity.0.object_id
  role_definition_name = "Key Vault Reader"
  scope                = data.azurerm_key_vault.this.id
}
module "lhdn_role-assignment_aksmsi_on_node-rg" {
  # Local use
  source = "../../terraform-azurerm-role-assignment/v1"

  count = var.aks_cluster.secret_rotation_enabled == true ? 1 : 0

  # Role Assignment 
  principal_id         = azurerm_kubernetes_cluster.this.key_vault_secrets_provider.0.secret_identity.0.object_id
  role_definition_name = "Virtual Machine Contributor"
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_kubernetes_cluster.this.node_resource_group}"
}
#*/
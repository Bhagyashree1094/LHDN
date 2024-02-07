app_code                   = "myinvois"
bu                         = "se"
env                        = "dev"
owner                      = "lh"
resource_group_name        = "SEA-DEV-MYINVOIS-RG"
key_vault_id               = "/subscriptions/bb03611c-e0e3-48f6-a773-6a9dc9f480cf/resourceGroups/SEA-DEV-MYINVOIS-RG/providers/Microsoft.KeyVault/vaults/SEA-DEV-MYINVOIS-KV"
default_nodepool_subnet_id = "/subscriptions/bb03611c-e0e3-48f6-a773-6a9dc9f480cf/resourceGroups/SEA-DEV-MYINVOIS-NETWORK-RG/providers/Microsoft.Network/virtualNetworks/SEA-DEV-MYINVOIS-VNET/subnets/aks-subnet"
acr_id                     = "/subscriptions/bb03611c-e0e3-48f6-a773-6a9dc9f480cf/resourceGroups/SEA-DEV-MYINVOIS-RG/providers/Microsoft.ContainerRegistry/registries/seadevmyinvoisacr"
aks_cluster = {
  kubernetes_version = "1.28" # az aks get-versions --location northcentralus --output table
  # docker_bridge_cidr        = "10.10.0.0/16"
  service_address_range     = "10.10.0.0/16"
  dns_service_ip            = "10.10.0.3"
  dns_prefix                = "test"  # must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number.
  automatic_channel_upgrade = "null" # Possible values are: patch, rapid, node-image and stable, OR null to get a "none".
  open_service_mesh_enabled = false
  secret_rotation_enabled   = true
  secret_rotation_interval  = "2m"
  # http_proxy                = "10.10.0.5"
  # https_proxy               = "10.10.0.7"
  # no_proxy                  = "null"

  default_node_pool = {
    name              = "default"
    vm_size           = "Standard_D2_v2"
    max_pods          = 10 # [10..250]
    ultra_ssd_enabled = false
    os_sku            = "AzureLinux"
    os_disk_type      = "Managed"
    os_disk_size_gb   = 128
    max_count         = 2 # [1..1000]
    min_count         = 1 # [1..1000]
    node_count        = 1 # [min_count..max_count]
    node_labels       = { "Env" = "Dev" }
    # node_taints          = list(string)
  }

  auto_scaler_profile = {
    balance_similar_node_groups  = true
    max_graceful_termination_sec = 5
    # scale_down_delay_after_add       = string
    # scale_down_delay_after_delete    = string
    # scale_down_delay_after_failure   = string
    # scan_interval                    = string
    # scale_down_unneeded              = string
    # scale_down_unready               = string
    # scale_down_utilization_threshold = number
  }
}


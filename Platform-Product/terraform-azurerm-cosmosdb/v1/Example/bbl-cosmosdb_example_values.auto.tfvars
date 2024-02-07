org             = "bbl"
country         = "th"
env             = "dev"
base_name       = "TBD"
region_code     = "sea"
bu              = "TBD"
app_code        = "database"
app_code_sec    = "nosql"
au              = "123456"
owner           = "TBD"
product_version = "0.0.1"
additional_tags = {
  created_by = "chanuwit"
  Level      = "Level-4"
  date       = "2023-09-29"
}
env_nprd = "nonprod"

resource_group_name = "RG-BBL-DEV-SEA-DL-APP-01"
offer_type                        = "Standard"
kind                              = "GlobalDocumentDB"
enable_free_tier                  = true
ip_range_filter                   = "1.1.1.1"
enable_multiple_write_locations   = false
public_network_access_enabled     = false
analytical_storage_enabled        = false
bypass_for_azure_services_enabled = true
consistency_policy = {
  consistency_level       = "BoundedStaleness"
  max_interval_in_seconds = 300
  max_staleness_prefix    = 100000
}
geo_locations = [
  {
    location          = "southeastasia"
    failover_priority = 0
    zone_redundant    = false
  }
]
total_throughput_limit = 1000
backup = {
  type                = "Periodic"
  interval_in_minutes = 1440
  retention_in_hours  = 720
  storage_redundancy  = "Local"
}
identity_type = "SystemAssigned"






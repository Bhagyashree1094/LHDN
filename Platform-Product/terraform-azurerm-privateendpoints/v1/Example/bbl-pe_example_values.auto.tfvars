#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# RG values
org                = "bbl"
country            = "bk"
env                = "test"
region_code        = "sea"
base_name          = "privendpmodule"
au                 = "22222"
owner              = "app1@bbl.com"
#rg_additional_name = "01"
rg_additional_tags = {
  test_by = "akash"
}

#-
#- Key Vault variables
#-
kv_additional_name = "kv"
rnd_length         = 3
randomize_name     = true

# Key Vault Poperties
sku_name                        = "standard"
enabled_for_deployment          = false
enabled_for_disk_encryption     = false
enabled_for_template_deployment = false
purge_protection_enabled        = false

## The value below is REQUIRED to provide access to key vault for the terraform service principal. Please provide the object Id of the SPN.
tf_client_object_id = "bfb99562-fc0b-4b3c-a34e-562342ec2cd8"

# Key Vault Access Policies
access_policies = {
  access_policy1 = {
    object_ids              = ["148d6565-b160-46fc-9515-3a6cc1038fcd"] # Object Id of the user to grant access to
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "Set", "List", "Delete", "Purge"]
    group_names             = []
    user_principal_names    = []
    certificate_permissions = []
    storage_permissions     = []
  }
}

# Secrets
secrets = {
  secret1-name = "secret1-value"
  secret2-name = "secret2-value"
}

# Key Vault Network Rules
network_acls = {
  bypass                     = "None"
  default_action             = "Deny"
  ip_rules                   = ["123.123.123.123"]
  virtual_network_subnet_ids = []
}

# -
# - Storage account
# -
st_containers = {
  container1 = {
    name                  = "container1"
    container_access_type = "private"
  }
  container2 = {
    name                  = "container2"
    container_access_type = "private"
  }
}
st_blobs = {
  # Requires a "Storage Blob Data *" role assigned to see blobs in Portal
  blob1 = {
    name                   = "blob1incontainer1"
    storage_container_name = "container1"
    type                   = "Block"
    size                   = 1024
    content_type           = null
    source_uri             = null
    metadata               = {}
  }
  blob2 = {
    name                   = "blob2incontainer1"
    storage_container_name = "container1"
    type                   = "Block"
    size                   = 1024
    content_type           = null
    source_uri             = null
    metadata               = {}
  }
  blob3 = {
    name                   = "blob3incontainer2"
    storage_container_name = "container2"
    type                   = "Block"
    size                   = 1024
    content_type           = null
    source_uri             = null
    metadata               = {}
  }
}
st_queues = {
  queue1 = {
    name = "queue1"
  }
}
st_file_shares = {
  share1 = {
    name  = "share1"
    quota = "16"
  }
}
st_tables = {
  table1 = {
    name = "table1"
  }
}

# Private Endpoints Values
pe_subnet_id         = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/resourceGroups/bbl-cus-core-rg-network/providers/Microsoft.Network/virtualNetworks/bbl-scus-core-vnet-001/subnets/bbl-scus-core-vnet-001-snet-pe"
pe_approval_required = false
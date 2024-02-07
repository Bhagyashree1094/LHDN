#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# RG values
org                = "bbl"
country            = "th"
env                = "test"
base_name          = "kvmodule"
au                 = "22222"
owner              = "app1@bbl.com"
iterator           = 003
rg_additional_name = "78"
rg_additional_tags = {
  test_by = "akash"
}
region_code = "sea"

# Key Vault variables
kv_additional_name = "kv1"
rnd_length         = 3
add_random         = true

kv_additional_tags = {
  test_by = "akash"
}

# Key Vault Properties
enabled_for_deployment          = false
enabled_for_disk_encryption     = false
enabled_for_template_deployment = false

# Secrets
secrets = {
  secret1-name = "secret1-value"
  secret2-name = "secret2-value"
}

# Key Vault Network Rules
network_acls = {
  bypass                     = "None"            # (Required) Specifies which traffic can bypass the network rules. Possible values are AzureServices and None.
  default_action             = "Deny"            # (Required) The Default Action to use when no rules match from ip_rules / virtual_network_subnet_ids. Possible values are Allow and Deny.
  ip_rules                   = ["123.123.123.1"] # (Optional) One or more Public IP Addresses, or CIDR Blocks which should be able to access the Key Vault.
  virtual_network_subnet_ids = []                # (Optional) One or more Subnet ID's which should be able to access this Key Vault.
}

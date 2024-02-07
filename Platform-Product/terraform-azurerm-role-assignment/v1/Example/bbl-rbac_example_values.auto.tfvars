#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# RG values
org                = "bbl"
country            = "th"
env                = "test"
base_name          = "emberger"
au                 = "004545"
owner              = "app1@bbl.com"
rg_additional_name = "rbacmodule"
product_version = "1.0.0"
rg_additional_tags = {
  test_by = "emberger"
}
region_code = "sea"

# Role Assignment
spn_principal_id  = "4c44665e-4723-4fb7-ab05-df5748eb0615" # sp-emberger-tests /Enterprise Application Object ID
spn_role_name     = "AcrDelete"

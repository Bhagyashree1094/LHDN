#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#--------------------------------------------------------------
#- bbl values
#--------------------------------------------------------------
org             = "bbl"
country         = "th"
region_code     = "sea"
env             = "core"
base_name       = "asp"
additional_name = "msft"
iterator        = "001"

add_random = false
rnd_length = 2

au    = "22222"
owner = "app1@bbl.com"
rg_additional_tags = {
  test_by = "msft"
}
asp_additional_tags = {
  test_by  = "akash"
  resource = "asp"
}

# ASP values
kind                          = "Windows"
per_site_scaling              = false
maximum_elastic_worker_count  = 2
capacity                      = 2
size                          = "I1v2"
app_service_environment_v3_id = "/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/resourceGroups/rg-scus-core-ase1-msft-001-1370/providers/Microsoft.Web/hostingEnvironments/ase-scus-core-ase1-msft-001-1527"
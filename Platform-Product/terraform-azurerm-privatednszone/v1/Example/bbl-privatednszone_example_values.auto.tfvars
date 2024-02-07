#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-
#- RG values
#-
org                 = "wf"
country             = "us"
env                 = "test"
base_name           = "pdnsmodule"
au                  = "33333"
owner               = "app1@bbl.com"
rg_additional_name  = "01"
rg_additional_tags = {
  test_by = "emberger"
}
region_code = "sea"


#
# - Private DNS Zone values
#
private_dns_zone_name = "pdnstest.bbl.com"
private_dns_zone_vnet_links = {
  vnet1 = {
    vnet_id                  = ""
    registration_enabled     = true   # only 1 per Private DNZ zones is allowed
  },
  vnet2 = { zone_to_vnet_link_name   = "second-vnet-link"
    vnet_id                  = ""
    registration_enabled     = false
  }
}

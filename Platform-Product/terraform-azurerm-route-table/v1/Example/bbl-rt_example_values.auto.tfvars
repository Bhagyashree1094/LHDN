#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# RG values
org                = "bbl"
country            = "bkk"
env                = "test"
base_name          = "rt1"
au                 = "22222"
owner              = "app1@bbl.com"
rg_additional_name = "01"
rg_additional_tags = {
  test_by = "akash"
}
region_code = "sea"

# Route Table variables
rt_additional_name = "route"
iterator           = 01
add_random         = true
rnd_length         = 3

route_table = {
  disable_bgp_route_propagation = true
  subnet_ids                    = ["/subscriptions/1901eaa9-e98f-49b6-ac39-b1cd55defe19/resourceGroups/rg-ncus-test-network-rg-app-01/providers/Microsoft.Network/virtualNetworks/vnet-ncus-test-network-rg-app-01/subnets/application"]
  routes = [{
    name                   = "aksroute"
    address_prefix         = "10.0.2.0/24"
    next_hop_type          = "None"
    next_hop_in_ip_address = null
  }]
}
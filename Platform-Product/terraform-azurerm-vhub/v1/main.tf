#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# Created  on: August 06th, 2023.
# Created  by: Akash Choudhary
# Modified on: 
# Modified by: 

# Overview:
#   This module:
#   - Creates a Virtual Hub and it associated properties.

#------------------------------
# - Dependencies data resource
#------------------------------

data "azurerm_resource_group" "this" {
  name = var.resource_group_name_vwan
}
data "azurerm_resource_group" "prod" {
  provider = azurerm.network
  name = var.resource_group_name_prod
}

data "azurerm_resource_group" "nprod" {
  provider = azurerm.network
  name = var.resource_group_name_nprod
}

data "azurerm_resource_group" "identity" {
  provider = azurerm.identity
  name = var.resource_group_name_identity
}

data "azurerm_resource_group" "security" {
  provider = azurerm.security
  name = var.resource_group_name_security
}

data "azurerm_resource_group" "build" {
  provider = azurerm.build
  name = var.resource_group_name_build
}

data "azurerm_resource_group" "mgmt" {
  provider = azurerm.mgmt
  name = var.resource_group_name_mgmt
}


data "azurerm_virtual_wan" "this" {
  provider = azurerm.network
  name                = var.virtual_wan_name
  resource_group_name = var.resource_group_name_vwan
}

data azurerm_virtual_network "prod" {
  provider = azurerm.network
  name                = var.virtual_network_name_prod
  resource_group_name = var.resource_group_name_prod
}

data azurerm_virtual_network "prod_1" {
  provider = azurerm.network
  name                = var.virtual_network_name_prod_1
  resource_group_name = var.resource_group_name_prod
}

data azurerm_virtual_network "nprod" {
  provider = azurerm.network
  name                = var.virtual_network_name_nprod
  resource_group_name = var.resource_group_name_nprod
}

data azurerm_virtual_network "nprod_2" {
  provider = azurerm.network
  name                = var.virtual_network_name_nprod_2
  resource_group_name = var.resource_group_name_nprod
}

data azurerm_virtual_network "identity" {
  provider = azurerm.identity
  name                = var.virtual_network_name_identity
  resource_group_name = var.resource_group_name_identity
}

data azurerm_virtual_network "security" {
  provider = azurerm.security
  name                = var.virtual_network_name_security
  resource_group_name = var.resource_group_name_security
}

data azurerm_virtual_network "build" {
  provider = azurerm.build
  name                = var.virtual_network_name_build
  resource_group_name = var.resource_group_name_build
}

data azurerm_virtual_network "mgmt" {
  provider = azurerm.mgmt
  name                = var.virtual_network_name_mgmt
  resource_group_name = var.resource_group_name_mgmt
}

#------------------------------
# - Generate the Virtual Hub Name.
#------------------------------
module "bbl_vhub_name" {

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
  resource_type_code = "vhub"
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
  
  tags = merge(
    data.azurerm_resource_group.this.tags,
    module.bbl_vhub_name.tags,
    var.additional_tags
  )
}

#------------------------------
# - Create the Virtual hub.
#------------------------------
resource "azurerm_virtual_hub" "this" {
  name                    = lower(module.bbl_vhub_name.name)
  location                = module.bbl_vhub_name.location
  resource_group_name     = data.azurerm_resource_group.this.name
  address_prefix          = var.address_prefix_hub
  virtual_wan_id          = data.azurerm_virtual_wan.this.id 
  hub_routing_preference  = var.hub_routing_preference
  sku                     = var.sku 
  virtual_router_auto_scale_min_capacity = 10
#   dynamic "route" {
#     for_each = var.address_prefixes && var.next_hop_ip_address != null ? [1] : [] 
#     content {
#     address_prefixes = var.address_prefixes 
#     next_hop_ip_address = var.next_hop_ip_address
#   }
# }
  tags                    = local.tags
}

resource "azurerm_virtual_hub_connection" "prod" {
  name                      = "vnet-connection-vhub-prod-001"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.prod.id
  depends_on = [ azurerm_virtual_hub.this ]
}

resource "azurerm_virtual_hub_connection" "prod_1" {
  name                      = "vnet-connection-vhub-prod-002"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.prod_1.id
  depends_on = [ azurerm_virtual_hub.this ]
}
resource "azurerm_virtual_hub_connection" "nprod" {
  name                      = "vnet-connection-vhub-nprod-001"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.nprod.id
  depends_on = [ azurerm_virtual_hub.this ]
}

resource "azurerm_virtual_hub_connection" "nprod_2" {
  name                      = "vnet-connection-vhub-nprod-002"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.nprod_2.id
  depends_on = [ azurerm_virtual_hub.this ]
}

resource "azurerm_virtual_hub_connection" "identity" {
  name                      = "vnet-connection-vhub-identity"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.identity.id
  depends_on = [ azurerm_virtual_hub.this ]
}

resource "azurerm_virtual_hub_connection" "security" {
  name                      = "vnet-connection-vhub-security"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.security.id
  depends_on = [ azurerm_virtual_hub.this ]
}

resource "azurerm_virtual_hub_connection" "build" {
  name                      = "vnet-connection-vhub-build"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.build.id
  depends_on = [ azurerm_virtual_hub.this ]
}

resource "azurerm_virtual_hub_connection" "mgmt" {
  name                      = "vnet-connection-vhub-mgmt"
  virtual_hub_id            = azurerm_virtual_hub.this.id
  remote_virtual_network_id = data.azurerm_virtual_network.mgmt.id
  depends_on = [ azurerm_virtual_hub.this ]
}

resource "azurerm_vpn_gateway" "this" {
  name                = "vpn-gateway-vhub-01"
  resource_group_name = azurerm_virtual_hub.this.resource_group_name
  location            = azurerm_virtual_hub.this.location
  virtual_hub_id      = azurerm_virtual_hub.this.id
  scale_unit          = var.vpn_scale_unit
  tags                = local.tags
}

resource "azurerm_vpn_site" "this" {
  name                = "vpn-site-vwan-01"
  location            = azurerm_virtual_hub.this.location
  resource_group_name = azurerm_virtual_hub.this.resource_group_name
  virtual_wan_id      = data.azurerm_virtual_wan.this.id 
  address_cidrs       = var.vpn_address_cidrs
  device_vendor       = var.device_vendor
  link {
    name = var.vpn_link_name_1
    ip_address = var.vpn_ip_address_1
    provider_name = "AWN"
    speed_in_mbps = 1000
  }
  link {
    name = var.vpn_link_name_2
    ip_address = var.vpn_ip_address_2
    provider_name = "AWN"
    speed_in_mbps = 1000
  }
}


resource "azurerm_vpn_gateway_connection" "this" {
  name = "vpn-gateway-connection-vhub-01"
  remote_vpn_site_id = azurerm_vpn_site.this.id
  vpn_gateway_id = azurerm_vpn_gateway.this.id
  vpn_link {
    name = "vpn-gateway-connection-link-01"
    vpn_site_link_id = azurerm_vpn_site.this.link[0].id
    protocol = "IKEv2"
    shared_key = "QtTmWc@gw5Qpk%!eK**UFz9qbzGx*V"

    ipsec_policy {
      dh_group = "DHGroup14"
      ike_encryption_algorithm = "AES256"
      ike_integrity_algorithm = "SHA256"
      encryption_algorithm = "AES256"
      integrity_algorithm = "SHA256"
      pfs_group = "PFS14"
      sa_data_size_kb = "0"
      sa_lifetime_sec = "28800"
    }
  }
    vpn_link {
    name = "vpn-gateway-connection-link-02"
    vpn_site_link_id = azurerm_vpn_site.this.link[1].id
        protocol = "IKEv2"
    shared_key = "QtTmWc@gw5Qpk%!eK**UFz9qbzGx*V"

    ipsec_policy {
      dh_group = "DHGroup14"
      ike_encryption_algorithm = "AES256"
      ike_integrity_algorithm = "SHA256"
      encryption_algorithm = "AES256"
      integrity_algorithm = "SHA256"
      pfs_group = "PFS14"
      sa_data_size_kb = "0"
      sa_lifetime_sec = "28800"
    }
  }
}
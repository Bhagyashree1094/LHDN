data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

#--------------------------------------------------- 
# - Generate RT name with BBL module
#--------------------------------------------------- 
module "bbl_rt_name" {
 
  source = "../../terraform-azurerm-module/v1"

  org             = var.org
  country         = var.country
  env             = var.env
  region_code     = var.region_code
  base_name       = var.base_name
  additional_name = var.additional_name
  iterator        = var.iterator
  owner           = var.owner
  au              = var.au
  product_version = var.product_version
  bu              = var.bu
  app_code        = var.app_code

  resource_type_code = "rt"
  max_length         = 80
  no_dashes          = false
  add_random         = var.add_random
  rnd_length         = var.rnd_length
}

#----------------
# - Create the Route Table
#----------------
resource "azurerm_route_table" "this" {
  name                          = module.bbl_rt_name.name
  location                      = module.bbl_rt_name.location
  resource_group_name           = data.azurerm_resource_group.this.name
  disable_bgp_route_propagation = coalesce(var.route_table.disable_bgp_route_propagation, null)

  dynamic "route" {
    for_each = coalesce(var.route_table.routes, [])
    content {
      name                   = coalesce(route.value.name, null)
      address_prefix         = coalesce(route.value.address_prefix, null)
      next_hop_type          = coalesce(route.value.next_hop_type, null)
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  tags = merge(module.bbl_rt_name.tags, var.additional_tags)
}

#----------------
# - Associate the Route Table to the subnet(s)
#----------------
resource "azurerm_subnet_route_table_association" "this" {
  count          = length(var.route_table.subnet_ids)

  route_table_id = azurerm_route_table.this.id
  subnet_id      = var.route_table.subnet_ids[count.index]
}

data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

locals {
  tags = merge(var.pe_additional_tags, data.azurerm_resource_group.this.tags)
}

#
# Private Endpoint
#
resource "azurerm_private_endpoint" "this" {
  for_each            = var.private_endpoints

  name                = "pe-${each.value["name"]}"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = each.value["subnet_id"]

  private_service_connection {
    name                           = "${each.value["name"]}-connection"
    private_connection_resource_id = each.value["private_connection_address_id"]
    is_manual_connection           = coalesce(lookup(each.value, "approval_required"), false)
    subresource_names              = lookup(each.value, "group_ids", null)
    request_message                = coalesce(lookup(each.value, "approval_required"), false) == true ? coalesce(lookup(each.value, "approval_message"), var.default_approval_message) : null
  }
  
  dynamic "private_dns_zone_group" {
    for_each = lookup(each.value, "private_dns_zone_ids", null) != null ? [1] : []
    content {
      name                 = each.value["dns_zone_group_name"]
      private_dns_zone_ids = each.value["private_dns_zone_ids"]
    }
  }

  tags = local.tags
}

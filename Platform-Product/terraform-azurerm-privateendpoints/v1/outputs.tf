#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# 
# OUTPUTS Private Endpoint
# 
output "private_endpoint_ids" {
  value       = [for pe in azurerm_private_endpoint.this : pe.id]
  description = "Private Endpoint Id(s)."
}

output "private_ip_addresses_map" {
  value       = { for pe in azurerm_private_endpoint.this :
                  pe.name => pe.private_service_connection.*.private_ip_address }
  description = "Map of Private Endpoint IP Address(es)."
}

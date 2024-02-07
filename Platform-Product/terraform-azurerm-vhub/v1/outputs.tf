#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------------------
# - OUTPUTS VIrtual Hub
#----------------------------

output "id" {
  value       = azurerm_virtual_hub.this.id
  description = "The Virtual hub ID."
}


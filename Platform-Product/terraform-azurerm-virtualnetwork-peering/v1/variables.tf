#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------------
# - Required Variables
#-------------------------------
# Module required variables
variable "spoke_vnet_id" {
  type        = string
  description = "(Required) The VNet ID of the SPOKE VNet to peer, in a Spoke to Hub connection type."
}

variable "hub_vnet_id" {
  type        = string
  description = "(Required) The VNet ID of the HUB VNet to peer the Spoke VNet with, in a Hub to Spoke connection type."
}

#-------------------------------
# - Optional Variables
#-------------------------------
# Module optional variables
variable "use_remote_gateways" {
  type        = bool
  description = "(Optional) Allow the use of remote gateways from this VNet."
  default     = false
}

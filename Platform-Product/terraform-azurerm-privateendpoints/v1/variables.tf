#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

# -
#  Dependencies
# -
variable "resource_group_name" {
  type        = string
  description = "(Required) Resource Group to create the Private Endpoint(s) in."
}

# -
# Required Variables
# -
variable "private_endpoints" {
  type = map(object({
    name                          = string
    subnet_id                     = string
    group_ids                     = list(string)
    approval_required             = bool
    approval_message              = string
    private_connection_address_id = string
    dns_zone_group_name           = string
    private_dns_zone_ids          = list(string)

  }))
  description = "(Required) Map containing Private Endpoint details:<br></br><ul><li>`name`: (Required) Name of the private endpoint to be created.</li><li>`subnet_id `: (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. Changing this forces a new resource to be created.</li><li>`group_ids `: (Optional) A list of subresource names which the Private Endpoint is able to connect to. </li>	<li>`approval_required `: (Required) Does the Private Endpoint require Manual Approval from the remote resource owner? Changing this forces a new resource to be created.</li><li>`approval_message `: (Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. The request message can be a maximum of 140 characters in length. Only valid if `is_manual_connection` is set to `true`.</li><li>`private_connection_address_id `: (Required) The ID of the Private Link Enabled Remote Resource which this Private Endpoint should be connected to. </li><li>`dns_zone_group_name`: (Required) Specifies the Name of the Private DNS Zone Group. Changing this forces a new `private_dns_zone_group` resource to be created.</li><li>`private_dns_zone_ids`: (Required) Specifies the list of Private DNS Zones to include within the `private_dns_zone_group`.</li></ul>"
}

# -
# Optional Variables
# -
variable "pe_additional_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = {}
}
variable "default_approval_message" {
  type        = string
  description = "(Optional) A message passed to the owner of the remote resource when the private endpoint attempts to establish the connection to the remote resource. This is passed when the `approval_message` in the `private_endpoints` object is empty and an approval is required."
  default     = "Please approve this private endpoint connection request"
}

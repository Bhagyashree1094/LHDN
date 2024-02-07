#--------------------------
# - Dependencies Variables
#--------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the Resource Group in which to create the resource."
}


#------------------------------
# - Required Variables
#------------------------------
# - BBL required values
variable "env" {
  type        = string
  description = "(Required) bbl environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`."
  validation {
    condition     = contains(["nonprod", "prod", "core", "int", "uat", "stage", "dev", "test"], var.env)
    error_message = "Value of \"env\" must be one of: [nonprod,prod,core,int,uat,stage,dev,test]."
  }
}
variable "base_name" {
  type        = string
  description = "(Required) Application/Infrastructure \"base\" name. Example: `aks`."
  default     = null
}
variable "au" {
  type        = string
  description = "(Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters."
  validation {
    condition     = can(regex("^[[:digit:]]+$", var.au))
    error_message = "Value for \"au\" must be of numeric characters."
  }
}
variable "owner" {
  type        = string
  description = "(Required) BBL technology owner group."
}

variable "product_version" {
  type        = string
  description = "(Required) BBL product version. Example: `1.0.0`."
}

variable "app_code" {
  type        = string
  description = "(Required) Application code. Example: network, mgmt, buil"
}

variable "bu" {
  type        = string
  description = "(Required) Bussiness unit code. Example: IT or BBL."
} 

# Module required variables

#----------------------
# - Optional Variables
#----------------------
variable "org" {
  type        = string
  description = "(Optional) BBLorganization code. Example: `BBL`."
  default     = "BBL"
}
variable "country" {
  type        = string
  description = "(Optional) BBLcountry code. Example: `bkk`."
  default     = "bkk"
}

variable "region_code" {
  type        = string
  description = "(Optional) bbl region code.<br></br>&#8226; Value of `region_code` must be one of: `[ea,sea]`."
  validation {
    condition     = contains(["ea", "sea"], var.region_code)
    error_message = "Value of \"region_code\" must be one of: [ea,sea]."
  }
  default     = "sea"
}

# Name tuning variables
variable "additional_name" {
  type        = string
  description = "(Optional) Additional suffix to create resource uniqueness. It will be separated by a `'-'` from the \"name's generated\" suffix. Example: `lan1`."
  default     = null
}
variable "iterator" {
  type        = string
  description = "(Optional) Iterator to create resource uniqueness. It will be separated by a `'-'` from the \"name's generated + additional_name\" concatenation. Example: `001`."
  default     = null
}
variable "additional_tags" {
  description = "(Optional) Additional tags for the virtual network."
  type        = map(string)
  default     = null
}
variable "add_random" {
  type        = bool
  description = "(Optional) When set to `true`,  it will add a `rnd_length`'s long `random_number` at the name's end."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 2
}


#--------------------------------
# - Linux VMSS Required Variables
#--------------------------------
variable "sku" {
  description = "(Required) The Virtual Machine SKU for the Scale Set, such as Standard_F2."
  type        = string
}

variable "admin_username" {
  description = "(Required) The username of the local administrator on each Virtual Machine Scale Set instance."
  type        = string
}

variable "username" {
  description = "(Required) The Username for which this Public SSH Key should be configured."
  type        = string
}

variable "admin_ssh_public_key" {
  type        = string
  description = "(Required) The SSH Public Key for Linux VMSS in place of admin_password."
  sensitive   = true
}

variable "image_marketplace" {
  type        = bool
  description = "(Optional) This will decide if you want to create VMSS from Marketplace Image or not?"
  default     = null
}

variable "plan" {
  type = object({
    name      = string
    publisher = string
    product   = string
  })
  description = <<-EOT
  object({
    name      = "(Required) Specifies the name of the image from the marketplace. Changing this forces a new resource to be created."
    publisher = "(Required) Specifies the publisher of the image. Changing this forces a new resource to be created."
    product   = "(Required) Specifies the product of the image from the marketplace. Changing this forces a new resource to be created."
  })
  EOT
  default     = null
}

variable "os_disk" {
  type = object({
    storage_account_type = string
    caching              = string
    diff_disk_settings = list(object({
      option    = string
      placement = string
    }))
    disk_size_gb           = string
    disk_encryption_set_id = string
  })
  description = <<-EOT
  object({
    storage_account_type   = "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values include Standard_LRS, StandardSSD_LRS, StandardSSD_ZRS, Premium_LRS and Premium_ZRS. Changing this forces a new resource to be created."
    caching                = "(Required) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite."
    diff_disk_settings = list(object({
      option    = "(Required) Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is Local. Changing this forces a new resource to be created."
      placement = "(Optional) Specifies where to store the Ephemeral Disk. Possible values are CacheDisk and ResourceDisk. Defaults to CacheDisk. Changing this forces a new resource to be created."
    }))
    disk_size_gb           = "(Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine Scale Set is sourced from."
    disk_encryption_set_id = "(Optional) The ID of the Disk Encryption Set which should be used to encrypt this OS Disk. Conflicts with secure_vm_disk_encryption_set_id. Changing this forces a new resource to be created."
  })
  EOT
}

variable "network_interface" {
  type = object({
    dns_servers                   = optional(list(string))
    enable_accelerated_networking = bool
    ip_configurations = list(object({
      primary                                      = bool
      subnet_id                                    = string
      application_gateway_backend_address_pool_ids = optional(list(string), [])
      application_security_group_ids               = optional(list(string), [])
      load_balancer_inbound_nat_rules_ids          = optional(list(string), [])
      load_balancer_backend_address_pool_ids       = optional(list(string), [])
    }))
  })
  description = <<-EOT
  object({
    dns_servers                                  = "(Optional) A list of IP Addresses of DNS Servers which should be assigned to the Network Interface."
    enable_accelerated_networking                = "(Optional) Does this Network Interface support Accelerated Networking? Defaults to false."
    ip_configurations = list(object({
    primary                                      = "(Optional) Is this the Primary IP Configuration? Must be `true` for the first `ip_configuration`. Defaults to `false`."
    subnet_id                                    = "(Optional) The ID of the Subnet which this IP Configuration should be connected to."
    application_gateway_backend_address_pool_ids = "(Optional) A list of Backend Address Pools ID's from a Application Gateway which this Virtual Machine Scale Set should be connected to."
    application_security_group_ids               = "(Optional) A list of Application Security Group ID's which this Virtual Machine Scale Set should be connected to."
    load_balancer_inbound_nat_rules_ids          = "(Optional) A list of NAT Rule ID's from a Load Balancer which this Virtual Machine Scale Set should be connected to."
    load_balancer_backend_address_pool_ids       = "(Optional) A list of Backend Address Pools ID's from a Load Balancer which this Virtual Machine Scale Set should be connected to."
  }))
})
  EOT
}

#--------------------------------
# - Linux VMSS Optional Variables
#--------------------------------
variable "instances" {
  description = "(Optional) The number of Virtual Machines in the Scale Set."
  type        = number
  default     = 0
}

variable "source_image_id" {
  type        = string
  description = " (Optional) The ID of an Image which each Virtual Machine in this Scale Set should be based on. Possible Image ID types include Image IDs, Shared Image IDs, Shared Image Version IDs, Community Gallery Image IDs, Community Gallery Image Version IDs, Shared Gallery Image IDs and Shared Gallery Image Version IDs."
  default     = null
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default     = null
  description = <<-EOT
  object({
    publisher = "(Required) Specifies the publisher of the image used to create the virtual machines. Changing this forces a new resource to be created."
    offer     = "(Required) Specifies the offer of the image used to create the virtual machines. Changing this forces a new resource to be created."
    sku       = "(Required) Specifies the SKU of the image used to create the virtual machines."
    version   = "(Required) Specifies the version of the image used to create the virtual machines."
  })
  EOT
}

variable "automatic_instance_repair" {
  type = list(object({
    enabled      = string
    grace_period = string
  }))
  default = [{
    enabled      = false
    grace_period = "PT30M"
  }]
  description = <<-EOT
  list(object({
    enabled      = "(Required) Should the automatic instance repair be enabled on this Virtual Machine Scale Set?"
    grace_period = "(Optional) Amount of time (in minutes, between 30 and 90, defaults to 30 minutes) for which automatic repairs will be delayed. The grace period starts right after the VM is found unhealthy. The time duration should be specified in ISO 8601 format. Defaults to PT30M."
  }))
  EOT
}

variable "computer_name_prefix" {
  type        = string
  description = "(Optional) The prefix which should be used for the name of the Virtual Machines in this Scale Set. If unspecified this defaults to the value for the name field. If the value of the name field is not a valid computer_name_prefix, then you must specify computer_name_prefix. Changing this forces a new resource to be created."
  default     = null
}

variable "overprovision" {
  type        = string
  description = "(Optional) Should Azure over-provision Virtual Machines in this Scale Set? This means that multiple Virtual Machines will be provisioned and Azure will keep the instances which become available first - which improves provisioning success rates and improves deployment time. You're not billed for these over-provisioned VM's and they don't count towards the Subscription Quota."
  default     = "false"
}

variable "edge_zone" {
  type        = string
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Linux Virtual Machine Scale Set should exist. Changing this forces a new Linux Virtual Machine Scale Set to be created."
  default     = null
}

variable "termination_notification" {
  type = object({
    enabled = bool
    timeout = string
  })
  default     = null
  description = <<-EOT
  object({
    enabled = "(Required) Should the termination notification be enabled on this Virtual Machine Scale Set?"
    timeout = "(Optional) Length of time (in minutes, between 5 and 15) a notification to be sent to the VM on the instance metadata server till the VM gets deleted. The time duration should be specified in ISO 8601 format. Defaults to PT5M."
  })
  EOT
}

variable "proximity_placement_group_id" {
  type        = string
  description = "(Optional) The ID of the Proximity Placement Group in which the Virtual Machine Scale Set should be assigned to. Changing this forces a new resource to be created."
  default     = null
}

variable "zones" {
  type        = list(any)
  description = "(Optional) Specifies a list of Availability Zones in which this Linux Virtual Machine Scale Set should be located. Changing this forces a new Linux Virtual Machine Scale Set to be created."
  default     = null
}

variable "system_managed_identity_enabled" {
  type        = bool
  description = "(Optional) Indicates whether the System Managed Identity will be created for the Virtual Machine or not."
  default     = true
}

variable "user_managed_identity_ids" {
  type        = list(string)
  description = "(Optional) The list of User Managed Identity IDs which must be attached to the Virtual Machine."
  default     = []
}

variable "custom_data" {
  description = "(Optional) The custom data to be used for the Virtual Machine."
  type        = string
  default     = null
}

variable "upgrade_mode" {
  type        = string
  description = " (Optional) Specifies how Upgrades (e.g. changing the Image/SKU) should be performed to Virtual Machine Instances. Possible values are Automatic, Manual and Rolling. Defaults to Manual. Changing this forces a new resource to be created.."
  validation {
    condition     = contains(["Automatic", "Manual"], var.upgrade_mode)
    error_message = "Argument 'upgrade_mode' must be Automatic or Manual."
  }
  default = "Manual"
}

variable "health_probe_id" {
  type        = string
  description = "(Optional) The ID of a Load Balancer Probe which should be used to determine the health of an instance. This is Required and can only be specified when upgrade_mode is set to Automatic or Rolling."
  default     = null
}

variable "single_placement_group" {
  type        = bool
  description = "(Optional) Indicates whether the Virtual Machine Scale Set should be created with a single placement group or not."
  default     = true
}

variable "secure_boot_enabled" {
  type        = bool
  description = "(Optional) Specifies whether secure boot should be enabled on the virtual machine. Changing this forces a new resource to be created."
  default     = false
}

variable "vtpm_enabled" {
  type        = bool
  description = "(Optional) Specifies whether vTPM should be enabled on the virtual machine. Changing this forces a new resource to be created."
  default     = false
}

variable "user_data" {
  type        = string
  description = "(Optional) The Base64-Encoded User Data which should be used for this Virtual Machine Scale Set."
  default     = null
}

variable "platform_fault_domain_count" {
  type        = number
  description = "(Optional) Specifies the number of fault domains that are used by this Linux Virtual Machine Scale Set. Changing this forces a new resource to be created."
  default     = 0
}

variable "priority" {
  type        = string
  description = "(Optional) The Priority of this Virtual Machine Scale Set. Possible values are Regular and Spot. Defaults to Regular. Changing this value forces a new resource."
  default     = "Regular"
}

variable "boot_diagnostics" {
  type = object({
    storage_account_uri = optional(string, null)
  })
  description = <<-EOT
  object({
    storage_account_uri = (Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics."
  })
  EOT
  default     = null
}

variable "scale_in" {
  type = object({
    rule                   = string
    force_deletion_enabled = bool
  })
  default     = null
  description = <<-EOT
  object({
    rule                   = "(Optional) The scale-in policy rule that decides which virtual machines are chosen for removal when a Virtual Machine Scale Set is scaled in. Possible values for the scale-in policy rules are Default, NewestVM and OldestVM, defaults to Default."
    force_deletion_enabled = "(Optional) Should the virtual machines chosen for removal be force deleted when the virtual machine scale set is being scaled-in? Possible values are true or false. Defaults to false."
  })
  EOT
}

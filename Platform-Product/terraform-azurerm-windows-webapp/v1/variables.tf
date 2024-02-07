#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#----------------
# - Dependencies
#----------------
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group where the Windows Web App should exist. Changing this forces a new Windows Web App to be created."
}

variable "virtual_network_name" {
  type        = string
  description = "(Required) Name of the Virtual Wan in which connection need to be established.."
}

variable "subnet_id" {
  type = string
}

#---------------------
# - Required Variables
#---------------------
# bbl required values
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
  description = "(Required) bbl Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters."
  validation {
    condition     = can(regex("^[[:digit:]]+$", var.au))
    error_message = "Value for \"au\" must be of numeric characters."
  }
}
variable "owner" {
  type        = string
  description = "(Required) bbl technology owner group."
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


# module required variables


#---------------------
# - Optional Variables
#---------------------
# bbl optional variables
variable "org" {
  type        = string
  description = "(Optional) bbl organization code. Example: `wf`."
  default     = "wf"
}
variable "country" {
  type        = string
  description = "(Optional) bbl country code. Example: `us`."
  default     = "us"
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
variable "add_random" {
  type        = bool
  description = "(Optional) When set to `true`, it will add a `rnd_length`'s long `random_number` at the name's end."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 2
}
variable "additional_tags" {
  type        = map(string)
  description = "(Optional) Additional tags for the App Service resources, in addition to the resource group tags."
  default     = {}
}

#---------------
# - App Services
#---------------
variable "service_plan_id" {
  type        = string
  description = "(Required) The ID of the Service Plan that this Windows App Service will be created in."
}
variable "site_config" {
  type = object({
    always_on = bool
    application_stack = object({
      current_stack  = string
      dotnet_version = string
    })
    cors = object({
      allowed_origins     = list(string)
      support_credentials = bool
    })
    virtual_application = object({
      physical_path = string
      preload       = bool
      virtual_directory = map(object({
        physical_path = string
        virtual_path  = string
      }))
      virtual_path = string
    })
    http2_enabled         = bool
    managed_pipeline_mode = string
    worker_count          = number
    ftps_state            = string
  })
  description = "(Required) Site Configuration for the Windows WebApp."
}
variable "app_settings" {
  type        = map(string)
  description = "(Optional) A key-value pair of App Settings."
  default     = {}
}
variable "auth_settings" {
  type = object({
    enabled                       = bool
    runtime_version               = string
    token_refresh_extension_hours = number
    token_store_enabled           = bool
    unauthenticated_client_action = string
  })
  description = "(Optional) Authentication settings of the Windows WebApp."
  default = {
    enabled                       = false
    runtime_version               = "value"
    token_refresh_extension_hours = 1
    token_store_enabled           = false
    unauthenticated_client_action = "value"
  }
}
variable "client_affinity_enabled" {
  type        = bool
  description = "(Optional) Should the App Service send session affinity cookies, which route client requests in the same session to the same instance?"
  default     = false
}
variable "client_certificate_enabled" {
  type        = bool
  description = "(Optional) Does the App Service require client certificates for incoming requests?"
  default     = false
}
variable "client_certificate_mode" {
  type        = string
  description = "(Optional) The Client Certificate mode. Possible values include Optional and Required. This property has no effect when client_cert_enabled is false"
  default     = "Optional"
}
variable "enabled" {
  type        = bool
  description = "(Optional) Should the Windows Web App be enabled?"
  default     = true
}
variable "connection_string" {
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  description = "(Optional) Database connection string for the Windows WebApp Service."
  default     = []
}
variable "https_only" {
  type        = bool
  description = "(Optional) Should the Windows Web App require HTTPS connections."
  default     = false
}
variable "logs" {
  type = object({
    application_logs = object({
      file_system_level = string
    })
    detailed_error_messages = bool
    failed_request_tracing  = bool
    http_logs = object({
      file_system = object({
        retention_in_days = number
        retention_in_mb   = number
      })
    })
  })
  description = "(Optional) Logging for the Windows WebApp Service."
  default = {
    application_logs = {
      file_system_level = "Warning"
    }
    detailed_error_messages = false
    failed_request_tracing  = false
    http_logs = {
      file_system = {
        retention_in_days = 7
        retention_in_mb   = 1
      }
    }
  }
}
variable "sticky_settings" {
  type = object({
    app_setting_names       = list(string)
    connection_string_names = list(string)
  })
  description = "(Optional) List of App Setting and Connection string names that the Windows Web App will not swap between Slots when a swap operation is triggered."
  default     = null
}
variable "identity" {
  type        = bool
  description = "(Required) Should the Windows WebApp be assigned an identity?"
}
variable "assign_identity" {
  type        = string
  description = "(Required) Specifies the type of Managed Service Identity that should be configured on this Windows Web App. Possible values are SystemAssigned, UserAssigned, SystemAssigned, UserAssigned (to enable both)."
}

variable "zip_deploy_file" {
  type        = string
  description = "(optional) he local path and filename of the Zip packaged application to deploy to this Windows Web App ."
  default = null
}

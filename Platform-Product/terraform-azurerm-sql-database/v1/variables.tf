
#-------------------------------
# - BBL required values
#-------------------------------
variable "env" {
  type        = string
  description = "(Required) BBL environment code. Example: `test`. <br></br>&#8226; Value of `env` must be one of: `[nonprod,prod,core,int,uat,stage,dev,test]`."
  validation {
    condition     = contains(["nonprod", "prod", "core", "int", "uat", "stage", "dev", "test"], var.env)
    error_message = "Value of \"env\" must be one of: [nonprod,prod,core,int,uat,stage,dev,test]."
  }
}
variable "base_name" {
  type        = string
  description = "(Required) Application/Infrastructure \"base\" name. Example: `aks`."
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

variable "app_code" {
  type        = string
  description = "(Required) Application code. Example: network, mgmt, buil"
}

variable "bu" {
  type        = string
  description = "(Required) Bussiness unit code. Example: IT or BBL."
}


variable "product_version" {
  type        = string
  description = "(Required) BBL product_version."
}

#----------------------
# - Optional Variables
#----------------------
variable "org" {
  type        = string
  description = "(Optional) BBL organization code. Example: `bbl`."
  default     = "bbl"
}
variable "country" {
  type        = string
  description = "(Optional) BBL country code. Example: `bkk`."
  default     = "bkk"
}
variable "region_code" {
  type        = string
  description = "(Optional) BBL region code.<br></br>&#8226; Value of `region_code` must be one of: `[sea,ea]`."
  validation {
    condition     = contains(["sea", "ea"], var.region_code)
    error_message = "Value of region_code must be one of: [sea,ea]."
  }
  default = "sea"
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
  description = "(Optional) When set to `true`,  it will add a `rnd_length`'s long `random_number` at the name's end of the SQL Database."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 2
}
variable "additional_tags" {
  description = "(Optional) Additional tags for the SQL Database."
  type        = map(string)
  default     = null
}


variable "mssql_server_resource_group_name" {
  description = "The resource group name of MSSQL server."
  type        = string
  default     = null
}

variable "mssql_server_name" {
  description = "The mssql server name."
  type        = string
  default     = null
}

# MSSQL Database Var
variable "auto_pause_delay_in_minutes" {
  description = "Auto pause delay in minutes for the SQL database."
  type        = number
  default     = null
}

variable "collation" {
  description = "The collation of the SQL database."
  type        = string
  default     = null
}

variable "create_mode" {
  description = "The create mode of the SQL database."
  type        = string
  default     = null
}

variable "creation_source_database_id" {
  description = "The ID of the source database to create this database from."
  type        = string
  default     = null
}

variable "elastic_pool_id" {
  description = "The ID of the elastic pool to which this SQL database belongs."
  type        = string
  default     = null
}

variable "geo_backup_enabled" {
  description = "Whether or not geo backups are enabled for this SQL database."
  type        = bool
  default     = false
}

variable "ledger_enabled" {
  description = "Whether ledger is enabled for the SQL database."
  type        = bool
  default     = false
}

variable "license_type" {
  description = "The license type of the SQL database."
  type        = string
  default     = null
}

variable "max_size_gb" {
  description = "The maximum size in GB for the SQL database."
  type        = number
  default     = null
}

variable "min_capacity" {
  description = "The minimum capacity for the SQL database."
  type        = number
  default     = null
}

variable "read_replica_count" {
  description = "The read replica count for the SQL database."
  type        = number
  default     = null
}

variable "read_scale" {
  description = "The read scale setting for the SQL database."
  type        = bool
  default     = null
}

variable "recover_database_id" {
  description = "The ID of the database to recover."
  type        = string
  default     = null
}

variable "restore_dropped_database_id" {
  description = "The ID of the database to restore."
  type        = string
  default     = null
}

variable "restore_point_in_time" {
  description = "The point in time to restore the database from."
  type        = string
  default     = null
}

variable "sample_name" {
  description = "The name of the sample to use for the SQL database."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "The SKU name for the SQL database."
  type        = string
  default     = null
}

variable "storage_account_type" {
  description = "The storage account type for the SQL database."
  type        = string
  default     = null
}

variable "transparent_data_encryption_enabled" {
  description = "Whether transparent data encryption is enabled for the SQL database."
  type        = bool
  default     = null
}

variable "maintenance_configuration_name" {
  description = "The maintenance configuration name for the SQL database."
  type        = string
  default     = null
}

variable "zone_redundant" {
  description = "Whether or not the SQL database is zone redundant."
  type        = bool
  default     = null
}

variable "short_term_retention_policy" {
  description = "The short term retention policy for the SQL database."
  type = object({
    retention_days           = number
    backup_interval_in_hours = number
  })
  default = null
}

variable "long_term_retention_policy" {
  description = "The long term retention policy for the SQL database."
  type = object({
    weekly_retention  = string
    monthly_retention = string
    yearly_retention  = string
    week_of_year      = number
  })
  default = null
}

variable "threat_detection_policy" {
  description = "The threat detection policy for the SQL database."
  type = object({
    state                      = string
    disabled_alerts            = list(string)
    email_account_admins       = bool
    email_addresses            = list(string)
    retention_days             = number
    storage_account            = object({
      key                 = string
      name                = string
      resource_group_name = string
    })
  })
  default = null
}

variable "storage_accounts" {
  description = "Map of storage accounts used in the threat detection policy."
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}
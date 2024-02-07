#
# Copyright 2023 BBL & Microsoft. All rights reserved.
#

#-------------------------------
# - Dependencies Variables
#-------------------------------
variable "resource_group_name" {
  type        = string
  description = "(Required) Name of the resource group in which the AKS cluster will be created."
}
variable "key_vault_id" {
  type        = string
  description = "(Required) ID of the existing Key vault to store the AKS Cluster SSH admin user, SSH private key and Disk Encryption Set key."
}
variable "default_nodepool_subnet_id" {
  type        = string
  description = "(Required) ID of the existing subnet to deploy the nodes on."
}
variable "log_analytics_workspace_id" {
  type        = string
  description = "(Optional) The ID of the existing Log Analytics Workspace which the OMS Agent should send data to."
  default     = null
}
variable "private_dns_zone_id" {
  type        = string
  description = "(Optional) The ID of the existing Private DNS Zone to use for the Private cluster's Private endpoint. Possible values are: `<ID of Private DNS Zone>`, `System`: AKS manages a zone, `None`: use BYO DNS and setup resolution."
  default     = null
}
variable "aad_admin_group_object_ids" {
  type        = list(string)
  description = "(Optional) The list of Azure AD Object IDs to add to the cluster Administrators. Can be both Users and Groups."
  default     = null
}
variable "acr_id" {
  type        = string
  description = "(Optional) The ID of the existing ACR from which this AKS cluster can pull images from."
  default     = null
}

variable "sku_kubernetes_cluster" {
  type        = string
  description = "(Optional) The SKU which should be used for this Kubernetes Cluster. Possible values are `Free` and `Standard`. Defaults to `Free`."
  default     = "Free"
}

#-------------------------------
# - BBL required values
#-------------------------------

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

# variable "au" {
#   type        = string
#   description = "(Required) BBL Accounting Unit (AU) code. Example: `0233985`. <br></br>&#8226; Value of `au` must be of numeric characters."
#   validation {
#     condition     = can(regex("^[[:digit:]]+$", var.au))
#     error_message = "Value for \"au\" must be of numeric characters."
#   }
# }

variable "owner" {
  type        = string
  description = "(Required) Wells Fargo technology owner group."
}

# variable "product_version" {
#   type        = string
#   description = "(Required) BBL product version. Example: `1.0.0`."
# }

variable "app_code" {
  type        = string
  description = "(Required) Application code. Example: network, mgmt, buil"
}

variable "bu" {
  type        = string
  description = "(Required) Bussiness unit code. Example: IT or BBL."
}

#-------------------------------
# - Optional Variables
#-------------------------------

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
  description = "(Optional) When set to `true`, it will add a `rnd_length`'s long `random_number` at the name's end of AKS cluster."
  default     = false
}
variable "rnd_length" {
  type        = number
  description = "(Optional) Set the length of the `random_number` generated."
  default     = 2
}
variable "additional_tags" {
  type        = map(string)
  description = "(Optional) Additional tags for the AKS cluster."
  default     = null
}

#-------------------------------
# - AKS variables
#-------------------------------
variable "aks_cluster" {
  type = object({
    kubernetes_version = string # az aks get-versions --location northcentralus --output table
    # docker_bridge_cidr        = string
    service_address_range     = string
    dns_service_ip            = string
    dns_prefix                = string # must contain between 3 and 45 characters, and can contain only letters, numbers, and hyphens. It must start with a letter and must end with a letter or a number.
    automatic_channel_upgrade = string # Possible values are: patch, rapid, node-image and stable, OR null to get a "none".
    open_service_mesh_enabled = bool
    secret_rotation_enabled   = bool
    secret_rotation_interval  = string
    # http_proxy                = string
    # https_proxy               = string
    # no_proxy                  = list(string)

    default_node_pool = object({
      name     = string
      vm_size  = string
      max_pods = number # [10..250]
      # orchestrator_version = string # must be equal or higher than the kubernetes_version. If not, AKS will override it.
      os_disk_type      = string
      os_disk_size_gb   = number
      ultra_ssd_enabled = bool
      os_sku            = string
      max_count         = number # [1..1000]
      min_count         = number # [1..1000]
      node_count        = number # [min_count..max_count]
      node_labels       = map(string)
      # node_taints          = list(string)
    })

    auto_scaler_profile = object({
      balance_similar_node_groups  = bool
      max_graceful_termination_sec = number
      # scale_down_delay_after_add       = string
      # scale_down_delay_after_delete    = string
      # scale_down_delay_after_failure   = string
      # scan_interval                    = string
      # scale_down_unneeded              = string
      # scale_down_unready               = string
      # scale_down_utilization_threshold = number
    })
  })
  description = "(Required) Kubernetes cluster creation parameters:<ul><li>`dns_prefix `: (Optional) DNS prefix specified when creating the managed cluster. Must be provided when Private DNS Zone ID is provided as `null`.</li><li>`kubernetes_version `: (Optional) Version of Kubernetes specified when creating the AKS managed cluster. If not specified, the latest recommended version will be used at provisioning time.</li><li>`docker_bridge_cidr `: (Optional) IP address (in CIDR notation) used as the Docker bridge IP address on nodes.</li><li>`service_address_range `: (Optional) The Network Range used by the Kubernetes service.</li><li>`dns_ip `: (Optional) IP address within the Kubernetes service address range that will be used by cluster service discovery (kube-dns).</li><li>`private_dns_zone_id `: (Optional) The ID of Private DNS Zone which should be delegated to this Cluster.</li><li>`managed `: (Optional) Is the Azure Active Directory integration Managed, meaning that Azure will create/manage the Service Principal used for integration.</li><li>`automatic_channel_upgrade `: (Optional) The upgrade channel for this Kubernetes Cluster. Possible values are patch, rapid, node-image and stable.</li><li>`secret_rotation_enabled `:  (Required) Whether to enable secret rotation or not.</li><li>`secret_rotation_interval `: (Required) The interval to poll for secret rotation. This attribute is only set when secret_rotation is true.</li><li>`http_proxy `: (Optional) The proxy address to be used when communicating over HTTP.</li><li>`https_proxy `: (Optional) The proxy address to be used when communicating over HTTPS.</li><li>`no_proxy `: (Optional) The list of domains that will not use the proxy for communication.</li><li>`azure_policy_enabled `: (Optional) Whether to enable Azure Policy Add-On or not.</li><li>`admin_group_object_ids `: (Optional) A list of Object IDs of Azure Active Directory Groups which should have Admin Role on the Cluster.</li><li>`aks_default_pool `:  (Required) Default node pool created during cluster creation. Required values for this block are defined below:	<ul><li>`name `: (Required) The name which should be used for the default Kubernetes Node Pool.</li><li>`vm_size `: (Required) The size of the Virtual Machine, in the format, such as `Standard_DS2_v2`.</li><li>`availability_zones `: (Optional) A list of Availability Zones across which the Node Pool should be spread.</li><li>`max_pods `: (Optional) The maximum number of pods that can run on each agent.</li><li>`os_disk_type `: (Optional) The type of disk which should be used for the Operating System. Possible values are `Ephemeral` and `Managed`. Defaults to `Managed`. </li><li>`os_disk_size_gb `: (Optional) The size of the OS Disk which should be used for each agent in the Node Pool.</li><li>`subnet_id `: (Optional) The ID of a Subnet where the Kubernetes Node Pool should exist.</li><li>`node_count `: (Optional) The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min_count and max_count.</li><li>`max_count `: (Required) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000.</li><li>`min_count `: (Required) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000.</li><li>`node_labels `: (Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.</li><li>`node_taints `: (Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule).</li></ul></li><li>`auto_scaler_profile `: A configuration that decribes the scaling profile for the nodes:<ul><li>`balance_similar_node_groups `: (Optional) Detect similar node groups and balance the number of nodes between them. Defaults to false.</li><li>`max_graceful_termination_sec `: (Optional) Maximum number of seconds the cluster autoscaler waits for pod termination when trying to scale down a node. Defaults to 600.</li><li>`scale_down_delay_after_add `: (Optional) How long after the scale up of AKS nodes the scale down evaluation resumes. Defaults to 10m.</li><li>`scale_down_delay_after_delete `: (Optional) How long after node deletion that scale down evaluation resumes. Defaults to the value used for scan_interval.</li><li>`scale_down_delay_after_failure `: (Optional) How long after scale down failure that scale down evaluation resumes. Defaults to 3m.</li><li>`scan_interval `: (Required) How often the AKS Cluster should be re-evaluated for scale up/down. Defaults to 10s.</li><li>`scale_down_unneeded `: (Optional) How long a node should be unneeded before it is eligible for scale down. Defaults to 10m.</li><li>`scale_down_unready `: (Optional) How long an unready node should be unneeded before it is eligible for scale down. Defaults to 20m.</li><li>`scale_down_utilization_threshold `: (Optional) Node utilization level, defined as sum of requested resources divided by capacity, below which a node can be considered for scale down. Defaults to 0.5.</li></ul></li></ul>"
}

variable "aks_extra_node_pools" {
  type = map(object({
    name    = string
    vm_size = string
    # orchestrator_version = string
    availability_zones = list(string)
    subnet_id          = string

    os_sku            = string
    os_disk_type      = string
    os_disk_size_gb   = number
    ultra_ssd_enabled = bool

    max_pods   = number
    max_count  = number
    min_count  = number
    node_count = number

    node_labels = map(string)
    node_taints = list(string)
  }))
  description = "(Optional) List of additional node pools:<ul><li>`name `: (Required) The name which should be used for the default Kubernetes Node Pool.</li><li>`vm_size `: (Required) The size of the Virtual Machine, in the format, such as `Standard_DS2_v2`.</li><li>`availability_zones `: (Optional) A list of Availability Zones across which the Node Pool should be spread.</li><li>`max_pods `: (Optional) The maximum number of pods that can run on each agent.</li><li>`os_disk_type `: (Optional) The type of disk which should be used for the Operating System. Possible values are `Ephemeral` and `Managed`. Defaults to `Managed`. </li><li>`os_disk_size_gb `: (Optional) The size of the OS Disk which should be used for each agent in the Node Pool.</li><li>`subnet_id `: (Optional) The ID of a Subnet where the Kubernetes Node Pool should exist.</li><li>`node_count `: (Optional) The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000 and between min_count and max_count.</li><li>`max_count `: (Required) The maximum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000.</li><li>`min_count `: (Required) The minimum number of nodes which should exist in this Node Pool. If specified this must be between 1 and 1000.</li><li>`node_labels `: (Optional) A map of Kubernetes labels which should be applied to nodes in the Default Node Pool.</li><li>`node_taints `: (Optional) A list of Kubernetes taints which should be applied to nodes in the agent pool (e.g key=value:NoSchedule).</li></ul>"
  default     = null
}

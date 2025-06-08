# Required Variables
variable "cluster_name" {
  description = "The name of the AKS cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,63}$", var.cluster_name))
    error_message = "Cluster name must be 1-63 characters long and can only contain alphanumeric characters and hyphens."
  }
}

variable "location" {
  description = "The Azure location where the AKS cluster will be deployed"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group where the AKS cluster will be deployed"
  type        = string
}

# Optional Variables with Defaults
variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster. If not specified, defaults to cluster_name-k8s"
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to use for the AKS cluster"
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "The SKU tier that should be used for this Kubernetes Cluster"
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Free", "Standard"], var.sku_tier)
    error_message = "SKU tier must be either 'Free' or 'Standard'."
  }
}

# Private Cluster Configuration
variable "private_cluster_enabled" {
  description = "Enable private cluster functionality"
  type        = bool
  default     = true
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID for the cluster. Use 'System' for system-managed, 'None' for no private DNS"
  type        = string
  default     = "System"
}

variable "private_cluster_public_fqdn_enabled" {
  description = "Specifies whether a Public FQDN for this Private Cluster should be added"
  type        = bool
  default     = false
}

# Security Configuration
variable "local_account_disabled" {
  description = "Whether local accounts should be disabled"
  type        = bool
  default     = true
}

variable "azure_rbac_enabled" {
  description = "Whether Azure RBAC should be enabled"
  type        = bool
  default     = true
}

variable "admin_group_object_ids" {
  description = "A list of Azure AD group object IDs that should have admin access to the cluster"
  type        = list(string)
  default     = []
}

# Identity Configuration
variable "identity_type" {
  description = "The type of identity used for the managed cluster"
  type        = string
  default     = "SystemAssigned"

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned"], var.identity_type)
    error_message = "Identity type must be either 'SystemAssigned' or 'UserAssigned'."
  }
}

variable "user_assigned_identity_ids" {
  description = "Specifies a list of User Assigned Managed Identity IDs to be assigned to this Kubernetes Cluster"
  type        = list(string)
  default     = []
}

# Network Configuration
variable "network_profile" {
  description = "Network configuration for the AKS cluster"
  type = object({
    network_plugin      = optional(string, "azure")
    network_plugin_mode = optional(string, null)
    network_policy      = optional(string, "calico")
    dns_service_ip      = optional(string, "10.200.0.10")
    service_cidr        = optional(string, "10.200.0.0/16")
    pod_cidr           = optional(string, null)
    load_balancer_sku  = optional(string, "standard")
    outbound_type      = optional(string, "loadBalancer")
  })
  default = {}

  validation {
    condition = can(regex("^(?:[0-9]{1,3}\\.){3}[0-9]{1,3}$", var.network_profile.dns_service_ip)) || var.network_profile.dns_service_ip == null
    error_message = "DNS service IP must be a valid IP address."
  }
}

# Default Node Pool Configuration
variable "default_node_pool" {
  description = "Configuration for the default node pool"
  type = object({
    name                         = optional(string, "default")
    vm_size                      = optional(string, "Standard_D2s_v3")
    node_count                   = optional(number, 3)
    min_count                    = optional(number, 1)
    max_count                    = optional(number, 5)
    enable_auto_scaling          = optional(bool, true)
    vnet_subnet_id               = optional(string, null)
    zones                        = optional(list(string), ["1", "2", "3"])
    only_critical_addons_enabled = optional(bool, false)
    os_disk_size_gb              = optional(number, 128)
    os_disk_type                 = optional(string, "Managed")
    max_pods                     = optional(number, 30)
    node_labels                  = optional(map(string), {})
    node_taints                  = optional(list(string), [])
    upgrade_settings = optional(object({
      max_surge = string
    }), null)
  })
  default = {}

  validation {
    condition     = can(regex("^[a-z][a-z0-9]{0,11}$", var.default_node_pool.name))
    error_message = "Node pool name must start with a lowercase letter, be 1-12 characters long, and contain only lowercase alphanumeric characters."
  }
}

# Additional Node Pools
variable "additional_node_pools" {
  description = "Additional node pools for the AKS cluster"
  type = map(object({
    name                = string
    vm_size             = optional(string, "Standard_D2s_v3")
    node_count          = optional(number, 1)
    min_count           = optional(number, 1)
    max_count           = optional(number, 3)
    enable_auto_scaling = optional(bool, true)
    vnet_subnet_id      = optional(string, null)
    zones               = optional(list(string), ["1", "2", "3"])
    os_disk_size_gb     = optional(number, 128)
    os_disk_type        = optional(string, "Managed")
    max_pods            = optional(number, 30)
    node_labels         = optional(map(string), {})
    node_taints         = optional(list(string), [])
    mode                = optional(string, "User")
    upgrade_settings = optional(object({
      max_surge = string
    }), null)
  }))
  default = {}
}

# Monitoring Configuration
variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send logs to"
  type        = string
  default     = null
}

# Maintenance Window Configuration
variable "maintenance_window" {
  description = "Maintenance window configuration for the AKS cluster"
  type = object({
    allowed = list(object({
      day   = string
      hours = list(number)
    }))
    not_allowed = list(object({
      end   = string
      start = string
    }))
  })
  default = null
}

# Auto Scaler Profile
variable "auto_scaler_profile" {
  description = "Auto scaler profile configuration"
  type = object({
    balance_similar_node_groups       = optional(bool, false)
    expander                         = optional(string, "random")
    max_graceful_termination_sec     = optional(string, "600")
    max_node_provisioning_time       = optional(string, "15m")
    max_unready_nodes               = optional(number, 3)
    max_unready_percentage          = optional(number, 45)
    new_pod_scale_up_delay          = optional(string, "10s")
    scale_down_delay_after_add      = optional(string, "10m")
    scale_down_delay_after_delete   = optional(string, "10s")
    scale_down_delay_after_failure  = optional(string, "3m")
    scan_interval                   = optional(string, "10s")
    scale_down_unneeded             = optional(string, "10m")
    scale_down_unready              = optional(string, "20m")
    scale_down_utilization_threshold = optional(string, "0.5")
    empty_bulk_delete_max           = optional(string, "10")
    skip_nodes_with_local_storage   = optional(bool, true)
    skip_nodes_with_system_pods     = optional(bool, true)
  })
  default = null
}

# Resource Lock Configuration
variable "enable_resource_lock" {
  description = "Whether to enable resource lock on the AKS cluster"
  type        = bool
  default     = false
}

variable "resource_lock_level" {
  description = "The level of lock to apply to the AKS cluster"
  type        = string
  default     = "ReadOnly"

  validation {
    condition     = contains(["ReadOnly", "CanNotDelete"], var.resource_lock_level)
    error_message = "Resource lock level must be either 'ReadOnly' or 'CanNotDelete'."
  }
}

# Role Assignments
variable "role_assignments" {
  description = "Role assignments for the AKS cluster managed identity"
  type = map(object({
    scope                = string
    role_definition_name = string
  }))
  default = {}
}

# Tags
variable "tags" {
  description = "A map of tags to assign to the AKS cluster"
  type        = map(string)
  default     = {}
}

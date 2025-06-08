variable "azure_region" {
  description = "Azure region for the AKS cluster"
  type        = string
  
}

variable "cluster_name" {
  description = "Name for the AKS cluster"
  type        = string
  
}

variable "sku_tier" {
  description = "SKU tier for the AKS cluster"
  type        = string
  default     = "Standard"
}

variable "private_cluster_enabled" {
  description = "Enable private cluster for the AKS cluster"
  type        = bool
  default     = true
}

variable "private_dns_zone_id" {
  description = "Private DNS zone ID for the AKS cluster"
  type        = string
  
}

variable "dns_prefix_private_cluster" {
  description = "DNS prefix for the private cluster"
  type        = string
  
}

variable "azure_active_directory_role_based_access_control" {
  description = "Azure Active Directory role-based access control settings"
  type        = map(string)
  default     = {}
}

variable "managed_identities" {
  description = "Managed identities settings"
  type        = map(string)
  default     = {}
}

variable "network_profile" {
  description = "Network profile settings"
  type        = map(string)
  default     = {}
}

variable "default_node_pool" {
  description = "Default node pool settings"
  type        = map(string)
  default     = {}
}

variable "node_pools" {
  description = "Node pools settings"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags for the AKS cluster"
  type        = map(string)
  default     = {}
}

variable "kubernetes_version" {
  description = "Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.31.0"
}

variable "identity" {
  description = "Identity settings for the AKS cluster"
  type        = map(string)
  default     = {}
}

variable "enable_private_cluster" {
  description = "Enable private cluster for the AKS cluster"
  type        = bool
  default     = false
}

variable "enable_private_dns" {
  description = "Enable private DNS for the AKS cluster"
  type        = bool
  default     = false
}

variable "enable_private_link" {
  description = "Enable private link for the AKS cluster"
  type        = bool
  default     = false
}

variable "enable_private_endpoint" {
  description = "Enable private endpoint for the AKS cluster"
  type        = bool
  default     = false
}

variable "enable_private_dns_zone" {
  description = "Enable private DNS zone for the AKS cluster"
  type        = bool
  default     = false
}

variable "enable_private_dns_zone_link" {
  description = "Enable private DNS zone link for the AKS cluster"
  type        = bool
  default     = false
}

variable "enable_private_dns_zone_virtual_network_link" {
  description = "Enable private DNS zone virtual network link for the AKS cluster"
  type        = bool
  default     = false
}



# AVM-Compliant AKS Module
# This module follows Azure Verified Modules standards for AKS deployment

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
  }
}

# Main AKS Cluster Resource
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = coalesce(var.dns_prefix, "${var.cluster_name}-k8s")
  kubernetes_version  = var.kubernetes_version
  sku_tier           = var.sku_tier

  # Private cluster configuration
  private_cluster_enabled             = var.private_cluster_enabled
  private_dns_zone_id                = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled

  # Disable local accounts for enhanced security
  local_account_disabled = var.local_account_disabled

  # Network profile configuration
  network_profile {
    network_plugin      = var.network_profile.network_plugin
    network_plugin_mode = var.network_profile.network_plugin_mode
    network_policy      = var.network_profile.network_policy
    dns_service_ip      = var.network_profile.dns_service_ip
    service_cidr        = var.network_profile.service_cidr
    pod_cidr           = var.network_profile.pod_cidr
    load_balancer_sku  = var.network_profile.load_balancer_sku
    outbound_type      = var.network_profile.outbound_type
  }

  # Default node pool configuration
  default_node_pool {
    name                         = var.default_node_pool.name
    vm_size                      = var.default_node_pool.vm_size
    node_count                   = var.default_node_pool.enable_auto_scaling ? null : var.default_node_pool.node_count
    min_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.min_count : null
    max_count                    = var.default_node_pool.enable_auto_scaling ? var.default_node_pool.max_count : null
    enable_auto_scaling          = var.default_node_pool.enable_auto_scaling
    vnet_subnet_id               = var.default_node_pool.vnet_subnet_id
    zones                        = var.default_node_pool.zones
    only_critical_addons_enabled = var.default_node_pool.only_critical_addons_enabled
    os_disk_size_gb              = var.default_node_pool.os_disk_size_gb
    os_disk_type                 = var.default_node_pool.os_disk_type
    max_pods                     = var.default_node_pool.max_pods
    node_labels                  = var.default_node_pool.node_labels
    node_taints                  = var.default_node_pool.node_taints

    dynamic "upgrade_settings" {
      for_each = var.default_node_pool.upgrade_settings != null ? [var.default_node_pool.upgrade_settings] : []
      content {
        max_surge = upgrade_settings.value.max_surge
      }
    }
  }

  # Identity configuration
  dynamic "identity" {
    for_each = var.identity_type == "SystemAssigned" ? [1] : []
    content {
      type = "SystemAssigned"
    }
  }

  dynamic "identity" {
    for_each = var.identity_type == "UserAssigned" ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.user_assigned_identity_ids
    }
  }

  # Azure RBAC configuration
  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_rbac_enabled ? [1] : []
    content {
      managed                = true
      azure_rbac_enabled     = var.azure_rbac_enabled
      admin_group_object_ids = var.admin_group_object_ids
    }
  }

  # OMS Agent for monitoring
  dynamic "oms_agent" {
    for_each = var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  # Maintenance window configuration
  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []
    content {
      dynamic "allowed" {
        for_each = maintenance_window.value.allowed
        content {
          day   = allowed.value.day
          hours = allowed.value.hours
        }
      }
      dynamic "not_allowed" {
        for_each = maintenance_window.value.not_allowed
        content {
          end   = not_allowed.value.end
          start = not_allowed.value.start
        }
      }
    }
  }

  # Auto scaler profile
  dynamic "auto_scaler_profile" {
    for_each = var.auto_scaler_profile != null ? [var.auto_scaler_profile] : []
    content {
      balance_similar_node_groups      = auto_scaler_profile.value.balance_similar_node_groups
      expander                        = auto_scaler_profile.value.expander
      max_graceful_termination_sec    = auto_scaler_profile.value.max_graceful_termination_sec
      max_node_provisioning_time      = auto_scaler_profile.value.max_node_provisioning_time
      max_unready_nodes              = auto_scaler_profile.value.max_unready_nodes
      max_unready_percentage         = auto_scaler_profile.value.max_unready_percentage
      new_pod_scale_up_delay         = auto_scaler_profile.value.new_pod_scale_up_delay
      scale_down_delay_after_add     = auto_scaler_profile.value.scale_down_delay_after_add
      scale_down_delay_after_delete  = auto_scaler_profile.value.scale_down_delay_after_delete
      scale_down_delay_after_failure = auto_scaler_profile.value.scale_down_delay_after_failure
      scan_interval                  = auto_scaler_profile.value.scan_interval
      scale_down_unneeded            = auto_scaler_profile.value.scale_down_unneeded
      scale_down_unready             = auto_scaler_profile.value.scale_down_unready
      scale_down_utilization_threshold = auto_scaler_profile.value.scale_down_utilization_threshold
      empty_bulk_delete_max          = auto_scaler_profile.value.empty_bulk_delete_max
      skip_nodes_with_local_storage  = auto_scaler_profile.value.skip_nodes_with_local_storage
      skip_nodes_with_system_pods    = auto_scaler_profile.value.skip_nodes_with_system_pods
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }
}

# Additional node pools
resource "azurerm_kubernetes_cluster_node_pool" "additional" {
  for_each = var.additional_node_pools

  name                  = each.value.name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size              = each.value.vm_size
  node_count           = each.value.enable_auto_scaling ? null : each.value.node_count
  min_count            = each.value.enable_auto_scaling ? each.value.min_count : null
  max_count            = each.value.enable_auto_scaling ? each.value.max_count : null
  enable_auto_scaling  = each.value.enable_auto_scaling
  vnet_subnet_id       = each.value.vnet_subnet_id
  zones                = each.value.zones
  os_disk_size_gb      = each.value.os_disk_size_gb
  os_disk_type         = each.value.os_disk_type
  max_pods             = each.value.max_pods
  node_labels          = each.value.node_labels
  node_taints          = each.value.node_taints
  mode                 = each.value.mode

  dynamic "upgrade_settings" {
    for_each = each.value.upgrade_settings != null ? [each.value.upgrade_settings] : []
    content {
      max_surge = upgrade_settings.value.max_surge
    }
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      node_count
    ]
  }
}

# Management lock for production environments
resource "azurerm_management_lock" "this" {
  count = var.enable_resource_lock ? 1 : 0

  name       = "${var.cluster_name}-lock"
  scope      = azurerm_kubernetes_cluster.this.id
  lock_level = var.resource_lock_level
  notes      = "Managed by Terraform - AKS cluster protection"
}

# Role assignments for managed identity
resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = azurerm_kubernetes_cluster.this.identity[0].principal_id
}

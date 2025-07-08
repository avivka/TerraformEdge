
# AKS Cluster Configuration
cluster_name = "aks-dev-cluster"
location = "North Europe"
resource_group_name = "AKS-DEV-RG"
dns_prefix = "aks-dev-k8s"
kubernetes_version = "1.31.1"
sku_tier = "Standard"

# Private Cluster Configuration
private_cluster_enabled = true
private_dns_zone_id = "System"
private_cluster_public_fqdn_enabled = false

# Security Configuration
local_account_disabled = true
azure_rbac_enabled = true
admin_group_object_ids = [] # Add your Azure AD group IDs here

# Identity Configuration
identity_type = "SystemAssigned"

# Network Configuration
network_profile = {
  network_plugin      = "azure"
  network_plugin_mode = "overlay"
  network_policy      = "calico"
  dns_service_ip      = "10.200.0.10"
  service_cidr        = "10.200.0.0/16"
  pod_cidr           = null
  load_balancer_sku  = "standard"
  outbound_type      = "userDefinedRouting"
}

# Default Node Pool Configuration
default_node_pool = {
  name                         = "system"
  vm_size                      = "Standard_D4s_v3"
  node_count                   = 3
  min_count                    = 3
  max_count                    = 5
  enable_auto_scaling          = true
  vnet_subnet_id               = null # Will be set dynamically to first subnet
  zones                        = ["1", "2", "3"]
  only_critical_addons_enabled = true
  os_disk_size_gb              = 128
  os_disk_type                 = "Ephemeral"
  max_pods                     = 30
  node_labels                  = {
    "nodepool-type" = "system"
    "environment"   = "dev"
  }
  node_taints                  = ["CriticalAddonsOnly=true:NoSchedule"]
  upgrade_settings = {
    max_surge = "33%"
  }
}

# Additional user node pools for application workloads
additional_node_pools = {
  user = {
    name                = "user"
    vm_size             = "Standard_D4s_v3"
    node_count          = 2
    min_count           = 2
    max_count           = 10
    enable_auto_scaling = true
    vnet_subnet_id      = null # Will be set dynamically to second subnet
    zones               = ["1", "2", "3"]
    os_disk_size_gb     = 128
    os_disk_type        = "Ephemeral"
    max_pods            = 30
    node_labels         = {
      "nodepool-type" = "user"
      "environment"   = "dev"
    }
    node_taints         = []
    mode                = "User"
    upgrade_settings = {
      max_surge = "33%"
    }
  }
}

# Monitoring Configuration
log_analytics_workspace_id = null # Add your Log Analytics workspace ID here

# Maintenance Window Configuration
maintenance_window = {
  allowed = [
    {
      day   = "Saturday"
      hours = [0, 1, 2, 3, 4, 5, 6, 7]
    }
  ]
  not_allowed = []
}

# Auto Scaler Profile
auto_scaler_profile = {
  balance_similar_node_groups       = true
  expander                         = "least-waste"
  max_graceful_termination_sec     = "600"
  max_node_provisioning_time       = "15m"
  max_unready_nodes               = 3
  max_unready_percentage          = 45
  new_pod_scale_up_delay          = "10s"
  scale_down_delay_after_add      = "10m"
  scale_down_delay_after_delete   = "10s"
  scale_down_delay_after_failure  = "3m"
  scan_interval                   = "10s"
  scale_down_unneeded             = "10m"
  scale_down_unready              = "20m"
  scale_down_utilization_threshold = "0.5"
  empty_bulk_delete_max           = "10"
  skip_nodes_with_local_storage   = true
  skip_nodes_with_system_pods     = true
}

# Resource Lock Configuration
enable_resource_lock = true
resource_lock_level = "ReadOnly"

# Role assignments for cluster managed identity
role_assignments = {
  # Note: These will need to be set with actual resource IDs
  # network_contributor = {
  #   scope                = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Network/virtualNetworks/xxx/subnets/xxx"
  #   role_definition_name = "Network Contributor"
  # }
}

# Tags
tags = {
  Environment = "dev"
  Project     = "AKS-Development"
  Owner       = "Platform-Team"
  CostCenter  = "IT-Infrastructure"
}

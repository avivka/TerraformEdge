#Description: This file contains the variables that are used in the terraform configuration files

# Route to INT CP
# route_to_hub - 10.5.0.0/20 -> 10.5.4.4
# route_to_ICL_10.0.0 = 10.0.0.8/8 -> 10.5.4.4
# route_to_172.16.0 = 172.16.0.0/12-> 10.5.4.4
# route_to_ICL_192.168.0.0 = 192.168.0.0/16->10.5.4.4
# route_to_internet = 0.0.0.0/0->10.5.130.36

spokes_landing_zone = [{
  spoke_name = "AKS-DEV-vNET" #new vNET name
  spoke_subnets = [           #new vNET subnets
    {
      "subnet_name"          = "AKS-UNP1-Subnet"
      "subnet_address_space" = "10.5.164.0/24"
  },
  {
      "subnet_name"          = "AKS-UNP2-Subnet"
      "subnet_address_space" = "10.5.165.0/24"
  }
  ],
  
  
   
  #spoke_resource_group_name    = "TESTLIOR-RG"
  spoke_address_space          = "10.5.164.0/22"            #new vNET address
  spoke_dns_servers            = ["10.5.1.5", "10.216.1.4"] #new vNET DNS servers 
  spoke_location               = "North Europe"
  vnet_hub_id                  = "/subscriptions/034531b7-b5e5-4b51-bc03-bffb0d55c0be/resourceGroups/MGMT-HUB-RG/providers/Microsoft.Network/virtualNetworks/HUB-VNET"       #HUB vNET id
  vnet_hub_name                = "HUB-VNET" #HUB vNET name
  vnet_hub_resource_group_name = "MGMT-HUB-RG"   #HUB vNET resource group
  udr_name                     = "AKS-DEV-UDR" #UDR name
  route_tables = [                #UDR routes
    {
      address_prefix         = "0.0.0.0/0"
      name                   = "Route_to_internet"
      next_hop_in_ip_address = "10.5.130.36"
      next_hop_type          = "VirtualAppliance"
    },
    {
      address_prefix         = "10.5.0.0/20"
      name                   = "route_to_hub"
      next_hop_in_ip_address = "10.5.4.4"
      next_hop_type          = "VirtualAppliance"

    },
    {
      address_prefix         = "172.16.0.0/12"
      name                   = "Route_to_172.16.0"
      next_hop_in_ip_address = "10.5.4.4"
      next_hop_type          = "VirtualAppliance"

    },
    {
      address_prefix         = "10.0.0.0/8"
      name                   = "Route_to_ICL_10.0.0"
      next_hop_in_ip_address = "10.5.4.4"
      next_hop_type          = "VirtualAppliance"

    },
    {
      address_prefix         = "192.168.0.0/16"
      name                   = "Route_to_ICL_192.168.0.0"
      next_hop_in_ip_address = "10.5.4.4"
      next_hop_type          = "VirtualAppliance"

    },

 
  ]

}]

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

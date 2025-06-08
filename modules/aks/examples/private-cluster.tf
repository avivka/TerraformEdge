# AVM-Compliant AKS Module
# This module follows Azure Verified Modules standards for AKS deployment
# Example: Private AKS Cluster with Enhanced Security
# This example demonstrates how to create a production-ready private AKS cluster

# Data sources
data "azurerm_client_config" "current" {}

# Create the private AKS cluster using the improved module
module "private_aks" {
  source = "./modules/aks_improved"

  # Basic configuration
  cluster_name        = "private-aks-cluster"
  location           = "eastus2"
  resource_group_name = module.resource_group.resource_group_name

  # Private cluster configuration with enhanced security
  private_cluster_enabled             = true
  private_dns_zone_id                = "System"  # Use Azure-managed private DNS
  private_cluster_public_fqdn_enabled = false
  local_account_disabled             = true
  azure_rbac_enabled                 = true

  # Premium SKU for production workloads
  sku_tier = "Standard"

  # Network configuration for optimal security
  network_profile = {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"  # Improved networking with overlay mode
    network_policy      = "calico"   # Network policy enforcement
    dns_service_ip      = "10.200.0.10"
    service_cidr        = "10.200.0.0/16"
    load_balancer_sku   = "standard"
    outbound_type      = "userDefinedRouting"  # Route through firewall/NAT gateway
  }

  # System node pool - dedicated for system components
  default_node_pool = {
    name                         = "system"
    vm_size                      = "Standard_D4s_v3"
    node_count                   = 3
    min_count                    = 3
    max_count                    = 5
    enable_auto_scaling          = true
    vnet_subnet_id               = var.aks_subnet_id
    zones                        = ["1", "2", "3"]
    only_critical_addons_enabled = true
    os_disk_size_gb              = 128
    os_disk_type                 = "Ephemeral"
    max_pods                     = 30
    
    upgrade_settings = {
      max_surge = "33%"
    }
  }

  # Additional user node pools for application workloads
  additional_node_pools = {
    # General purpose user workloads
    user = {
      name                = "user"
      vm_size             = "Standard_D4s_v3"
      node_count          = 2
      min_count           = 2
      max_count           = 10
      enable_auto_scaling = true
      vnet_subnet_id      = var.aks_subnet_id
      zones               = ["1", "2", "3"]
      os_disk_size_gb     = 128
      os_disk_type        = "Ephemeral"
      max_pods            = 30
      mode                = "User"
      upgrade_settings = {
        max_surge = "33%"
      }
    }
    
    # High-memory workloads
    memory = {
      name                = "memory"
      vm_size             = "Standard_E4s_v3"
      node_count          = 0
      min_count           = 0
      max_count           = 5
      enable_auto_scaling = true
      vnet_subnet_id      = var.aks_subnet_id
      zones               = ["1", "2", "3"]
      os_disk_size_gb     = 128
      os_disk_type        = "Ephemeral"
      max_pods            = 30
      mode                = "User"
      
      node_labels = {
        "workload-type" = "memory-intensive"
      }
      
      node_taints = [
        "workload-type=memory-intensive:NoSchedule"
      ]
      
      upgrade_settings = {
        max_surge = "33%"
      }
    }
  }

  # Azure RBAC configuration
  admin_group_object_ids = [
    var.aks_admin_group_id
  ]

  # Monitoring integration
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Maintenance window - avoid business hours
  maintenance_window = {
    allowed = [
      {
        day   = "Saturday"
        hours = [0, 1, 2, 3, 4, 5, 6, 7]
      }
    ]
    not_allowed = []
  }

  # Optimized auto scaler profile for production
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

  # Resource protection
  enable_resource_lock = true
  resource_lock_level  = "CanNotDelete"

  # Role assignments for cluster managed identity
  role_assignments = {
    # Network Contributor on the subnet for load balancer operations
    network_contributor = {
      scope                = var.aks_subnet_id
      role_definition_name = "Network Contributor"
    }
    
    # DNS Zone Contributor for private DNS integration
    dns_contributor = {
      scope                = var.private_dns_zone_id
      role_definition_name = "Private DNS Zone Contributor"
    }
  }

  # Tags for governance and cost management
  tags = {
    Environment             = "Production"
    Owner                  = "Platform Team"
    CostCenter            = "IT"
    Application           = "Kubernetes Platform"
    Backup                = "Required"
    MaintenanceWindow     = "Weekend"
    SecurityClassification = "Internal"
    Monitoring            = "Required"
  }
}

# Additional security: Network Security Group rules for AKS subnet
resource "azurerm_network_security_rule" "aks_outbound_https" {
  name                        = "AllowHTTPSOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.aks_nsg_name
}

resource "azurerm_network_security_rule" "aks_outbound_dns" {
  name                        = "AllowDNSOutbound"
  priority                    = 110
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Udp"
  source_port_range           = "*"
  destination_port_range      = "53"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = var.aks_nsg_name
}

# Output important cluster information
output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = module.private_aks.cluster_id
}

output "aks_cluster_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = module.private_aks.cluster_fqdn
}

output "aks_principal_id" {
  description = "The principal ID of the AKS cluster managed identity"
  value       = module.private_aks.principal_id
}

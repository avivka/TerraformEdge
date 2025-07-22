default_node_pool = {
  name                         = "AKS-SNP"
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
  upgrade_settings             = {
    max_surge = "33%"
  }
}

location = "North Europe"
resource_group_name = "NONPROD-NONSAP-AKS-RG"
name = "Edge-AKS-Cluster"
module "private" {
  source     = "/"
  depends_on = [azurerm_role_assignment.private_dns_zone_contributor]

  name                       = var.name
  resource_group_name        = module.aks-rg.name
  location                   = local.location
  sku_tier                   = "Standard"
  private_cluster_enabled    = var.private_cluster_enabled
  private_dns_zone_id        = azurerm_private_dns_zone.zone.id
  dns_prefix_private_cluster = dns_prefix_private_cluster.name

  azure_active_directory_role_based_access_control = {
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.current.tenant_id
  }

  managed_identities = {
    system_assigned            = false
    user_assigned_resource_ids = [azurerm_user_assigned_identity.identity.id]
  }
  network_profile = {
    dns_service_ip = "10.10.200.10"
    service_cidr   = "10.10.200.0/24"
    network_plugin = "azure"
  }

  default_node_pool = {
    name                         = "default"
    vm_size                      = "Standard_DS2_v2"
    auto_scaling_enabled         = true
    max_count                    = 3
    max_pods                     = 30
    min_count                    = 1
    vnet_subnet_id               = azurerm_subnet.subnet.id
    only_critical_addons_enabled = true

    upgrade_settings = {
      max_surge = "10%"
    }
  }

  node_pools = {
    unp1 = {
      name                 = "userpool1"
      vm_size              = "Standard_DS2_v2"
      auto_scaling_enabled = true
      max_count            = 3
      max_pods             = 30
      min_count            = 1
      os_disk_size_gb      = 128
      vnet_subnet_id       = azurerm_subnet.unp1_subnet.id

      upgrade_settings = {
        max_surge = "10%"
      }
    }
    unp2 = {
      name                 = "userpool2"
      vm_size              = "Standard_DS2_v2"
      auto_scaling_enabled = true
      max_count            = 3
      max_pods             = 30
      min_count            = 1
      os_disk_size_gb      = 128
      vnet_subnet_id       = azurerm_subnet.unp2_subnet.id

      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }

}

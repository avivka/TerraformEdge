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
  
  
   
  spoke_resource_group_name    = "NONPROD-NONSAP-AKS-RG"
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

aks = {
  default_node_pool = {
    name                         = "default"
    vm_size                      = "Standard_DS2_v2"
    auto_scaling_enabled         = true
    max_count                    = 4
    max_pods                     = 30
    min_count                    = 2
    vnet_subnet_id               = azurerm_subnet.subnet.id
    only_critical_addons_enabled = true

    upgrade_settings = {
      max_surge = "10%"
    }
  }
  location            = "North Europe"
  name                = "aks-dev-cluster"
  resource_group_name = "NONPROD-NONSAP-AKS-RG"
  azure_active_directory_role_based_access_control = {
    azure_rbac_enabled = true
    tenant_id          = "6d8a8294-466a-4e67-9658-4cb9250a19ef"
  }
  dns_prefix_private_cluster =  "aksdev"
  managed_identities = {
    system_assigned            = false
    user_assigned_resource_ids = [azurerm_user_assigned_identity.identity.id]
  }
  kubernetes_version  = "1.32.0"
  network_profile     = {
    network_plugin_mode = "overlay"
    network_policy      = "cilium"
    dns_service_ip = "10.10.200.10"
    service_cidr   = "10.10.200.0/24"
    network_plugin      = "azure"
  }
  node_pools = {
    unp1 = {
      name                 = "userpool1"
      vm_size              = "Standard_DS2_v2"
      auto_scaling_enabled = true
      max_count            = 4
      max_pods             = 30
      min_count            = 2
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
      max_count            = 4
      max_pods             = 30
      min_count            = 2
      os_disk_size_gb      = 128
      vnet_subnet_id       = azurerm_subnet.unp2_subnet.id

      upgrade_settings = {
        max_surge = "10%"
      }
    }
  }
  private_cluster_enabled = true
  private_dns_zone_id     = azurerm_private_dns_zone.zone.id
  sku_tier                = "Standard"
  tags = {
    "environment" = "nonprod"
    "team"        = "nonsap"
  }
}
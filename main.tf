#Description: This file is the main entry point for the IaC code. It is responsible for calling the modules that will create the network infrastructure.


#represent a list of "spokes", each with its own configuration
locals {
  spoke_map_landing_zone = { for s in var.spokes_landing_zone : s.spoke_name => s }
  aks = var.aks
}



#call the spoke module for each spoke in the list
module "spokes_landing_zone" {
  for_each                     = local.spoke_map_landing_zone
  source                       = "./modules/spoke"
  spoke_name                   = each.value.spoke_name
  spoke_subnets                = each.value.spoke_subnets
  spoke_resource_group_name    = each.value.spoke_resource_group_name
  spoke_address_space          = each.value.spoke_address_space
  spoke_dns_servers            = each.value.spoke_dns_servers
  spoke_location               = each.value.spoke_location
  vnet_hub_id                  = each.value.vnet_hub_id
  vnet_hub_name                = each.value.vnet_hub_name
  vnet_hub_resource_group_name = each.value.vnet_hub_resource_group_name
  udr_name                     = each.value.udr_name
  route_tables                 = each.value.route_tables

  providers = {
    azurerm.source = azurerm.sub-nonsap-nonprod
    #azurerm.source = azurerm.PROD
    azurerm.destination = azurerm.sub-hub
  }

}

module "aks" {
  source                                           = "./modules/aks"
  default_node_pool                                = local.aks.default_node_pool
  location                                         = local.aks.location
  name                                             = local.aks.name
  resource_group_name                              = local.aks.resource_group_name
  azure_active_directory_role_based_access_control = local.aks.azure_active_directory_role_based_access_control
  dns_prefix_private_cluster                       = local.aks.dns_prefix_private_cluster
  managed_identities                               = local.aks.managed_identities
  network_profile                                  = local.aks.network_profile
  node_pools                                       = local.aks.node_pools
  private_cluster_enabled                          = local.aks.private_cluster_enabled
  private_dns_zone_id                              = local.aks.private_dns_zone_id
  sku_tier                                         = local.aks.sku_tier
  tags                                             = local.aks.tags
  depends_on                                       = [module.spokes_landing_zone, azurerm_role_assignment.private_dns_zone_contributor]
}

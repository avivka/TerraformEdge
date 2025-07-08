# Description: This file is the main entry point for the IaC code.


#represent a list of "spokes", each with its own configuration
locals {
  spoke_map_landing_zone = { for s in var.spokes_landing_zone : s.spoke_name => s }
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

module "aks_cluster" {
  source = "./modules/aks"

  cluster_name                  = var.cluster_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  dns_prefix                    = var.dns_prefix
  kubernetes_version            = var.kubernetes_version
  sku_tier                      = var.sku_tier
  private_cluster_enabled       = var.private_cluster_enabled
  private_dns_zone_id           = var.private_dns_zone_id
  private_cluster_public_fqdn_enabled = var.private_cluster_public_fqdn_enabled

  local_account_disabled        = var.local_account_disabled
  azure_rbac_enabled            = var.azure_rbac_enabled
  admin_group_object_ids        = var.admin_group_object_ids

  identity_type                 = var.identity_type

  network_profile               = var.network_profile

  default_node_pool             = var.default_node_pool
  additional_node_pools         = var.additional_node_pools

  providers                     = {
    azurerm.source      = azurerm.sub-nonsap-nonprod
    azurerm.destination = azurerm.PROD
  }
}


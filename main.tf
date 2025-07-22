#Description: This file is the main entry point for the IaC code. It is responsible for calling the modules that will create the network infrastructure.


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

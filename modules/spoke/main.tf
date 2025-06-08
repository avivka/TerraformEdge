terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4"
      configuration_aliases = [ azurerm.source, azurerm.destination ]
    }
  }
}

# Create a new vNET
resource "azurerm_virtual_network" "spoke" {
  name                = var.spoke_name
  resource_group_name = var.spoke_resource_group_name
  address_space       = [var.spoke_address_space]
  location            = var.spoke_location
  provider = azurerm.source
}

#Configure DNS to vNET
resource "azurerm_virtual_network_dns_servers" "spoke_dns" {
  virtual_network_id = azurerm_virtual_network.spoke.id
  dns_servers        = var.spoke_dns_servers
}


#map where each key is a subnet name and each value is the corresponding subnet's address space.
#This map can be used to quickly access the address space of a subnet by its name.
locals {
  subnet_map = { for s in var.spoke_subnets : s.subnet_name => s }
  route_map  = { for r in var.route_tables : r.name => r }
}

#create Subnets inside the vNET
resource "azurerm_subnet" "spoke_subnets" {
  for_each             = local.subnet_map
  name                 = each.key
  resource_group_name  = var.spoke_resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = [each.value.subnet_address_space]
  provider = azurerm.source #Lior Added
}

#Create a route table
resource "azurerm_route_table" "spoke_udr" {
  name                          = var.udr_name
  location                      = azurerm_virtual_network.spoke.location
  resource_group_name           = azurerm_virtual_network.spoke.resource_group_name
  bgp_route_propagation_enabled = false
  provider = azurerm.source

}


#Create routes in the route table
resource "azurerm_route" "route_table" {
  for_each = local.route_map

  route_table_name       = azurerm_route_table.spoke_udr.name
  resource_group_name    = azurerm_route_table.spoke_udr.resource_group_name
  name                   = each.value.name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
  provider = azurerm.source

}

#Associate the route table with the subnets
resource "azurerm_subnet_route_table_association" "subnet_route_table_association" {
  for_each       = local.subnet_map
  subnet_id      = azurerm_subnet.spoke_subnets[each.key].id
  route_table_id = azurerm_route_table.spoke_udr.id
  provider = azurerm.source
}


# peer hub --> spoke
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                         = "${var.vnet_hub_name}-to-${azurerm_virtual_network.spoke.name}"
  resource_group_name          = var.vnet_hub_resource_group_name
  virtual_network_name         = var.vnet_hub_name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = true
  use_remote_gateways          = false
  provider = azurerm.destination
}

# peer spoke --> hub
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                         = "${azurerm_virtual_network.spoke.name}-to-${var.vnet_hub_name}"
  resource_group_name          = azurerm_virtual_network.spoke.resource_group_name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = var.vnet_hub_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false # set this to true after creating the hub vnet gateway
provider = azurerm.source

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

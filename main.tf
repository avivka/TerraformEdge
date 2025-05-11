locals {
  location = "northeurope"
}

resource "azurerm_resource_group" "aks-rg" {
  location = local.location
  name     = var.azurerm_resource_group_name
  tags = {
    environment = "Terraform"
    created_by  = "Terraform"
    created_on  = formatdate("YYYY-MM-DD", timestamp())
    terraform   = "true"

  }
}

# resource "azurerm_virtual_network" "vnet" {
#   address_space       = ["10.1.0.0/16"]
#   location            = azurerm_resource_group.aks-rg.location
#   name                = "private-vnet"
#   resource_group_name = azurerm_resource_group.aks-rg.name
# }

data "azurerm_virtual_network" "AKS" {
  name                = "AKS-DEV-vNET"
  resource_group_name = azurerm_resource_group.aks-rg.name

}

data "azurerm_subnet" "UNP1" {
  name                 = "AKS-UNP1-Subnet"
  resource_group_name  = azurerm_resource_group.aks-rg.name
  virtual_network_name = data.azurerm_virtual_network.AKS.id

}

data "azurerm_subnet" "UNP2" {
  name                 = "AKS-UNP2-Subnet"
  resource_group_name  = azurerm_resource_group.aks-rg.name
  virtual_network_name = data.azurerm_virtual_network.AKS.id

}

# resource "azurerm_subnet" "subnet" {
#   address_prefixes     = ["10.1.0.0/24"]
#   name                 = "default"
#   resource_group_name  = azurerm_resource_group.aks-rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

# resource "azurerm_subnet" "unp1_subnet" {
#   address_prefixes     = ["10.1.1.0/24"]
#   name                 = "unp1"
#   resource_group_name  = azurerm_resource_group.aks-rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

# resource "azurerm_subnet" "unp2_subnet" {
#   address_prefixes     = ["10.1.2.0/24"]
#   name                 = "unp2"
#   resource_group_name  = azurerm_resource_group.aks-rg.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
# }

resource "azurerm_private_dns_zone" "zone" {
  name                = "privatelink.${azurerm_resource_group.aks-rg.location}.azmk8s.io"
  resource_group_name = azurerm_resource_group.aks-rg.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "privatelink-${azurerm_resource_group.aks-rg.location}-azmk8s-io"
  private_dns_zone_name = azurerm_private_dns_zone.zone.name
  resource_group_name   = azurerm_resource_group.aks-rg.name
  virtual_network_id    = data.azurerm_virtual_network.AKS.id
}

resource "azurerm_user_assigned_identity" "identity" {
  location            = azurerm_resource_group.aks-rg.location
  name                = "aks-identity"
  resource_group_name = azurerm_resource_group.aks-rg.name
}

resource "azurerm_role_assignment" "private_dns_zone_contributor" {
  principal_id         = azurerm_user_assigned_identity.identity.principal_id
  scope                = azurerm_private_dns_zone.zone.id
  role_definition_name = "Private DNS Zone Contributor"
}

# resource "random_string" "dns_prefix" {
#   length  = 10    # Set the length of the string
#   lower   = true  # Use lowercase letters
#   numeric = true  # Include numbers
#   special = false # No special characters
#   upper   = false # No uppercase letters
# }

data "azurerm_client_config" "current" {

}


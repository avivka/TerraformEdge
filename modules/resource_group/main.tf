terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
  }
}

# Data source for existing Resource Group
data "azurerm_resource_group" "rg" {
  name = var.name
}

# Lock if specified
resource "azurerm_management_lock" "rg_lock" {
  count = var.lock.kind != "None" ? 1 : 0

  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = data.azurerm_resource_group.rg.id
  lock_level = var.lock.kind
  notes      = var.lock.notes
}

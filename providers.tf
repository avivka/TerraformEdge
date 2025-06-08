terraform {
  required_version = ">= 1.4.4"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0, < 5.0.0"
    }
  }

  backend "azurerm" {
      resource_group_name = "NONPROD-NONSAP-APP-IACS-RG"
      storage_account_name = "saiacatomation"
      container_name = "vnetcreation"
      key = "terraform.tfstate"
      subscription_id = "36345da4-d9b3-43c5-80d5-81cd4fc0035d"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
  subscription_id = "36345da4-d9b3-43c5-80d5-81cd4fc0035d"
}

provider "azurerm" {
  features {
    
  }
  alias = "sub-hub"
  subscription_id = "034531b7-b5e5-4b51-bc03-bffb0d55c0be"
}

provider "azurerm" {
  features {
    
  }
  alias = "sub-nonsap-nonprod"
  subscription_id = "36345da4-d9b3-43c5-80d5-81cd4fc0035d"
}

provider "azurerm" {
  features {
    
  }
  alias = "PROD"
  subscription_id = "a099c6a5-6c7b-4e8f-b523-6c4e70698b36"
}

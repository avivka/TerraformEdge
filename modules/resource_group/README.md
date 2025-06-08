# Azure Resource Group Terraform Module

This module creates an Azure Resource Group following Azure Verified Modules (AVM) best practices.

## Features

- Creates a single Azure Resource Group
- Optional resource locking capability
- Follows Azure Verified Modules best practices
- Supports tags

## Usage

```hcl
module "resource_group" {
  source = "./Modules/resource_group"

  name     = "my-resource-group"
  location = "eastus2"
  
  # Optional: Enable resource locking
  lock = {
    name  = "resource-lock"
    kind  = "CanNotDelete"
    notes = "Locked to prevent accidental deletion"
  }
  
  # Optional: Add tags
  tags = {
    Environment = "Production"
    Owner       = "Team"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | The name of the resource group | string | n/a | yes |
| location | The Azure region where the resource group should be created | string | n/a | yes |
| prevent_resource_group_deletion | Should the resource group be protected from accidental deletion? | bool | false | no |
| lock | The lock configuration for the resource group | object | `{ kind = "None" }` | no |
| tags | A mapping of tags to assign to the resource group | map(string) | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | The name of the resource group |
| resource_group_id | The ID of the resource group |
| resource_group_location | The location of the resource group |

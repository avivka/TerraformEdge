# Azure Resource Group Terraform Module

This module references an existing Azure Resource Group and provides optional resource locking capability.

## Features

- References an existing Azure Resource Group via data source
- Optional resource locking capability
- Follows Azure Verified Modules best practices
- Outputs resource group information for use in other modules

## Usage

```hcl
module "resource_group" {
  source = "./Modules/resource_group"

  name = "existing-resource-group"
  
  # Optional: Enable resource locking
  lock = {
    name  = "resource-lock"
    kind  = "CanNotDelete"
    notes = "Locked to prevent accidental deletion"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | The name of the existing resource group | string | n/a | yes |
| lock | The lock configuration for the resource group | object | `{ kind = "None" }` | no |

## Outputs

| Name | Description |
|------|-------------|
| resource_group_name | The name of the resource group |
| resource_group_id | The ID of the resource group |
| resource_group_location | The location of the resource group |

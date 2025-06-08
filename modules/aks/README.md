# AKS Module - Azure Verified Modules Compliant

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_kubernetes_cluster.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster) | resource |
| [azurerm_kubernetes_cluster_node_pool.additional](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster_node_pool) | resource |
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the AKS cluster | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure location where the AKS cluster will be deployed | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the AKS cluster will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The ID of the AKS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the AKS cluster |
| <a name="output_kube_config"></a> [kube\_config](#output\_kube\_config) | Kubernetes configuration for the AKS cluster |

## Examples

### Basic Private AKS Cluster
```hcl
module "aks" {
  source = "./Modules/aks"

  cluster_name        = "my-aks-cluster"
  location           = "eastus2"
  resource_group_name = "my-rg"
  
  # Private cluster configuration
  private_cluster_enabled = true
  private_dns_zone_id    = azurerm_private_dns_zone.aks.id
  
  # Node pool configuration
  default_node_pool = {
    name                = "default"
    vm_size            = "Standard_D2s_v3"
    node_count         = 3
    vnet_subnet_id     = azurerm_subnet.aks.id
  }
  
  tags = {
    Environment = "Production"
    Owner       = "Platform Team"
  }
}
```

### Advanced Private AKS Cluster with Multiple Node Pools
```hcl
module "aks" {
  source = "./Modules/aks"

  cluster_name        = "my-private-aks"
  location           = "eastus2"
  resource_group_name = "my-rg"
  
  # Private cluster with custom DNS
  private_cluster_enabled = true
  private_dns_zone_id    = "System"
  
  # Enhanced security
  azure_rbac_enabled = true
  local_account_disabled = true
  
  # System-assigned managed identity
  identity_type = "SystemAssigned"
  
  # Network configuration
  network_profile = {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "calico"
    service_cidr       = "10.200.0.0/16"
    dns_service_ip     = "10.200.0.10"
  }
  
  # Default system node pool
  default_node_pool = {
    name                         = "system"
    vm_size                     = "Standard_D2s_v3"
    node_count                  = 3
    vnet_subnet_id              = azurerm_subnet.aks.id
    only_critical_addons_enabled = true
    zones                       = ["1", "2", "3"]
  }
  
  # Additional user node pools
  additional_node_pools = {
    user = {
      name           = "user"
      vm_size        = "Standard_D4s_v3"
      node_count     = 2
      vnet_subnet_id = azurerm_subnet.aks.id
      zones          = ["1", "2", "3"]
      node_taints    = []
    }
  }
  
  # Monitoring and logging
  log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  
  tags = {
    Environment = "Production"
    Owner       = "Platform Team"
  }
}
```
<!-- END_TF_DOCS -->

# Primary outputs
output "cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.name
}

output "cluster_fqdn" {
  description = "The FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.fqdn
}

output "cluster_private_fqdn" {
  description = "The private FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.private_fqdn
}

# Kubernetes configuration
output "kube_config" {
  description = "Kubernetes configuration for the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config
  sensitive   = true
}

output "kube_config_raw" {
  description = "Raw Kubernetes configuration for the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate"
  value       = azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate
  sensitive   = true
}

output "host" {
  description = "The Kubernetes cluster server host"
  value       = azurerm_kubernetes_cluster.this.kube_config.0.host
  sensitive   = true
}

# Identity outputs
output "identity" {
  description = "The identity block of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.identity
}

output "kubelet_identity" {
  description = "The kubelet identity of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.kubelet_identity
}

output "principal_id" {
  description = "The principal ID of the system assigned identity"
  value       = try(azurerm_kubernetes_cluster.this.identity[0].principal_id, null)
}

# Node pool outputs
output "node_resource_group" {
  description = "The auto-generated resource group which contains the resources for this AKS cluster"
  value       = azurerm_kubernetes_cluster.this.node_resource_group
}

output "node_pool_ids" {
  description = "The IDs of the additional node pools"
  value       = { for k, v in azurerm_kubernetes_cluster_node_pool.additional : k => v.id }
}

# Network outputs
output "effective_outbound_ips" {
  description = "The effective outbound IP addresses of the cluster"
  value       = try(azurerm_kubernetes_cluster.this.network_profile[0].load_balancer_profile[0].effective_outbound_ips, [])
}

# Portal URL
output "portal_fqdn" {
  description = "The portal FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.this.portal_fqdn
}

# OIDC issuer URL
output "oidc_issuer_url" {
  description = "The OIDC issuer URL that is associated with the cluster"
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

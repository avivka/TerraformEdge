# Purpose: Define the input variables for the spoke landing zone module

variable "spokes_landing_zone" {
  type = list(object({
    spoke_name = string
    spoke_subnets = list(object({
      subnet_name          = string
      subnet_address_space = string
    }))
    spoke_resource_group_name    = string
    spoke_address_space          = string
    spoke_dns_servers            = list(string)
    spoke_location               = string
    vnet_hub_id                  = string
    vnet_hub_name                = string
    vnet_hub_resource_group_name = string
    udr_name                     = string
    route_tables = list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = string
    }))

  }))
}

variable "aks" {
  type = object({
    name                = string
    default_node_pool   = object({
      name            = string
      vm_size         = string
      os_disk_size_gb = number
      node_count      = number
    })
    node_pools         = list(object({
      name            = string
      vm_size         = string
      os_disk_size_gb = number
      node_count      = number
    }))
    resource_group_name = string
    location            = string
    dns_prefix          = string
    kubernetes_version  = string
    network_profile     = object({
      network_plugin_mode = string
      network_policy      = string
    })
    tags                = map(string)
  })
}
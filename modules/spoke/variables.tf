#description: This file contains the variables used in the spoke module

variable "spoke_name" {
  description = "Name of the spoke"
  type        = string
}

# variable of a list of maps, each map has a susbnet name and address space
variable "spoke_subnets" {
  description = "Subnets of the spoke"
  type = list(object({
    subnet_name          = string
    subnet_address_space = string
  }))
}

variable "vnet_hub_id" {
  description = "ID of the hub vnet"
  type        = string
}

variable "spoke_resource_group_name" {
  description = "Name of the spoke resource group"
  type        = string
}

variable "spoke_address_space" {
  description = "Address space of the spoke"
  type        = string
}

variable "spoke_location" {
  description = "Location of the spoke"
  type        = string
}

variable "vnet_hub_name" {
  description = "Name of the hub"
  type        = string
}

variable "vnet_hub_resource_group_name" {
  description = "Name of the hub resource group"
  type        = string
}

variable "spoke_dns_servers" {
  description = "Spoke DNS servers"
  type        = list(string)
}

variable "udr_name" {
  description = "Name of the UDR"
  type        = string

}


variable "route_tables" {
  description = "List of route tables"
  type = list(object({
    name                   = string
    address_prefix         = string
    next_hop_type          = string
    next_hop_in_ip_address = string
  }))
}

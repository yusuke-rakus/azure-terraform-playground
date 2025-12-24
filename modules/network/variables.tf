variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "workload" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "vnet_scope" {
  type = string
}

variable "vnet_instance" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "private_endpoint_subnet_address_space" {
  type = list(string)
}

variable "vnet_integration_subnet_address_space" {
  type = list(string)
}

variable "vnet_integration_route_prefix" {
  type = string
}

variable "vnet_integration_route_next_hop_type" {
  type = string
}

variable "vnet_integration_route_next_hop_ip" {
  type = string
}

variable "private_dns_zone_name" {
  type = string
}

variable "vnet_peerings" {
  description = "Remote VNets to peer with this VNet"
  type = list(object({
    name                = string
    resource_group_name = string
  }))
  default = []
}

variable "vnet_peering_allow_virtual_network_access" {
  type = bool
}

variable "vnet_peering_allow_forwarded_traffic" {
  type = bool
}

variable "vnet_peering_allow_gateway_transit" {
  type = bool
}

variable "vnet_peering_use_remote_gateways" {
  type = bool
}

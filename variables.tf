variable "subscription_id" {
  description = "value"
  type        = string
}

variable "workload" {
  description = "value"
  type        = string
}

variable "environment" {
  description = "value"
  type        = string
}

variable "location" {
  description = "value"
  type        = string
}

variable "location_short" {
  description = "value"
  type        = string
}

variable "tags" {
  description = "value"
  type        = map(string)
}

variable "vnet_scope" {
  description = "value"
  type        = string
  default     = "spoke"
}

variable "vnet_instance" {
  description = "value"
  type        = string
  default     = "001"
}

variable "vnet_address_space" {
  description = "value"
  type        = list(string)
  default     = ["10.26.2.0/23"]
}

variable "private_endpoint_subnet_address_space" {
  description = "value"
  type        = list(string)
  default     = ["10.26.2.32/27"]
}

variable "vnet_integration_subnet_address_space" {
  description = "value"
  type        = list(string)
}

variable "vnet_integration_route_prefix" {
  description = "value"
  type        = string
}

variable "vnet_integration_route_next_hop_type" {
  default = "value"
  type    = string
}

variable "vnet_integration_route_next_hop_ip" {
  default = "value"
  type    = string
}

variable "private_dns_zone_name" {
  description = "value"
  type        = string
  default     = "privatelink.azurewebsites.net"
}

variable "vnet_peerings" {
  description = "value"
  type = list(object({
    name                = string
    resource_group_name = string
  }))
  default = []
}

variable "vnet_peering_allow_virtual_network_access" {
  description = "value"
  type        = bool
}

variable "vnet_peering_allow_forwarded_traffic" {
  description = "value"
  type        = bool
}

variable "vnet_peering_allow_gateway_transit" {
  description = "value"
  type        = bool
}

variable "vnet_peering_use_remote_gateways" {
  description = "value"
  type        = bool
}

variable "app_service_plan_sku_name" {
  description = "value"
  type        = string
  default     = "B1"
}

variable "app_service_plan_instance" {
  description = "value"
  type        = string
  default     = "001"
}

variable "app_services" {
  description = "value"
  type = map(object({
    instance   = string
    private_ip = string
  }))
}

variable "access_restriction_allow_100" {
  description = "value"
  type        = list(string)
}

variable "access_restriction_allow_200" {
  description = "value"
  type        = list(string)
}

variable "access_restriction_allow_300" {
  description = "value"
  type        = list(string)
}

variable "postgresql" {
  description = "PostgreSQL Flexible Server settings"
  type = object({
    instance               = string
    server_version         = string
    sku_name               = string
    storage_mb             = number
    backup_retention_days  = number
    administrator_login    = string
    administrator_password = string
    private_endpoint_ip    = string
    private_dns_zone_name  = string
  })
}

variable "search_service" {
  description = "Azure AI Search settings"
  type = object({
    instance              = string
    sku                   = string
    replica_count         = number
    partition_count       = number
    private_endpoint_ip   = string
    private_dns_zone_name = string
  })
}

variable "storage_account" {
  description = "Storage account settings"
  type = object({
    instance                 = string
    account_tier             = string
    account_replication_type = string
    private_endpoint_ip      = string
    private_dns_zone_name    = string
  })
}

variable "acr_resource_group_name" {
  description = "value"
  type        = string
}

variable "acr_name" {
  description = "value"
  type        = string
}

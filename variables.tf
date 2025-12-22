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

variable "private_dns_zone_name" {
  description = "value"
  type        = string
  default     = "privatelink.azurewebsites.net"
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
    instance             = string
    sku                  = string
    replica_count        = number
    partition_count      = number
    private_endpoint_ip  = string
    private_dns_zone_name = string
  })
}

variable "storage_account" {
  description = "Storage account settings"
  type = object({
    instance                = string
    account_tier            = string
    account_replication_type = string
    private_endpoint_ip     = string
    private_dns_zone_name   = string
  })
}

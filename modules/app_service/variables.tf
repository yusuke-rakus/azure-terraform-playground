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

variable "app_service_plan_sku_name" {
  type = string
}

variable "app_service_plan_instance" {
  type = string
}

variable "apps" {
  type = map(object({
    instance   = string
    private_ip = string
  }))
}

variable "vnet_integration_subnet_id" {
  type = string
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "private_dns_zone_id" {
  type = string
}

variable "app_insights_connection_strings" {
  type = map(string)
}

variable "user_assigned_identity_id" {
  type = string
}

variable "access_restriction_allow_100" {
  type = list(string)
}


variable "access_restriction_allow_200" {
  type = list(string)
}


variable "access_restriction_allow_300" {
  type = list(string)
}

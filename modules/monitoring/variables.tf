variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type = map(string)
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

variable "log_analytics_sku_name" {
  type    = string
  default = "PerGB2018"
}

variable "app_insights" {
  type = map(object({
    instance = string
  }))
}

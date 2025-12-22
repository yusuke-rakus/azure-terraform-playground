variable "resouce_group_name" {
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

variable "private_dns_zone_name" {
  type = string
}

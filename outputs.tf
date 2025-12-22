output "resource_group_name" {
  value = azurerm_resource_group.this.name
}

output "resouce_group_location" {
  value = azurerm_resource_group.this.location
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "app_service_names" {
  value = module.app_service.app_service_names
}

output "app_insights_names" {
  value = module.monitoring.app_insights_names
}

output "private_endpoint_ips" {
  value = module.app_service.private_endpoint_ids
}

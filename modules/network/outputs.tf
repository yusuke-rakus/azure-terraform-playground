output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoint.id
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.app_service.id
}

output "private_dns_zone_name" {
  value = azurerm_private_dns_zone.app_service.name
}

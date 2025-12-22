output "search_service_name" {
  value = azurerm_search_service.this.name
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.search.id
}

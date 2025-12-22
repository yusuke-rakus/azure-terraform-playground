output "server_name" {
  value = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  value = azurerm_postgresql_flexible_server.this.fqdn
}

output "private_dns_zone_id" {
  value = azurerm_private_dns_zone.postgres.id
}

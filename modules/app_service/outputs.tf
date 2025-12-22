output "app_service_names" {
  value = { for key, app in azurerm_linux_web_app.this : key => app.name }
}

output "private_endpoint_ids" {
  value = { for key, pep in azurerm_private_endpoint.this : key => pep.private_service_connection[0].private_ip_address }
}

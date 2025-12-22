output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.this.id
}

output "app_insights_names" {
  value = { for key, appi in azurerm_application_insights.this : key => appi.name }
}

output "app_insights_connection_strings" {
  value = { for key, appi in azurerm_application_insights.this : key => appi.connection_string }
}

locals {
  log_analytics_name = "log-${var.workload}-${var.environment}-${var.region}"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku_name
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_application_insights" "this" {
  for_each            = var.app_insights
  name                = "appi-${var.workload}-${var.environment}-${var.region}-${each.value.instance}"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.this.id
  tags                = var.tags
}

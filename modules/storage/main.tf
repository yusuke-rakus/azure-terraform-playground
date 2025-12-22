locals {
  storage_account_base_name       = "st${replace(var.workload, "-", "")}${var.environment}${var.region}${var.instance}"
  storage_account_name            = lower(substr(local.storage_account_base_name, 0, 24))
  dns_link_name                   = "link-${var.workload}-${var.environment}-${var.region}-st-${var.instance}"
  private_endpoint_name           = "pep-${var.workload}-${var.environment}-st-${var.instance}"
  private_service_connection_name = "psc-${var.workload}-${var.environment}-st-${var.instance}"
}

resource "azurerm_storage_account" "this" {
  name                     = local.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_kind             = "StorageV2"
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false

  tags = var.tags
}

resource "azurerm_private_dns_zone" "blob" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = local.dns_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = var.vnet_id
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "blob" {
  name                = local.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = local.private_service_connection_name
    private_connection_resource_id = azurerm_storage_account.this.id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  ip_configuration {
    name               = "primary"
    private_ip_address = var.private_endpoint_ip
    subresource_name   = "blob"
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }
}

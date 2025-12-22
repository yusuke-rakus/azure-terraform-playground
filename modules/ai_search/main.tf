locals {
  search_service_name                = lower("sea-${var.workload}-${var.environment}-${var.region}-${var.instance}")
  dns_link_name                      = "link-${var.workload}-${var.environment}-${var.region}-search-${var.instance}"
  private_endpoint_name              = "pep-${var.workload}-${var.environment}-search-${var.instance}"
  private_service_connection_name    = "psc-${var.workload}-${var.environment}-search-${var.instance}"
}

resource "azurerm_search_service" "this" {
  name                = local.search_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  replica_count       = var.replica_count
  partition_count     = var.partition_count

  public_network_access_enabled = false

  tags = var.tags
}

resource "azurerm_private_dns_zone" "search" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "search" {
  name                  = local.dns_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.search.name
  virtual_network_id    = var.vnet_id
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "search" {
  name                = local.private_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = local.private_service_connection_name
    private_connection_resource_id = azurerm_search_service.this.id
    is_manual_connection           = false
    subresource_names              = ["searchService"]
  }

  ip_configuration {
    name               = "primary"
    private_ip_address = var.private_endpoint_ip
    subresource_name   = "searchService"
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.search.id]
  }
}

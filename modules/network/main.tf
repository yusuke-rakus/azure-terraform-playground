locals {
  vnet_name     = "vnet-${var.workload}-${var.environment}-${var.region}-${var.vnet_scope}-${var.vnet_instance}"
  subnet_name   = "snet-${var.workload}-${var.environment}-pep-${var.vnet_instance}"
  dns_link_name = "link-${var.workload}-${var.environment}-${var.region}-${var.vnet_scope}-${var.vnet_instance}"
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resouce_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}


resource "azurerm_subnet" "private_endpoint" {
  name                 = local.subnet_name
  resource_group_name  = var.resouce_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.private_endpoint_subnet_address_space

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_private_dns_zone" "app_service" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resouce_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  name                  = local.dns_link_name
  resource_group_name   = var.resouce_group_name
  private_dns_zone_name = azurerm_private_dns_zone.app_service.name
  virtual_network_id    = azurerm_virtual_network.this.id
  tags                  = var.tags
}

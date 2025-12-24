locals {
  vnet_name                  = "vnet-${var.workload}-${var.environment}-${var.region}-${var.vnet_scope}-${var.vnet_instance}"
  private_endpoint_subnet    = "snet-${var.workload}-${var.environment}-pep-${var.vnet_instance}"
  vnet_integration_subnet    = "snet-${var.workload}-${var.environment}-vnetinteg-${var.vnet_instance}"
  vnet_integration_route_tbl = "rt-${var.workload}-${var.environment}-${var.region}-${var.vnet_instance}"
  dns_link_name              = "link-${var.workload}-${var.environment}-${var.region}-${var.vnet_scope}-${var.vnet_instance}"
}

resource "azurerm_virtual_network" "this" {
  name                = local.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}


resource "azurerm_subnet" "private_endpoint" {
  name                 = local.private_endpoint_subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.private_endpoint_subnet_address_space

  private_endpoint_network_policies = "Disabled"
}

resource "azurerm_route_table" "vnet_integration" {
  name                = local.vnet_integration_route_tbl
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  route {
    name                   = "default"
    address_prefix         = var.vnet_integration_route_prefix
    next_hop_type          = var.vnet_integration_route_next_hop_type
    next_hop_in_ip_address = var.vnet_integration_route_next_hop_ip
  }
}

resource "azurerm_subnet" "vnet_integration" {
  name                 = local.vnet_integration_subnet
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.vnet_integration_subnet_address_space

  delegation {
    name = "webapp-delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

resource "azurerm_subnet_route_table_association" "vnet_integration" {
  subnet_id      = azurerm_subnet.vnet_integration.id
  route_table_id = azurerm_route_table.vnet_integration.id
}

resource "azurerm_private_dns_zone" "app_service" {
  name                = var.private_dns_zone_name
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "app_service" {
  name                  = local.dns_link_name
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.app_service.name
  virtual_network_id    = azurerm_virtual_network.this.id
  tags                  = var.tags
}

data "azurerm_virtual_network" "remote" {
  for_each = {
    for peering in var.vnet_peerings : peering.name => peering
  }

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_virtual_network_peering" "this_to_remote" {
  for_each = data.azurerm_virtual_network.remote

  name                         = "peer-${local.vnet_name}-to-${each.value.name}"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = azurerm_virtual_network.this.name
  remote_virtual_network_id    = each.value.id
  allow_virtual_network_access = var.vnet_peering_allow_virtual_network_access
  allow_forwarded_traffic      = var.vnet_peering_allow_forwarded_traffic
  allow_gateway_transit        = var.vnet_peering_allow_gateway_transit
  use_remote_gateways          = var.vnet_peering_use_remote_gateways
}

resource "azurerm_virtual_network_peering" "remote_to_this" {
  for_each = data.azurerm_virtual_network.remote

  name                         = "peer-${each.value.name}-to-${local.vnet_name}"
  resource_group_name          = each.value.resource_group_name
  virtual_network_name         = each.value.name
  remote_virtual_network_id    = azurerm_virtual_network.this.id
  allow_virtual_network_access = var.vnet_peering_allow_virtual_network_access
  allow_forwarded_traffic      = var.vnet_peering_allow_forwarded_traffic
  allow_gateway_transit        = var.vnet_peering_allow_gateway_transit
  use_remote_gateways          = var.vnet_peering_use_remote_gateways
}

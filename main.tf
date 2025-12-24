terraform {
  required_version = ">=1.14.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.57.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "this" {
  name     = local.resouce_group_name
  location = var.location
  tags     = local.common_tags
}

data "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.acr_resource_group_name
}

resource "azurerm_user_assigned_identity" "acr_pull" {
  name                = local.user_assigned_identity_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.common_tags
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_pull.principal_id
}

module "network" {
  source = "./modules/network"

  resource_group_name                       = azurerm_resource_group.this.name
  location                                  = azurerm_resource_group.this.location
  tags                                      = local.common_tags
  workload                                  = var.workload
  environment                               = var.environment
  region                                    = var.location_short
  vnet_scope                                = var.vnet_scope
  vnet_instance                             = var.vnet_instance
  vnet_address_space                        = var.vnet_address_space
  private_endpoint_subnet_address_space     = var.private_endpoint_subnet_address_space
  vnet_integration_subnet_address_space     = var.vnet_integration_subnet_address_space
  vnet_integration_route_prefix             = var.vnet_integration_route_prefix
  vnet_integration_route_next_hop_type      = var.vnet_integration_route_next_hop_type
  vnet_integration_route_next_hop_ip        = var.vnet_integration_route_next_hop_ip
  private_dns_zone_name                     = var.private_dns_zone_name
  vnet_peerings                             = var.vnet_peerings
  vnet_peering_allow_virtual_network_access = var.vnet_peering_allow_virtual_network_access
  vnet_peering_allow_forwarded_traffic      = var.vnet_peering_allow_forwarded_traffic
  vnet_peering_allow_gateway_transit        = var.vnet_peering_allow_gateway_transit
  vnet_peering_use_remote_gateways          = var.vnet_peering_use_remote_gateways
}

module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  tags                = local.common_tags
  workload            = var.workload
  environment         = var.environment
  region              = var.location_short
  app_insights = {
    for key, value in var.app_services : key => {
      instance = value.instance
    }
  }
}

module "app_service" {
  source = "./modules/app_service"

  resource_group_name             = azurerm_resource_group.this.name
  location                        = azurerm_resource_group.this.location
  tags                            = local.common_tags
  workload                        = var.workload
  environment                     = var.environment
  region                          = var.location_short
  app_service_plan_sku_name       = var.app_service_plan_sku_name
  app_service_plan_instance       = var.app_service_plan_instance
  apps                            = var.app_services
  vnet_integration_subnet_id      = module.network.vnet_integration_subnet_id
  private_endpoint_subnet_id      = module.network.private_endpoint_subnet_id
  private_dns_zone_id             = module.network.private_dns_zone_id
  app_insights_connection_strings = module.monitoring.app_insights_connection_strings
  user_assigned_identity_id       = azurerm_user_assigned_identity.acr_pull.id
  access_restriction_allow_100    = var.access_restriction_allow_100
  access_restriction_allow_200    = var.access_restriction_allow_200
  access_restriction_allow_300    = var.access_restriction_allow_300
}

module "postgresql" {
  source = "./modules/postgresql"

  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  tags                       = local.common_tags
  workload                   = var.workload
  environment                = var.environment
  region                     = var.location_short
  instance                   = var.postgresql.instance
  server_version             = var.postgresql.server_version
  sku_name                   = var.postgresql.sku_name
  storage_mb                 = var.postgresql.storage_mb
  backup_retention_days      = var.postgresql.backup_retention_days
  administrator_login        = var.postgresql.administrator_login
  administrator_password     = var.postgresql.administrator_password
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  private_dns_zone_name      = var.postgresql.private_dns_zone_name
  vnet_id                    = module.network.vnet_id
  private_endpoint_ip        = var.postgresql.private_endpoint_ip
}

module "ai_search" {
  source = "./modules/ai_search"

  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  tags                       = local.common_tags
  workload                   = var.workload
  environment                = var.environment
  region                     = var.location_short
  instance                   = var.search_service.instance
  sku                        = var.search_service.sku
  replica_count              = var.search_service.replica_count
  partition_count            = var.search_service.partition_count
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  private_dns_zone_name      = var.search_service.private_dns_zone_name
  vnet_id                    = module.network.vnet_id
  private_endpoint_ip        = var.search_service.private_endpoint_ip
}

module "storage" {
  source = "./modules/storage"

  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  tags                       = local.common_tags
  workload                   = var.workload
  environment                = var.environment
  region                     = var.location_short
  instance                   = var.storage_account.instance
  account_tier               = var.storage_account.account_tier
  account_replication_type   = var.storage_account.account_replication_type
  private_endpoint_subnet_id = module.network.private_endpoint_subnet_id
  private_dns_zone_name      = var.storage_account.private_dns_zone_name
  vnet_id                    = module.network.vnet_id
  private_endpoint_ip        = var.storage_account.private_endpoint_ip
}

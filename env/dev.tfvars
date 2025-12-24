#################################################################
# 基本設定
#################################################################
subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
workload        = "terraform-playground"
environment     = "test"
location        = "Japan West"
location_short  = "jpw"
tags = {
  Project = "terraform-playground"
}


#################################################################
# ネットワーク (VNet / ピアリング / 経路)
#################################################################
vnet_scope                            = "spoke"
vnet_instance                         = "001"
vnet_integration_subnet_address_space = ["10.26.2.64/27"]
vnet_integration_route_prefix         = "0.0.0.0/0"
vnet_integration_route_next_hop_type  = "VirtualAppliance"
vnet_integration_route_next_hop_ip    = "10.255.0.4"
vnet_peerings = [
  {
    name                = "vnet-jpe-acr-001"
    resource_group_name = "acr-rg"
  },
  {
    name                = "vnet-jpw-fw-001"
    resource_group_name = "fw-rg"
  }
]
vnet_peering_allow_virtual_network_access = true
vnet_peering_allow_forwarded_traffic      = false
vnet_peering_allow_gateway_transit        = false
vnet_peering_use_remote_gateways          = false


################################################################################
# App Service ごとの設定
################################################################################
app_services = {
  front = {
    instance   = "001"
    private_ip = "10.26.2.36"
  }
  back = {
    instance   = "002"
    private_ip = "10.26.2.37"
  }
  agent = {
    instance   = "003"
    private_ip = "10.26.2.38"
  }
}


################################################################################
# アクセス制限（必要に応じて許可リストを設定）
################################################################################
access_restriction_allow_100 = []
access_restriction_allow_200 = []
access_restriction_allow_300 = []


################################################################################
# PostgreSQL Flexible Server
################################################################################
postgresql = {
  instance               = "001"
  server_version         = "14"
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
  backup_retention_days  = 30
  administrator_login    = "root_user"
  administrator_password = "root_password"
  private_endpoint_ip    = "10.26.2.39"
  private_dns_zone_name  = "privatelink.postgres.database.azure.com"
}


################################################################################
# Azure AI Search
################################################################################
search_service = {
  instance              = "001"
  sku                   = "basic"
  replica_count         = 1
  partition_count       = 1
  private_endpoint_ip   = "10.26.2.40"
  private_dns_zone_name = "privatelink.search.windows.net"
}


################################################################################
# Storage Account
################################################################################
storage_account = {
  instance                 = "001"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  private_endpoint_ip      = "10.26.2.41"
  private_dns_zone_name    = "privatelink.blob.core.windows.net"
}


################################################################################
# ACR 参照先
################################################################################
acr_resource_group_name = "acr-rg"
acr_name                = "terraformacr"

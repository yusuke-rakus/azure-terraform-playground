subscription_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
workload        = "terraform-playground"
environment     = "test"
location        = "Japan West"
location_short  = "jpw"

vnet_scope    = "spoke"
vnet_instance = "001"

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

tags = {
  Project = "terraform-playground"
}

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

search_service = {
  instance              = "001"
  sku                   = "basic"
  replica_count         = 1
  partition_count       = 1
  private_endpoint_ip   = "10.26.2.40"
  private_dns_zone_name = "privatelink.search.windows.net"
}

storage_account = {
  instance                 = "001"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  private_endpoint_ip      = "10.26.2.41"
  private_dns_zone_name    = "privatelink.blob.core.windows.net"
}

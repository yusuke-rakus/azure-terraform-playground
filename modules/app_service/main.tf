locals {
  service_plan_name = "aps-${var.workload}-${var.environment}-${var.region}-${var.app_service_plan_instance}"
}

resource "azurerm_service_plan" "this" {
  name                = local.service_plan_name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = "Linux"
  sku_name            = var.app_service_plan_sku_name
  tags                = var.tags
}

resource "azurerm_linux_web_app" "this" {
  for_each            = var.apps
  name                = "app-${var.workload}-${var.environment}-${each.value.instance}"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_service_plan.this.id
  https_only          = true
  tags                = var.tags

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTIN_STRING" = var.app_insights_connection_strings[each.key]
  }

  site_config {
    dynamic "ip_restriction" {
      for_each = var.access_restriction_allow_100
      content {
        name       = "allow-100-${ip_restriction.value}"
        action     = "Allow"
        priority   = 100
        ip_address = ip_restriction.value
      }
    }

    dynamic "ip_restriction" {
      for_each = var.access_restriction_allow_200
      content {
        name       = "allow-200-${ip_restriction.value}"
        action     = "Allow"
        priority   = 200
        ip_address = ip_restriction.value
      }
    }

    dynamic "ip_restriction" {
      for_each = var.access_restriction_allow_300
      content {
        name       = "allow-300-${ip_restriction.value}"
        action     = "Allow"
        priority   = 300
        ip_address = ip_restriction.value
      }
    }

    scm_ip_restriction {
      name       = "deny-all"
      action     = "Deny"
      priority   = 400
      ip_address = "0.0.0.0/0"
    }

    dynamic "scm_ip_restriction" {
      for_each = var.access_restriction_allow_100
      content {
        name       = "scm-allow-100-${ip_restriction.value}"
        action     = "Allow"
        priority   = 100
        ip_address = ip_restriction.value
      }
    }

    dynamic "scm_ip_restriction" {
      for_each = var.access_restriction_allow_200
      content {
        name       = "scm-allow-200-${ip_restriction.value}"
        action     = "Allow"
        priority   = 200
        ip_address = ip_restriction.value
      }
    }
    dynamic "scm_ip_restriction" {
      for_each = var.access_restriction_allow_300
      content {
        name       = "scm-allow-300-${ip_restriction.value}"
        action     = "Allow"
        priority   = 300
        ip_address = ip_restriction.value
      }
    }

    scm_ip_restriction {
      name       = "scm-deny-all"
      action     = "Deny"
      priority   = 400
      ip_address = "0.0.0.0/0"
    }
  }
}

resource "azurerm_private_endpoint" "this" {
  for_each            = var.apps
  name                = "pep-${var.workload}-${var.environment}-${each.key}-${each.value.instance}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "psc-${var.workload}-${var.environment}-${each.key}-${each.value.instance}"
    private_connection_resource_id = azurerm_linux_web_app.this[each.key].id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }

  ip_configuration {
    name               = "ipconfig-${each.key}"
    private_ip_address = each.value.private_ip
    subresource_name   = "sites"
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_id]
  }
}

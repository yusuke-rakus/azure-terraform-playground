locals {
  resouce_group_name          = "rg-${var.workload}-${var.environment}-${var.location_short}"
  user_assigned_identity_name = "id-${var.workload}-${var.environment}-${var.location_short}-acr-pull"
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

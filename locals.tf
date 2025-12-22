locals {
  resouce_group_name = "rg-${var.workload}-${var.environment}-${var.location_short}"
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

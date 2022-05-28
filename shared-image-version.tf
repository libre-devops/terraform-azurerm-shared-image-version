resource "azurerm_shared_image_version" "shared_image_version" {
  for_each            = var.images
  name                = try(each.value.image_version_number, null, formatdate("YYYY.MM.DD", timestamp()))
  gallery_name        = try(each.value.gallery_name)
  image_name          = try(each.value.image_name)
  resource_group_name = var.rg_name
  location            = var.location
  managed_image_id    = try(each.value.managed_image_id, null)
  exclude_from_latest = try(each.value.exclude_from_latest, true)
  tags                = var.tags

  dynamic "target_region" {
    for_each = lookup(var.images[each.key], "image_version_target_region", {}) != {} ? [1] : []
    content {
      name                   = lookup(var.images[each.key].image_version_target_region, "image_replication_zone_location_name", var.location)
      regional_replica_count = lookup(var.images[each.key].image_version_target_region, "regional_replica_count", "2")
      storage_account_type   = lookup(var.images[each.key].image_version_target_region, "storage_account_type", "Standard_LRS")
    }
  }
}
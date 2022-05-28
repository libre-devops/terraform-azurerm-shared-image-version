output "shared_image_gallery_name" {
  value = {
    for key, value in element(azurerm_shared_image_version.shared_image_version[*], 0) : key => value.gallery_name
  }
  description = "The name of the shared image gallery"
}

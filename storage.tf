resource "digitalocean_spaces_bucket" "cs_image_storage" {
  name   = "cs-image-storage-3"
  region = "${var.region}"
}

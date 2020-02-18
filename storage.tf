resource "digitalocean_spaces_bucket" "cs_image_storage" {
  name   = "cs-image-storage-2"
  region = "${var.region}"
}

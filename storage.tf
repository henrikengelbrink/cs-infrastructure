resource "digitalocean_spaces_bucket" "cs_image_storage" {
  name   = "cs-image-storage"
  region = "${var.region}"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

module "applications" {
  source = "./applications"
}
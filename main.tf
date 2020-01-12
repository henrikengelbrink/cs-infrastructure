provider "digitalocean" {
  token = "${var.do_token}"
}

module "services" {
  source = "./services"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

module "applications" {
  source = "./applications"
#   postgres_user_password = "${digitalocean_database_cluster.ggg_postgres.password}"
}
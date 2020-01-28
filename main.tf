# terraform {
#   backend "remote" {
#     hostname = "app.terraform.io"
#     organization = "hengel2810"

#     workspaces {
#       name = "clothing-scanner"
#     }
#   }
# }

provider "digitalocean" {
  token = "${var.do_token}"
  spaces_access_id  = "${var.do_spaces_key}"
  spaces_secret_key = "${var.do_spaces_secret}"
}

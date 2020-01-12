data "kubernetes_service" "k8s_ingress" {
  metadata {
    name = "voyager-test-ingress"
    namespace = "default"
  }
    depends_on = [
      "null_resource.load_balancer_delay",
      "helm_release.voyager_ingress_controller",
      "null_resource.ingress"
    ]
}

# resource "digitalocean_domain" "cluster_domain" {
#     name = "${var.cluster_domain}"
#     ip_address = "${data.kubernetes_service.nginx_ingress_controller_k8s_lb.load_balancer_ingress.0.ip}"

#     depends_on = [
#       "helm_release.nginx_ingress_controller"
#     ]
# }

data "digitalocean_domain" "dns_engelbrink_dev" {
  name = "engelbrink.dev"
}

resource "digitalocean_record" "cluster_domain_sub_example" {
  domain = "${data.digitalocean_domain.dns_engelbrink_dev.name}"
  type   = "A"
  name   = "example"
  value  = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"
}

resource "digitalocean_record" "cluster_domain_sub_mqtt" {
  domain = "${data.digitalocean_domain.dns_engelbrink_dev.name}"
  type   = "A"
  name   = "mqtt"
  value  = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"
}
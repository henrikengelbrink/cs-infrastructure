data "kubernetes_service" "k8s_ingress" {
  metadata {
    name      = "voyager-main-ingress"
    namespace = "voyager"
  }
  depends_on = [
    "null_resource.load_balancer_delay",
    "helm_release.voyager_ingress_controller",
    "null_resource.ingress"
  ]
}

resource "digitalocean_domain" "dns_cluster_domain" {
  name       = "${var.cluster_domain}"
  ip_address = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"

  depends_on = [
    "null_resource.load_balancer_delay",
    "helm_release.voyager_ingress_controller",
    "null_resource.ingress"
  ]
}

# data "digitalocean_domain" "dns_cluster_domain" {
#   name = "${var.cluster_domain}"
# }

resource "digitalocean_record" "cluster_domain_sub_example" {
  domain = "${digitalocean_domain.dns_cluster_domain.name}"
  type   = "A"
  name   = "example"
  value  = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"
  depends_on = [
    "digitalocean_domain.dns_cluster_domain"
  ]
}

resource "digitalocean_record" "cluster_domain_sub_mqtt" {
  domain = "${digitalocean_domain.dns_cluster_domain.name}"
  type   = "A"
  name   = "mqtt"
  value  = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"
  depends_on = [
    "digitalocean_domain.dns_cluster_domain"
  ]
}

resource "digitalocean_record" "cluster_domain_sub_mqtt_api" {
  domain = "${digitalocean_domain.dns_cluster_domain.name}"
  type   = "A"
  name   = "vernemq"
  value  = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"
  depends_on = [
    "digitalocean_domain.dns_cluster_domain"
  ]
}

resource "digitalocean_record" "cluster_domain_sub_app_service" {
  domain = "${digitalocean_domain.dns_cluster_domain.name}"
  type   = "A"
  name   = "app-service"
  value  = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"
  depends_on = [
    "digitalocean_domain.dns_cluster_domain"
  ]
}

resource "digitalocean_record" "cluster_domain_sub_image_proxy" {
  domain = "${digitalocean_domain.dns_cluster_domain.name}"
  type   = "A"
  name   = "image-proxy"
  value  = "${data.kubernetes_service.k8s_ingress.load_balancer_ingress.0.ip}"
  depends_on = [
    "digitalocean_domain.dns_cluster_domain"
  ]
}

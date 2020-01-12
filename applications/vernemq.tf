resource "kubernetes_service" "mqtt_broker_service_http_debug" {
  metadata {
    name      = "vernemq-dashboard"
    namespace = "default"
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "vernemq-cluster"
      "app.kubernetes.io/name" = "vernemq"
    }
    port {
      port = 8888
      target_port = 8888
    }
  }
}
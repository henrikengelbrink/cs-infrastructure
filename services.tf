resource "kubernetes_service" "terraform-example-app-service" {
  metadata {
    name      = "terraform-example-app"
    namespace = "http"
  }
  spec {
    selector = {
      app = "terraform-example-app"
    }
    port {
      port        = 80
      target_port = 80
    }
  }
  depends_on = [
    "kubernetes_namespace.k8s_namespace_http"
  ]
}
resource "kubernetes_deployment" "terraform-example-app-deployment" {
  metadata {
    name      = "terraform-example-app"
    namespace = "http"
    labels = {
      app = "terraform-example-app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "terraform-example-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "terraform-example-app"
        }
      }
      spec {
        container {
          image = "tutum/hello-world:latest"
          name  = "terraform-example-app"
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }
  depends_on = [
    "kubernetes_namespace.k8s_namespace_http"
  ]
}


resource "kubernetes_service" "cs_app_service_service" {
  metadata {
    name      = "app-service"
    namespace = "http"
  }
  spec {
    selector = {
      app = "app-service"
    }
    port {
      port        = 9080
      target_port = 8080
    }
  }
  depends_on = [
    "kubernetes_namespace.k8s_namespace_http"
  ]
}
resource "kubernetes_deployment" "cs_app_service_deployment" {
  metadata {
    name      = "app-service"
    namespace = "http"
    labels = {
      app = "app-service"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "app-service"
      }
    }
    template {
      metadata {
        labels = {
          app = "app-service"
        }
      }
      spec {
        container {
          image = "hengel2810/cs-app-service:latest"
          name  = "app-service"
          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
          env {
            name  = "POSTGRES_HOST"
            value = "${digitalocean_database_cluster.cs_postgres_cluster.host}"
          }
          env {
            name  = "POSTGRES_PORT"
            value = "${digitalocean_database_cluster.cs_postgres_cluster.port}"
          }
          env {
            name  = "POSTGRES_USER"
            value = "${digitalocean_database_cluster.cs_postgres_cluster.user}"
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = "${digitalocean_database_cluster.cs_postgres_cluster.password}"
          }
          env {
            name  = "POSTGRES_DATABASE"
            value = "${digitalocean_database_cluster.cs_postgres_cluster.database}"
          }
        }
      }
    }
  }
  depends_on = [
    "kubernetes_namespace.k8s_namespace_http"
  ]
}


resource "kubernetes_service" "cs_image_proxy_service" {
  metadata {
    name      = "image-proxy"
    namespace = "http"
  }
  spec {
    selector = {
      app = "image-proxy"
    }
    port {
      port        = 8080
      target_port = 8080
    }
  }
  depends_on = [
    "kubernetes_namespace.k8s_namespace_http"
  ]
}
resource "kubernetes_deployment" "cs_image_proxy_deployment" {
  metadata {
    name      = "image-proxy"
    namespace = "http"
    labels = {
      app = "image-proxy"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "image-proxy"
      }
    }
    template {
      metadata {
        labels = {
          app = "image-proxy"
        }
      }
      spec {
        container {
          image = "hengel2810/cs-image-proxy:latest"
          name  = "image-proxy"
          liveness_probe {
            http_get {
              path = "/health"
              port = 8080
            }
            initial_delay_seconds = 3
            period_seconds        = 3
          }
          env {
            name  = "DO_SPACES_KEY"
            value = "${var.do_spaces_key}"
          }
          env {
            name  = "DO_SPACES_SECRET"
            value = "${var.do_spaces_secret}"
          }
        }
      }
    }
  }
  depends_on = [
    "kubernetes_namespace.k8s_namespace_http"
  ]
}

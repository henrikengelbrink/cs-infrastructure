resource "kubernetes_service_account" "tiller" {
  metadata {
    name = "tiller"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "cluster-admin"
  }
  subject {
    kind = "ServiceAccount"
    name = "tiller"
    namespace = "kube-system"
  }
}

provider "helm" {
  install_tiller = true
  service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
  kubernetes {
    config_path = "./kubeconfig.yaml"
  }
}

resource "helm_release" "voyager_ingress_controller" {
    name = "voyager-ingress-controller"
    chart = "stable/voyager"
    namespace = "http"
    set {
      name  = "ingressClass"
      value = "voyager-ingress"
    }
    set {
      name  = "cloudProvider"
      value = "digitalocean"
    }
    depends_on = [
      "kubernetes_cluster_role_binding.tiller",
      "kubernetes_service_account.tiller",
      "null_resource.voyager_secret"
    ]
}

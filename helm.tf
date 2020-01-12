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

data "helm_repository" "appscode_helm_repo" {
  name = "appscode"
  url  = "https://charts.appscode.com/stable/"
}

resource "helm_release" "voyager_ingress_controller" {
    repository = "${data.helm_repository.appscode_helm_repo.metadata.0.name}"
    name = "ingress-controller"
    chart = "appscode/voyager"
    version = "v12.0.0-rc.1"
    namespace = "default"
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
    ]
}

data "helm_repository" "helm_repo_vernemq" {
    name = "vernemq"
    url  = "https://vernemq.github.io/docker-vernemq"
}

resource "helm_release" "vernemq_cluster" {
    name = "vernemq-cluster"
    chart = "vernemq/vernemq"
    namespace = "default"
    set {
      name  = "replicaCount"
      value = 2
    }
    values = [
      "${file("values.yml")}"
    ]
    depends_on = [
      "kubernetes_cluster_role_binding.tiller",
      "kubernetes_service_account.tiller"
    ]
}
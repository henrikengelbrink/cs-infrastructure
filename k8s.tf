resource "digitalocean_kubernetes_cluster" "k8s_prod" {
  name = "k8s-prod"
  region = "${var.region}"
  version = "1.15.5-do.2"

  node_pool {
    name = "worker-pool"
    size = "s-1vcpu-2gb"
    node_count = 2
  }
}

resource "local_file" "kubeconfig" {
    content = "${digitalocean_kubernetes_cluster.k8s_prod.kube_config.0.raw_config}"
    filename = "kubeconfig.yaml"
}

provider "kubernetes" {
    host  = "${digitalocean_kubernetes_cluster.k8s_prod.endpoint}"
    token = "${digitalocean_kubernetes_cluster.k8s_prod.kube_config.0.token}"
    cluster_ca_certificate = "${base64decode(digitalocean_kubernetes_cluster.k8s_prod.kube_config.0.cluster_ca_certificate)}"
}

resource "kubernetes_namespace" "k8s_namespace_http" {
  metadata {
    name = "http"
  }
}

resource "null_resource" "voyager_secret" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ./kubeconfig.yaml create secret generic acme-account --namespace=http --from-literal=ACME_EMAIL=hengel2810@gmail.com"
  }
  depends_on = [
      "local_file.kubeconfig"
  ]
}

resource "null_resource" "voyager_cert" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ./kubeconfig.yaml apply -f ./k8s_crd/voyager-cert.yml"
  }
  depends_on = [
      "null_resource.voyager_secret",
      "helm_release.voyager_ingress_controller"
  ]
}

resource "null_resource" "ingress" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ./kubeconfig.yaml apply -f ./k8s_crd/voyager-ingress.yml"
  }
  depends_on = [
    "null_resource.voyager_cert"
  ]
}
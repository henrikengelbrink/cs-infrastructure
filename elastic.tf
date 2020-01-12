# data "helm_repository" "helm_repo_elastic" {
#     name = "elastic"
#     url  = "https://helm.elastic.co"
# }

# resource "helm_release" "elasticsearch_cluster" {
#     name = "elasticsearch"
#     repository = "${data.helm_repository.helm_repo_elastic.metadata.0.name}"
#     chart = "elastic/elasticsearch"
#     namespace = "elastic"
#     timeout = 600
#     set {
#       name  = "replicas"
#       value = 2
#     }
#     depends_on = [
#       "kubernetes_cluster_role_binding.tiller",
#       "kubernetes_service_account.tiller",
#       "kubernetes_namespace.k8s_namespace_elastic"
#     ]
# }

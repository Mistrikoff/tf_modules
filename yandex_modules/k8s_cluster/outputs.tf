output "int_endpoint" {
  value       = yandex_kubernetes_cluster.k8s_cluster.master[0].internal_v4_endpoint
  description = "Internal endpoint that can be used to connect to the master from cloud networks."
}

output "sa_k8s" {
  value = yandex_iam_service_account.k8s_service_account.name
}
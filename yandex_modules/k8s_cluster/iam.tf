resource "yandex_iam_service_account" "k8s_service_account" {
  name      = "service-account-${var.KUBE_NAME}"
  folder_id = var.FOLDER_ID
}

resource "yandex_iam_service_account" "k8s_node_account" {
  name      = "node-account-${var.KUBE_NAME}"
  folder_id = var.FOLDER_ID
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_editor" {
  folder_id = var.FOLDER_ID

  role = "editor" #editor of the current folder

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_service_account.id}",
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_pusher" {
  folder_id = var.FOLDER_ID

  role = "container-registry.images.pusher" #access to container registry
  #role for push node logs and metrics might be added

  members = [
    "serviceAccount:${yandex_iam_service_account.k8s_node_account.id}",
  ]
}

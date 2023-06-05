resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name               = var.KUBE_NAME
  description        = format("%s cluster", var.KUBE_NAME)
  network_id         = var.VPC_ID
  cluster_ipv4_range = var.POD_SN
  node_ipv4_cidr_mask_size = 28
  service_ipv4_range = var.SVC_SN
  folder_id          = var.FOLDER_ID
  

  master {
    version = "1.22"
    public_ip = false
    security_group_ids = []
    maintenance_policy {
      auto_upgrade = false

      maintenance_window {
        start_time = "00:00"
        duration   = "2h"
      }
    }
    zonal {
      zone      = var.ZONE
      subnet_id = var.CLUSTER_SN
    }
  }

  service_account_id      = yandex_iam_service_account.k8s_service_account.id
  node_service_account_id = yandex_iam_service_account.k8s_node_account.id

  depends_on = [ #dependency for correct deletion cluster
    yandex_iam_service_account.k8s_node_account,
    yandex_iam_service_account.k8s_service_account,
    yandex_resourcemanager_folder_iam_binding.k8s_editor,
    yandex_resourcemanager_folder_iam_binding.k8s_pusher
  ]

  release_channel         = "REGULAR"
  network_policy_provider = "CALICO"
}


resource "yandex_kubernetes_node_group" "k8s_master_node_group" {
  cluster_id  = yandex_kubernetes_cluster.k8s_cluster.id
  name        = format("%s-master-node-group", var.KUBE_NAME)
  description = "nodes for ${var.KUBE_NAME} cluster"
  version     = "1.22"

  node_labels = {
    type = "master"
  }

  instance_template {
    platform_id = "standard-v2"

    resources {
      core_fraction = 5
      memory        = 2
      cores         = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    network_interface {
      nat        = false
      subnet_ids = [ var.NODE_SN ]
    }

    scheduling_policy {
      preemptible = true
    }

    container_runtime {
      type = "containerd"
    }
    metadata = {
      ssh-keys = var.PUBLIC_KEY
    }
    name = format("%s-master-node-group-{instance.index}", var.KUBE_NAME)
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }

  allocation_policy {
    location {
      zone = var.ZONE
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true

    maintenance_window {
      start_time = "02:00"
      duration   = "2h"
    }
  }
}

#resource "yandex_kubernetes_node_group" "k8s_worker_node_group" {
#  cluster_id  = yandex_kubernetes_cluster.k8s_cluster.id
#  name        = format("%s-worker-node-group", var.KUBE_NAME)
#  description = "nodes for ${var.KUBE_NAME} cluster"
#  version     = "1.22"
#  node_taints = [
#    "type=worker:NoSchedule"
#  ]
#  node_labels = {
#    type = "worker"
#  }
#  instance_template {
#    platform_id = "standard-v3"
#
#    network_interface {
#      nat        = false
#      subnet_ids = [ var.NODE_SN ]
#    }
#
#    resources {
#      memory = 8
#      cores  = 4
#    }
#
#    boot_disk {
#      type = "network-ssd"
#      size = 64
#    }
#
#    scheduling_policy {
#      preemptible = true
#    }
#
#    container_runtime {
#      type = "docker"
#    }
#    metadata = {
#      ssh-keys = var.PUBLIC_KEY
#    }
#    name = format("%s-worker-node-group-{instance.index}", var.KUBE_NAME)
#  }
#
#  scale_policy {
#    auto_scale {
#      min     = 0
#      max     = 6
#      initial = 0
#    }
#  }
#
#  allocation_policy {
#    location {
#      zone = var.ZONE
#    }
#  }
#
#  maintenance_policy {
#    auto_upgrade = false
#    auto_repair  = true
#
#    maintenance_window {
#      start_time = "02:00"
#      duration   = "2h"
#    }
#  }
#}

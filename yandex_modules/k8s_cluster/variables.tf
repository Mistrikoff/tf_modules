variable "KUBE_NAME" {
  type = string
}

variable "ZONE" {
  type = string
}

variable "FOLDER_ID" {
  type = string
}

variable "NODE_SN" {
  type = string
}

variable "POD_SN" {
  type = string
}

variable "SVC_SN" {
  type = string
}

variable "PUBLIC_KEY" {
  type      = string
  sensitive = true
}

variable "VPC_ID" {
  type = string
}

variable "CLUSTER_SN" {
  type = string
}
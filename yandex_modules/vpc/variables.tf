variable "VPC_NAME" {
  type = string
}

variable "FOLDER_ID" {
  type = string
}

variable "ZONE" {
  type    = string
  default = "ru-central1-a"
}

variable "ZONE_DEFAULT" {
  type    = string
  default = "ru-central1-a"
}

variable "SUBNETS" {
  type = list(object({
    name    = string
    address = string
    zone    = string
  }))
}
resource "yandex_vpc_network" "vpc-network" {
  name      = var.VPC_NAME
  folder_id = var.FOLDER_ID
}

resource "yandex_vpc_gateway" "vpc-gateway" {
  name      = format("%s-gateway", yandex_vpc_network.vpc-network.name)
  folder_id = var.FOLDER_ID
}

resource "yandex_vpc_subnet" "vpc-subnet" {
  for_each = { for index, value in var.SUBNETS : value.name => value }

  folder_id      = var.FOLDER_ID
  name           = each.value.name
  v4_cidr_blocks = [each.value.address]
  zone           = each.value.zone
  network_id     = yandex_vpc_network.vpc-network.id
}

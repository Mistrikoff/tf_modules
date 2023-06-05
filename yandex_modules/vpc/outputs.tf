#output "test" {
#  value = { for index, value in var.SUBNETS: value.name => value}
#}

#output "test2" {
#  value = yandex_vpc_subnet.vpc-subnet
#}

output "vpc_id" {
  value =   yandex_vpc_network.vpc-network.id
}

output "subnet_ids" {
  value =   {for index, value in yandex_vpc_subnet.vpc-subnet: value.name => value.id }
}

output "subnet_ips" {
  value =   {for index, value in yandex_vpc_subnet.vpc-subnet: value.name => value.v4_cidr_blocks[0] }
}

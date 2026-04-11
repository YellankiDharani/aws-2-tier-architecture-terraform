output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.Internet_gateway.id
}

output "route_table_id" {
  value = aws_route_table.Public_subnets_route_table.id
}

output "eip_id" {
  value = aws_eip.Elastic_IP.id
}
output "public_route_table_ids" {
  value = [aws_route_table.route_table_public.id]
}

output "intra_route_table_ids" {
  value = [aws_route_table.route_table_private_A.id, aws_route_table.route_table_private_B.id, aws_route_table.route_table_private_C.id]
}

output "security_group_ids" {
  value = aws_security_group.BlackStoneSG.id
}

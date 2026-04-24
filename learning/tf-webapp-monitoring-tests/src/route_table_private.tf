resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = { Name = "${local.name_prefix}-rt-private" }
}

resource "aws_route_table_association" "private_rta" {
  for_each = aws_subnet.private_sub

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}

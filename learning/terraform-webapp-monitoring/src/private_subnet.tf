resource "aws_subnet" "private_sub" {
  for_each = {
    for idx, az in local.azs :
    az => {
      cidr = var.private_subnet_cidrs[idx]
    }
  }

  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.key

  tags = {
    Name = "${local.name_prefix}-private-${each.key}"
  }
}

resource "aws_subnet" "public_sub" {
  for_each = {
    for idx, az in local.azs :
    az => {
      cidr = var.public_subnet_cidrs[idx]
    }
  }

  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "${local.name_prefix}-public-${each.key}"
  }
}

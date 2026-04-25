# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}


# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${local.name_prefix}-igw"
  }
}


# -----------------------------
# Public subnet
# -----------------------------
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


# -----------------------------
# Private subnet
# -----------------------------
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


# -----------------------------
# Route Table (Public subnet)
# -----------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${local.name_prefix}-rt-public"
  }
}

resource "aws_route_table_association" "public_rta" {
  for_each = aws_subnet.public_sub

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}


# -----------------------------
# Route Table (Private subnet)
# -----------------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = { Name = "${local.name_prefix}-rt-private" }
}

resource "aws_route_table_association" "private_rta" {
  for_each = aws_subnet.private_sub

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
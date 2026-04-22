# 変数定義
variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "my_env" {}


#AZ名の取得
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}


# VPC作成
resource "aws_vpc" "main-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "terraform-${var.my_env}"
  }
}


# IGW作成
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "main-igw"
  }
}

# Public Route Table作成
resource "aws_route_table" "prt" {
  vpc_id = aws_vpc.main-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main-igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Public Subnet作成（各AZに一つずつ）
resource "aws_subnet" "pub-subnet" {
  for_each = {
    for idx, az in local.azs :
    az => {
      cidr = var.public_subnet_cidrs[idx]
    }
  }

  vpc_id                  = aws_vpc.main-vpc.id
  cidr_block              = each.value.cidr
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "aws-study-public-${each.key}"
  }
}


resource "aws_subnet" "pri-subnet" {
  for_each = {
    for idx, az in local.azs :
    az => {
      cidr = var.private_subnet_cidrs[idx]
    }
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr
  availability_zone = each.key

  tags = {
    Name = "aws-study-private-${each.key}"
  }
}






# ターミナルへの出力
output "vpc_id" {
  value = aws_vpc.aws-study4_vpc.id
}

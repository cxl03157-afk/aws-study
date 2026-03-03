
# テスト内容
run "aws_code_test" {
  command = plan

#  定義
#variables {
#  vpc_cidr = "10.0.0.0/16"
#  public_subnet1_cidr = "10.0.1.0/24"
#}

#  変数定義

  variables {
    db_username = "root"
    db_password = "rootroot"
  }

# VPC Cidr確認
  assert {
    condition     = output.vpc_cidr == "10.0.0.0/16" 
    error_message = "VPC Cider mismatch"
  }

# Public subnet Cidr確認
assert {
  condition = toset(values(output.public_subnets)) == toset(["10.0.1.0/24", "10.0.2.0/24"])
  error_message = "Public subnet CIDR mismatch"
}

# Private subnet Cidr確認
assert {
  condition = toset(values(output.private_subnets)) == toset(["10.0.3.0/24", "10.0.4.0/24"])
  error_message = "Private subnet CIDR mismatch"
}

# ALB port確認
assert {
  condition = toset(output.alb_ports) == toset([80,443])
  error_message = "ALB ports incorrect"
}

# EC2 port確認
assert {
  condition     = toset(output.ec2_ports) == toset([22, 80, 8080])
  error_message = "EC2 SG ports mismatch"
}

# RDS port確認
assert {
  condition     = toset(output.rds_ports) == toset([3306])
  error_message = "RDS SG ports mismatch"
}

# EC2のInstance typeの確認
  assert {
  condition     = output.ec2_type == "t3.micro"
  error_message = "EC2 instance type mismatch"
}

# RDSのInstance typeの確認
assert {
  condition = aws_db_instance.mysql.instance_class == "db.t3.micro"
  error_message = "RDS instance type mismatch"

}

}



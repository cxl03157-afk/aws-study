output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "ec2_public_ip" {
  value = aws_instance.ec2[*].public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}

output "vpc_cidr" {
  value = aws_vpc.main_vpc.cidr_block
}

output "public_subnets" {
  value = {
    for az, subnet in aws_subnet.public_sub :
    az => subnet.cidr_block
  }
}

output "private_subnets" {
  value = {
    for az, subnet in aws_subnet.private_sub :
    az => subnet.cidr_block
  }
}

output "alb_ports" {
  value = [for rule in aws_security_group.alb_sg.ingress : rule.from_port]
}

output "ec2_ports" {
  value = [for rule in aws_security_group.ec2_sg.ingress : rule.from_port]
}

output "rds_ports" {
  value = [for rule in aws_security_group.rds_sg.ingress : rule.from_port]
}

output "ec2_type" {
  value = aws_instance.ec2[*].instance_type
}

output "rds_type" {
  value = aws_db_instance.mysql.instance_class
}

output "ec2_instance_id" {
  value = aws_instance.ec2[0].id
}

output "ssm_bucket_name" {
  value = var.ssm_bucket_name
}
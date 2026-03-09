resource "aws_db_subnet_group" "rds_sub" {
  name       = "${local.name_prefix}-rds-subnet-group"
  subnet_ids = [for s in aws_subnet.private_sub : s.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rds-subnet-group"
  })
}

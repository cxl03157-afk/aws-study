
# -----------------------------
# RDB (MySQL)
# -----------------------------
resource "aws_db_instance" "mysql" {
  identifier                 = "${local.name_prefix}-mysql"
  engine                     = "mysql"
  engine_version             = "8.0"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20
  storage_type               = "gp3"
  username                   = var.db_username
  password                   = var.db_password
  db_subnet_group_name       = aws_db_subnet_group.rds_sub.name
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  skip_final_snapshot        = true
  publicly_accessible        = false
  multi_az                   = false
  auto_minor_version_upgrade = true
  db_name                    = "awsstudy"

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-mysql"
  })
}


# -----------------------------
# DB Subnet Group
# -----------------------------
resource "aws_db_subnet_group" "rds_sub" {
  name       = "${local.name_prefix}-rds-subnet-group"
  subnet_ids = [for s in aws_subnet.private_sub : s.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-rds-subnet-group"
  })
}


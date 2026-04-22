resource "aws_lb" "alb" {
  name               = "${local.name_prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_subnet.public_sub : s.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb"
  })
}

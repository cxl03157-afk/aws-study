# -----------------------------
# ALB
# -----------------------------
resource "aws_lb" "alb" {
  name               = "${local.name_prefix}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for s in aws_subnet.public_sub : s.id]

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-alb"
  })
}


# -----------------------------
# ALB Target Group
# -----------------------------
resource "aws_lb_target_group" "alb_tg" {
  name     = "${local.name_prefix}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-tg"
  })
}

resource "aws_lb_target_group_attachment" "alb_tga_1" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.ec2.id
  port             = 8080
}

#resource "aws_lb_target_group_attachment" "alb_tga_2" {
#  target_group_arn = aws_lb_target_group.alb_tg.arn
#  target_id        = aws_instance.ec2_2.id
#  port             = 8080
#}


# -----------------------------
# ALB listener
# -----------------------------
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}



resource "aws_lb" "alb" {
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]

  dynamic "subnet_mapping" {
    for_each = aws_subnet.public
    content {
      subnet_id = subnet_mapping.value.id
    }
  }
}

resource "aws_lb_listener" "http_to_application" {
  load_balancer_arn = aws_lb.alb.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application_http.arn
  }
}

resource "aws_lb_target_group" "application_http" {
  vpc_id = aws_vpc.vpc.id

  port     = 80
  protocol = "HTTP"
}

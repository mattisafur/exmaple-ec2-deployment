resource "aws_lb" "load_balancer" {
  name = "${var.project_name}-${var.environment_name}-lb"

  load_balancer_type = "application"
  internal           = false # ? make into variable?
  security_groups    = var.security_group_ids

  dynamic "subnet_mapping" {
    for_each = var.subnet_ids
    content {
      subnet_id = subnet_mapping.value
    }
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.load_balancer.arn

  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name = "${var.project_name}-${var.environment_name}-lb-tg"

  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

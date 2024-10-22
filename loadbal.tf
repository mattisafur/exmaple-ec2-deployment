resource "aws_lb" "load_balancer" {
  name = "group-test-application-alb"

  load_balancer_type = "application"
  security_groups = [aws_security_group.load_balancer.id]
  
  dynamic "subnet_mapping" {
    for_each = data.aws_subnets.subnets.ids

    content {
      subnet_id = subnet_mapping.value
    }
  }
}

resource "aws_security_group" "load_balancer" {
  name = "group-test-alb-sg"
}

resource "aws_vpc_security_group_egress_rule" "load_balancer_allow_all" {
  security_group_id = aws_security_group.load_balancer.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "load_balancer_allow_http" {
  security_group_id = aws_security_group.load_balancer.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port   = 80
  to_port     = 80
}

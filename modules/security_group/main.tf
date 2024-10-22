resource "aws_security_group" "launch_template" {
  name = "${var.project_name}-${var.environment_name}-launch-sg"

  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "launch_allow_all" {
  security_group_id = aws_security_group.launch_template.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "from_lb" {
  security_group_id = aws_security_group.launch_template.id

  referenced_security_group_id = aws_security_group.lb.id
  ip_protocol                  = "TCP"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_security_group" "lb" {
  name = "${var.project_name}-${var.environment_name}-lb-sg"

  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "lb_allow_all" {
  security_group_id = aws_security_group.lb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "lb_allow_http" {
  security_group_id = aws_security_group.lb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port   = 80
  to_port     = 80
}

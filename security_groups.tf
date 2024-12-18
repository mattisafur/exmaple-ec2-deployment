resource "aws_security_group" "instances" {
  name = "${var.app_name}-${var.environment}-instances-sg"

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name}-${var.environment}-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "instances_allow_http_from_alb" {
  security_group_id = aws_security_group.instances.id

  referenced_security_group_id = aws_security_group.alb.id
  ip_protocol                  = "TCP"
  from_port                    = 80
  to_port                      = 80
}
resource "aws_vpc_security_group_egress_rule" "instances_allow_all_from_all" {
  security_group_id = aws_security_group.instances.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_security_group" "alb" {
  name = "${var.app_name}-${var.environment}-alb-sg"

  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.app_name}-${var.environment}-alb-sg"
  }
}
resource "aws_vpc_security_group_ingress_rule" "alb_allow_http_from_all" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "TCP"
  from_port   = 80
  to_port     = 80
}
resource "aws_vpc_security_group_egress_rule" "alb_allow_all_from_all" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

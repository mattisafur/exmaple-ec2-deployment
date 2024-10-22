resource "aws_autoscaling_group" "autoscaling_group" {
  name = "group-test-application-asg"

  min_size = var.min_instances
  max_size = var.max_instances

  vpc_zone_identifier = data.aws_subnets.subnets.ids

  launch_template {
    id = var.launch_template_id
  }
}

resource "aws_security_group" "instances" {
  name = "group-test-instances-sg"
}

resource "aws_vpc_security_group_egress_rule" "instances_allow_all" {
  security_group_id = aws_security_group.instances.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "instances_allow_http_to_load_balancer" {
  security_group_id = aws_security_group.instances.id

  referenced_security_group_id = aws_security_group.load_balancer.id
  ip_protocol                  = "TCP"
  from_port                    = 80
  to_port                      = 80
}

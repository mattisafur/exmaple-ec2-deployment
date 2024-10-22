output "launch_template_security_group_id" {
  value = aws_security_group.launch_template.id
}

output "lb_security_group_id" {
  value = aws_security_group.lb.id
}

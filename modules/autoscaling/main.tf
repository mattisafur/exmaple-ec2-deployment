resource "aws_autoscaling_group" "autoscaling_group" {
  name = "${var.project_name}-${var.environment_name}-asg"

  min_size = var.minimum_instances
  max_size = var.maximum_instances

  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id = var.launch_template_id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "autoscaling_attachment" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group.name
  lb_target_group_arn    = var.target_group_arn
}

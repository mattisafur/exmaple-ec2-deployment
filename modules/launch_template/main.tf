resource "aws_launch_template" "launch_template" {
  name = "${var.project_name}-${var.environment_name}-lt"

  instance_type = var.instance_type

  image_id               = var.ami_id
  vpc_security_group_ids = var.security_group_ids
  user_data              = base64encode(var.user_data)
}

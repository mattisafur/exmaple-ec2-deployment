resource "aws_launch_template" "application" {
  name = "${var.app_name}-${var.environment}-lt"

  image_id      = "ami-06b21ccaeff8cd686"
  user_data     = base64encode(var.user_data)
  instance_type = "t2.micro"

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.app_name}-${var.environment}-instance"
    }
  }

  tags = {
    Name = "${var.app_name}-${var.environment}-lt"
  }
}

resource "aws_autoscaling_group" "application" {
  name = "${var.app_name}-${var.environment}-asg"

  min_size = 1
  max_size = 1

  vpc_zone_identifier = aws_subnet.private[*].id

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "application_to_alb" {
  autoscaling_group_name = aws_autoscaling_group.application.name
  lb_target_group_arn    = aws_lb_target_group.application_http.arn
}

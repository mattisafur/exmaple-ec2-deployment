resource "aws_launch_template" "application" {
  image_id = "ami-06b21ccaeff8cd686"
  user_data = base64encode(var.user_data)
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.instances.id]
}

resource "aws_autoscaling_group" "application" {
  min_size = 1
  max_size = 1

  vpc_zone_identifier = [aws_subnet.private.id]

  launch_template {
    id      = aws_launch_template.application.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "application_to_alb" {
  autoscaling_group_name = aws_autoscaling_group.application.name
  lb_target_group_arn    = aws_lb_target_group.application_http.arn
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72.1"
    }
  }
}

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "group-test-application-asg"

  min_size = var.min_instances
  max_size = var.max_instances

  vpc_zone_identifier = data.aws_subnets.subnets.ids

  launch_template {
    id = var.launch_template_id
  }
}

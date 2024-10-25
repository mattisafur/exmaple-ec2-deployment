terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.72"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"

  project_name     = var.project_name
  environment_name = var.environment_name

  cidr_block = "10.10.0.0/16"
}

module "security_group" {
  source = "./modules/security_group"

  project_name     = var.project_name
  environment_name = var.environment_name

  vpc_id = module.vpc.vpc_id
}

module "launch_template" {
  source = "./modules/launch_template"

  project_name       = var.project_name
  environment_name   = var.environment_name
  security_group_ids = [module.security_group.launch_template_security_group_id]

  ami_id           = "ami-06b21ccaeff8cd686"
  instance_type    = "t2.micro"
  root_volume_size = 8
  user_data        = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y httpd
    systemctl enable --now httpd
    echo "page from $(hostname -f)" > /var/www/html/index.html
    EOF 
}

module "load_balance" {
  source = "./modules/load_balance"

  project_name     = var.project_name
  environment_name = var.environment_name

  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = [module.security_group.lb_security_group_id]
}

module "autoscaling" {
  source = "./modules/autoscaling"

  project_name     = var.project_name
  environment_name = var.environment_name

  launch_template_id = module.launch_template.launch_template_id
  target_group_arn   = module.load_balance.target_group_id
  subnet_ids         = module.vpc.subnet_ids

  minimum_instances = var.minimum_instances
  maximum_instances = var.maximum_instances
}

variable "app_name" {
  description = "The application's name"
  type        = string
}
variable "environment" {
  description = "The environment's name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC."
  type = string
}
variable "num_subnets" {
  description = "Number of public and private subnets to be created. Each set of subnets is created in a separate AZ. If there are less AZs than specified, there will be one set created in each AZ."
  type        = number
  validation {
    condition     = var.num_subnets >= 2
    error_message = "At least two subnet sets need to be created."
  }
  validation {
    condition     = var.num_subnets <= length(data.aws_availability_zones.available)
    error_message = "There are not enough availability zones available."
  }
}
variable "min_instances" {
  description = "The minimum number of instances to be provisioned."
  type        = number
  validation {
    condition     = var.min_instances >= 0
    error_message = "Value cannopt be negative."
  }
}
variable "max_instances" {
  description = "The maximum number of instances to be provisioned."
  type        = number
  validation {
    condition     = var.max_instances >= var.min_instances
    error_message = "Value cannot be lower than minimum number of instances."
  }
}
variable "user_data" {
  description = "User Data to execute on instances at creation."
  type        = string
  default     = ""
}

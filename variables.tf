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

variable "user_data" {
  description = "User Data to execute on instances at creation."
  type = string
  default = ""
}

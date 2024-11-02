variable "project_name" {
  type = string
}
variable "environment_name" {
  type = string
}

variable "launch_template_id" {
  type = string
}
variable "target_group_arn" {
  type = string
}
variable "subnet_ids" {
  type = set(string)
}

variable "minimum_instances" {
  type = number
}
variable "maximum_instances" {
  type = number
}

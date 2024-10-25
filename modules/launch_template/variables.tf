variable "project_name" {
  type = string
}
variable "environment_name" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "instance_type" {
  type = string
}
variable "ami_id" {
  type = string
}
variable "user_data" {
  type    = string
  default = ""
}
variable "root_volume_size" {
  type = number
}
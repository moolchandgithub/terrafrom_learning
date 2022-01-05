variable "aws_region" {
  description = "AWS region where you want to deploy resources"
  type        = string
}

variable "port" {
  description = "Allowed port list"
  type        = list
}

variable "environment" {
  description = "Environment Tag"
  type        = string
}

variable "servertype" {
  description = "Server Usages Tag"
  type        = string
}

variable "serversize" {
  description = "Server szie"
  type        = string
}
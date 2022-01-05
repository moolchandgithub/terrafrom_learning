variable "aws_region" {
  description = "AWS region where you want to deploy resources"
  type        = string
  default     = "eu-north-1"
}

variable "environment" {
  description = "Environment Tag"
  type        = string
  default = "PROD"
}

variable "servertype" {
  description = "Server Usages Tag"
  type        = string
  default  = "web"
}
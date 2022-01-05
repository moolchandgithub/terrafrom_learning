variable "aws_region" {
  description = "AWS Region where you want to deploy Services"
  type        = string
  default     = "eu-north-1"
}

locals {
  ### AWS Account ID
  aws_account = data.aws_caller_identity.current.account_id
}

variable "bucket_num" {
  description = "Please Enter nunber of buckets..."
  type        = number
}

locals {
  min_bucket_num    = 3
  number_of_buckets = var.bucket_num > 0 ? var.bucket_num : local.min_bucket_num
}


terraform {
  required_version = ">=1.1.0"
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "bucketC" {
  count  = local.number_of_buckets
  bucket = "${local.aws_account}-bucket${count.index + 1}"
}
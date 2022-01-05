terraform {
  required_version = ">= 1.1.0"
}

provider "aws" {
  region = "eu-north-1"
}

data "aws_caller_identity" "current" {}

locals {
  aws_account = data.aws_caller_identity.current.account_id
}

resource "aws_s3_bucket" "bucket2" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket2"
}

output "bucket2" {
  value = aws_s3_bucket.bucket2.bucket
}

resource "aws_s3_bucket" "bucketX" {
  count  = 2
  bucket = "${data.aws_caller_identity.current.account_id}-bucket${count.index + 3}"
}

output "bucketX" {
  value = ["${aws_s3_bucket.bucketX.*.bucket}"]
}

locals {
  buckets = {
    bucket101 = "bucket101"
    bucket102 = "bucket102"
  }
}

resource "aws_s3_bucket" "bucketE" {
  for_each = local.buckets
  bucket   = "${local.aws_account}-${each.value}"
}

output "bucketE" {
    value = toset([
        for bucketE in aws_s3_bucket.bucketE : bucketE.bucket
    ])
}

locals {
  bucketlist = [
      "bucket103",
      "bucket104"
  ]
}

resource "aws_s3_bucket" "bucketL" {
  for_each = toset(local.bucketlist)
  bucket = "${local.aws_account}-${each.key}"
}

output "bucketL" {
    value = toset([
        for bucketL in aws_s3_bucket.bucketL : bucketL.bucket
    ])
}

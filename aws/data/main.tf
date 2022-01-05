provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ami" {
    owners = ["099720109477"]
    most_recent = true
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "bucket" {
  bucket = "bucket1"
}

data "aws_availability_zones" "zonestatus" {
  state = "available"
}

output "ami" {
  value = data.aws_ami.ami.name
}

output "caller" {
  value = data.aws_caller_identity.current.id
}

output "zones" {
  value = data.aws_availability_zones.zonestatus.names
}

output "bucketname" {
  value = data.aws_s3_bucket.bucket  
}
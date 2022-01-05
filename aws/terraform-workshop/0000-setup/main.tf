terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.68.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "exercise_0000" {
  ami           = "ami-092cce4a19b438926"
  instance_type = "t3.micro"

  tags = {
    Name      = "exercise_0000"
    Terraform = true
  }
}

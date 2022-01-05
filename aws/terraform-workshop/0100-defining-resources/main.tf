provider "aws" {
  region = "eu-north-1"
}

# TODO
# Define an EC2 instance (aws_instance) with the following constraints:
# Resource identifier - exercise_0010
#
# ami = ami-07ebfd5b3428b6f4d
# instance type = t2.micro
#
# Be sure to tag it with:
# - "Name" to "exercise_0010"
# - "Terraform" to true

resource "aws_instance" "excercise_0100" {
  ami           = "ami-092cce4a19b438926"
  instance_type = "t3.micro"

  tags = {
    Name      = "excercise_0100"
    Terraform = true
  }
}
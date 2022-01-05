provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web-server" {
  ami = "ami-0813b14494048969c"
  instance_type = "t3.micro"
  key_name = "aws"
  vpc_security_group_ids = [aws_security_group.web-sg.id]

user_data = file("web.sh")

tags = {
  Name  = "web-server"
  Owner = "Moolchand"
  }
}

resource "aws_security_group" "web-sg" {
  name = "allow_http"
  description = "Allow http access"

  ingress {
      description = "http access"
      from_port = "80"
      to_port = "80"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
      description = "ssh access"
      from_port = "22"
      to_port = "22"
      protocol  = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
      description = "Access to internet"
      from_port = "0"
      to_port = "0"
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  tags = {
    Name = "web-server group"
  }
}
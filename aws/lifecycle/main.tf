provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "web-server" {
  ami                    = "ami-0813b14494048969c"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.aws.key_name
  vpc_security_group_ids = [aws_security_group.web-sg.id]

  user_data = file("web.sh")

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name  = "web-server"
    Owner = "Moolchand"
  }
}

resource "aws_key_pair" "aws" {
  key_name   = "aws"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcjVXqIGCRoRDLdh/aEzdmO0R8a1zk/TXu8syCKkDiw6ZAedPXuumI8iYQB21HoIOvKf4gtG1vkC+gQ7e1vbETLins1DG4l+Dx0u8w8ZCn0nUK7R3VHXvH0C4Py7VIESDmg3Xi7EoVHkMCe+1lQoDXv6Mpzy5NRCPLnJUh2zCWop6vt3UEcXhAub4Nkcrl0D3g1yp1b8EBtcB38u1qIE9KKilUXrCrjA7YRU9Svk77xNcOgnpPxp/KnshPF9CP9dnlyukQ0ds24mQ4v0quFZJoc8HhQKsq1w5IoZIlu2hiCv+IFLYnfeZyAc68SUx7nVpSI7Rpf24LjWrVb6V36Dy1  ansible"
  tags = {
    Name = "Terraform Public Key"
  }
}

resource "aws_security_group" "web-sg" {
  name        = "allow_http"
  description = "Allow http access"

  dynamic "ingress" {
    for_each = ["80", "22"]
    content {
      description = "web access"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    description = "Access to internet"
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "web-server group"
  }
}

resource "aws_eip" "webpubip" {
  instance = aws_instance.web-server.id
  tags = {
    Name = "Web Public IP"
  }
}
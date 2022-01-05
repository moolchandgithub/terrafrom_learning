provider "aws" {
  region = var.aws_region
}

locals {
  name_prefix = "${var.environment}-${var.servertype}"
}

data "aws_ami" "latest_ubuntu_linux" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

output "ami" {
  value = data.aws_ami.latest_ubuntu_linux.id
}

output "name" {
  value = local.name_prefix
}

resource "aws_key_pair" "aws" {
  key_name   = "key-${local.name_prefix}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcjVXqIGCRoRDLdh/aEzdmO0R8a1zk/TXu8syCKkDiw6ZAedPXuumI8iYQB21HoIOvKf4gtG1vkC+gQ7e1vbETLins1DG4l+Dx0u8w8ZCn0nUK7R3VHXvH0C4Py7VIESDmg3Xi7EoVHkMCe+1lQoDXv6Mpzy5NRCPLnJUh2zCWop6vt3UEcXhAub4Nkcrl0D3g1yp1b8EBtcB38u1qIE9KKilUXrCrjA7YRU9Svk77xNcOgnpPxp/KnshPF9CP9dnlyukQ0ds24mQ4v0quFZJoc8HhQKsq1w5IoZIlu2hiCv+IFLYnfeZyAc68SUx7nVpSI7Rpf24LjWrVb6V36Dy1  ansible"

  tags = {
    Name        = "Key-${local.name_prefix}"
    Envitonment = var.environment
  }
}

output "key" {
  value = aws_key_pair.aws.key_name
}
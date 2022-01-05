provider "aws" {
  region = "eu-north-1"
}

resource "aws_ssm_parameter" "ssm" {
  name        = "/production/database/master/password"
  description = "DB password"
  type        = "SecureString"
  value       = random_password.password.result
}

resource "random_password" "password" {
  length           = 20
  special          = true
  override_special = "#()"
}

data "aws_ssm_parameter" "dbpass" {
  name = "/production/database/master/password"
  depends_on = [
    random_password.password
  ]
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

output "datapass" {
  value     = data.aws_ssm_parameter.dbpass.value
  sensitive = true
}
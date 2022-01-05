provider "azurerm" {
  features {
    }
}

resource "random_password" "dbpass" {
  length = 15
  special = true
  override_special = "#=()"
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "ansible-testing" {
    name = "ansible-testing"
    location = "norwayeast"
}

output "config" {
    value = data.azurerm_client_config.current
}

output "password" {
    value = random_password.dbpass.result
    sensitive = true
}
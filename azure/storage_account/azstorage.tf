provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "azstoragefressi" {
  name     = "azstoragefressi"
  location = "norwayeast"
}

resource "azurerm_storage_account" "azfressigym" {
  name                     = "azfressigym"
  location                 = "norwayeast"
  resource_group_name      = azurerm_resource_group.azstoragefressi.name
  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "data" {
  name                       = "data"
  storage_account_name       = azurerm_storage_account.azfressigym.name
  container_access_type = "private"
}

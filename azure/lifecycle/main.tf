provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "terraform-testing" {
  name     = "terraform-testing"
  location = "norwayeast"
  tags = {
    environment = "test"
  }
}

resource "azurerm_ssh_public_key" "azure" {
  name                = "azure"
  location            = "norwayeast"
  resource_group_name = azurerm_resource_group.terraform-testing.name
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCcjVXqIGCRoRDLdh/aEzdmO0R8a1zk/TXu8syCKkDiw6ZAedPXuumI8iYQB21HoIOvKf4gtG1vkC+gQ7e1vbETLins1DG4l+Dx0u8w8ZCn0nUK7R3VHXvH0C4Py7VIESDmg3Xi7EoVHkMCe+1lQoDXv6Mpzy5NRCPLnJUh2zCWop6vt3UEcXhAub4Nkcrl0D3g1yp1b8EBtcB38u1qIE9KKilUXrCrjA7YRU9Svk77xNcOgnpPxp/KnshPF9CP9dnlyukQ0ds24mQ4v0quFZJoc8HhQKsq1w5IoZIlu2hiCv+IFLYnfeZyAc68SUx7nVpSI7Rpf24LjWrVb6V36Dy1  ansible"
  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = "terraform-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "norwayeast"
  resource_group_name = azurerm_resource_group.terraform-testing.name
  tags = {
    environment = "test"
  }
}

resource "azurerm_subnet" "vsubnet" {
  name                 = "web-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = azurerm_resource_group.terraform-testing.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "publicip" {
  name                = "webpublic"
  resource_group_name = azurerm_resource_group.terraform-testing.name
  location            = "norwayeast"
  allocation_method   = "Static"
  tags = {
    environment = "test"
  }
}

resource "azurerm_network_security_group" "webnsg" {
  name                = "webserver-nsg"
  location            = "norwayeast"
  resource_group_name = azurerm_resource_group.terraform-testing.name

  security_rule {
    access                     = "allow"
    direction                  = "Inbound"
    name                       = "fw-rule"
    priority                   = 1000
    protocol                   = "tcp"
    source_address_prefix      = "*"
    destination_address_prefix = azurerm_subnet.vsubnet.address_prefix
    source_port_range          = "*"
    destination_port_ranges    = ["22", "80"]
  }
  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface" "webnic" {
  name                = "webservernic"
  resource_group_name = azurerm_resource_group.terraform-testing.name
  location            = "norwayeast"

  ip_configuration {
    name                          = "webserverip"
    subnet_id                     = azurerm_subnet.vsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
  tags = {
    environment = "test"
  }
}

resource "azurerm_network_interface_security_group_association" "nsgwebnic" {
  network_security_group_id = azurerm_network_security_group.webnsg.id
  network_interface_id      = azurerm_network_interface.webnic.id
}

resource "azurerm_linux_virtual_machine" "webserver" {
  name                  = "webserver"
  location              = "norwayeast"
  resource_group_name   = azurerm_resource_group.terraform-testing.name
  network_interface_ids = [azurerm_network_interface.webnic.id]
  size                  = "Standard_B1s"

  os_disk {
    name                 = "webosdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  admin_username                  = "terraformuser"
  computer_name                   = "webserver"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = azurerm_ssh_public_key.azure.public_key
  }

#  lifecycle {  // Not Supported with same instance name. Working in AWS as they use instance ID.
#    create_before_destroy = true
#  }

  tags = {
    environment = "test"
  }
}

resource "azurerm_virtual_machine_extension" "webscript" {
  name                 = "webscript"
  virtual_machine_id   = azurerm_linux_virtual_machine.webserver.id
  publisher            = "Microsoft.OSTCExtensions"
  type                 = "CustomScriptForLinux"
  type_handler_version = "1.0"

  settings = <<SETTINGS
    {
        "fileUris": ["https://azfressigym.blob.core.windows.net/data/install-web.sh"],
        "commandToExecute": "sh install-web.sh"
    }
  SETTINGS

}
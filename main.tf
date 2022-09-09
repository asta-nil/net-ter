resource "azurerm_resource_group" "netframe_rg" {
  name     = "${var.prefix}-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "netframe_net" {
  name                = "${var.prefix}-network"
  resource_group_name = azurerm_resource_group.netframe_rg.name
  location            = azurerm_resource_group.netframe_rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.netframe_rg.name
  virtual_network_name = azurerm_virtual_network.netframe_net.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "netframe_ip" {
  name                = "${var.prefix}-ip"
  resource_group_name = azurerm_resource_group.netframe_rg.name
  location            = azurerm_resource_group.netframe_rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "netframe_nic" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.netframe_rg.location
  resource_group_name = azurerm_resource_group.netframe_rg.name

  ip_configuration {
    name                          = "private-ip-config"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.netframe_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "netframe_con" {
  network_interface_id = azurerm_network_interface.netframe_nic.id
  network_security_group_id = azurerm_network_security_group.netframe_sg.id
}

resource "azurerm_ssh_public_key" "netframe_key" {
  name                = "key-vm"
  resource_group_name = azurerm_resource_group.netframe_rg.name
  location            = "West Europe"
  public_key          = file("~/.ssh/id_rsa.pub")
}

resource "azurerm_virtual_machine" "netframe_vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.netframe_rg.location
  resource_group_name   = azurerm_resource_group.netframe_rg.name
  network_interface_ids = [azurerm_network_interface.netframe_nic.id] 
  vm_size               = "Standard_DS1_v2"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    ssh_keys       = azurerm_ssh_public_key.netframe_key.public_key
  }
  os_profile_linux_config {
    disable_password_authentication = true
  }
  tags = {
    environment = "staging"
  }
}
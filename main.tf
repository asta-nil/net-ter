resource "github_repository" "netframe-ter" {
  name = "astanil/netframe-ter"
}

resource "github_actions_runner_group" "example" {
  name                    = default
  visibility              = "selected"
  selected_repository_ids = [github_repository.netframe-ter.repo_id]
}

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

module "subnet" {
  source = "./modules/subnet"
  resource_group_name = azurerm_resource_group.netframe_rg.name
  virtual_network_name = azurerm_virtual_network.netframe_net.name
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

module "network_interface" {
  source = "./modules/network_interface"
  resource_group_name = azurerm_resource_group.netframe_rg.name
  location = azurerm_resource_group.netframe_rg.location
  subnet_id = module.subnet.network_subnet_id
  public_ip_address_id = azurerm_public_ip.netframe_ip.id
}

resource "azurerm_network_interface_security_group_association" "netframe_con" {
  network_interface_id = module.network_interface.network_interface_id
  network_security_group_id = module.security_group.security_group_id
}

resource "azurerm_ssh_public_key" "netframe_key" {
  name                = "key-vm"
  resource_group_name = azurerm_resource_group.netframe_rg.name
  location            = "West Europe"
  public_key          = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDV8ZJHhbwpk8DiL8zOgLIbVMpnc6LTuiaLwLvTXRHLy0iV75Np82Mhcga18lTRzaX8xtaa99BiEG33z/e8Czs/ru+2dRsfnrqB+qtPFhs5K2EuLM5/Sr6L0tmZCzH9pnAqxryqQ5VMOtIzc/JB5IWEqpElOkM5tittgOA1LnxOetimpXxjjGnOSZM9Z/frszlDqNzwbIQYzAeU7nL0DmlYZh2+JsnFmBaUzWrDafZMt/tMWoYFBukLyS+VzQl4RHuNMW/7suqTIZlQxaAtB3ojvq9bDd7LNygrAJPwisANK3z3qMAfjW9573SaA0yyki2xIcuHGNL7sWW5hpDF2KPqMgyb3QBg2RKu5xGPKs13vWbPk43uwU40VwIhcgKGQbIMuc4bB7B+n/pYWMiuFrqccK15ax5UUCEExOFCeM/4s0R9dy5mXnW1Jbcce+PKPVhCiyEmh1rnHoeF+8wJx7Uow0dcTTazADjXGmww7JC3THTrzrW5BAe8Frmndp66iLE= danyil@cc-8120-fa095d5f-84456567db-nmzhp"
}

resource "azurerm_virtual_machine" "netframe_vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.netframe_rg.location
  resource_group_name   = azurerm_resource_group.netframe_rg.name
  network_interface_ids = [module.network_interface.network_interface_id]
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
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = azurerm_ssh_public_key.netframe_key.public_key
    }
  }
  tags = {
    environment = "staging"
  }
}
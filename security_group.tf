module "azurerm_network_security_group" "netframe_sg" {
  name                = "netframe-sg"
  location            = azurerm_resource_group.netframe_rg.location
  resource_group_name = azurerm_resource_group.netframe_rg.name
}

resource "azurerm_network_security_rule" "allow-ssh" {
  name                       = "SSH"
  priority                   = 1001
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "22"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = azurerm_resource_group.netframe_rg.name
  network_security_group_name = azurerm_network_security_group.netframe_sg.name
}


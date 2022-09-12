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
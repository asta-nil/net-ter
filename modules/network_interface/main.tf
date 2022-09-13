resource "azurerm_network_interface" "netframe_nic" {
  name                = "${var.prefix}-nic"
  location            = var.location
  resource_group_name = var.location

  ip_configuration {
    name                          = "private-ip-config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.public_ip_address_id
  }
}
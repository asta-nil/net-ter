module "security_group" {
  source = "./modules/security_group"
  resource_group_name = azurerm_resource_group.netframe_rg.name
  location = azurerm_resource_group.netframe_rg.location
}
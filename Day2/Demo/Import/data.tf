data "azurerm_resource_group" "rg" {
  name = "__YOUR_RESOURCE_GROUP__"
}

data "azurerm_client_config" "current" {}

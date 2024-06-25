locals {
  storage = [
    "chmstudent0sa1",
    "chmstudent0sa2",
    "chmstudent0sax",
    "chmstudent0sa3",
  ]

  set_storage = toset(local.storage)
}

# Example of using length function together with count argument
# Here we recommend using for_each because of the int index in count!!!
resource "azurerm_storage_account" "storage" {
  count = length(local.storage)

  name                     = local.storage[count.index]
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

locals {
  stg1 = azurerm_storage_account.storage[0]
  stg2 = azurerm_storage_account.storage[1]
}

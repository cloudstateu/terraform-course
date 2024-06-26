locals {
  storage = [
    "chmstudent0sa1",
    "chmstudent0sa2",
    "chmstudent0sa3",
  ]
  storage_length = length(local.storage)
  is_student     = contains(local.storage, "chmstudent0sa3")

  map = {
    a=1,
    c=2,
    d=3
  }
  keys_map = keys(local.map)

  range = range(15)

  lists_combined = concat(["a", ""], ["b", "c"])
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

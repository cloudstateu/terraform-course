resource "azurerm_key_vault" "chmstudentXXkv" {
  name                        = "chmstudentXXkv"
  location                    = data.azurerm_resource_group.studentXX.location
  resource_group_name         = data.azurerm_resource_group.studentXX.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]
  }
}

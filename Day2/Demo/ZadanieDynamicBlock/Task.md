# ZTask: Dynamic Blocks

Prepare a new terraform configuration with the data source pointing to Your resource group.

Also add a date source `azurerm_client_config` which retrieves the current provider client configuration.

Create an Azure Key Vault resource and configure Access Policy inside using dynamic blocks and a local variable:

```terraform
locals {
  vault_access_policy : {
    chmstudent0 = {
      object_id          = "ea3c2cef-72c7-41b2-9099-84d9fe95fdaf"
      secret_permissions = ["Get", "List", "Set"]
    }
    chmstudent29 = {
      object_id          = "e84deb1e-45bb-488a-be1b-46c3b50494b5"
      secret_permissions = ["Get", "List", "Set"]
    }
    myuser = {
      object_id          = data.azurerm_client_config.current.object_id
      secret_permissions = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"]
    }
  }
}
```

Get the `tenant_id` value during configuration from the `azurerm_client_config` data.

Helpful links:

* [Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)
* [Azure Key Vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)

## Task 1 - DNS Zones

The purpose of the task is to learn using `for_each` loop.

Our purpose is to create a local variable called `zones`, or use the one created in task 6 from day 1.
The variable should be of type `map(string)` and contain private DNS zone names for the following services: Azure File Share,
Azure Container Registry, Azure Key Vault, Azure Kubernetes Service, Azure Database for PostgreSQL.
Then, using the `for_each` loop, let's create private DNS zones together witk links to the `vnet-shared` network.
Private DNS zones used by the private endpoint should use the recommended names from documentation.
Private DNS Zone link names names should contain the name of the zone or its key in a local variable and the name of the network to which the link is being created.

Example of a local variable of type `map(string)`:

```terraform
locals {
  zones = {
    "file"       = "privatelink.file.core.windows.net"
    "postgresql" = "privatelink.postgres.database.azure.com"
  }
}
```

To complete the task, follow these steps:

1. Use the Terraform file where you have already defined private DNS zones in previous tasks. Let's modify it for the current task.
2. Create a local variable of type `map(string)` called `zones`, where you will add names of the DNS zones to be created. Use abbreviations 
   of services for which the zones are created as keys in newly created local map. The values ​​should take the names of individual zones.
3. Modify the `private_dns_zone` resource. Use the `for_each` loop for configuration. The name of every zone should be
   passed as the value of a local variable that Terraform will iterate over.
4. The changes will require you to adjust the Private Endpoint resource for Azure Container Registry you previously created so that
   it used the resource of a private DNS zone created using a loop.
5. Run the `terraform plan` command. Check if Terraform detected any configuration errors.
6. Run `terraform apply` to create the resources.
7. Verify if all resources were successfully created.
8. Check how resources created with `for_each` loop are represented in the state file.* (optional)
9. Add a resource that links DNS zones with the `vnet-shared` network. Again try to use a `for_each` loop. What is more, try to describe the
   resource name by connecting the service name, stored as a key in a local variable, with the network name using a dash e.g. `file-vnet-shared`.

Helpful links:

* [Private DNS zone names](https://learn.microsoft.com/pl-pl/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration)
* [for_each loop](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)
* [Resource private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone)
* [Resource private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link)

## Task 2 - Key Vault Secrets (optional)

The purpose of the task is to learn using count loop.

Let's create a new local variable `passwords` of type `list(string)` and add at least two example entries to the list.
Then use the `azurerm_key_vault_secret`resource and `count` argument to create Azure Key Vault secrets in a loop.

Example of a local variable of type `list(string)`:

```terraform
locals {
  passwords = [
    "secretvalue123",
    "secretvalue321"
  ]
}
```

To complete the task, follow these steps:

1. In the `keyvault.tf` file, create a new local variable called `passwords`.
2. Add a new resource of type `azurerm_key_vault_secret`. Use the `count` loop and ensure unique names of the secrets being created.
   Get the secret value from a local variable. Remember that when using `count` loop you have access to the `count` keyword 
   which you can use to refer to a specific iteration number, e.g. `count.index`.
3. Run the `terraform plan` command. Check if Terraform detected any configuration errors.
4. Run `terraform apply` to create the secrets.
5. Verify if the secrets were successfully created by searching for them in Azure Key Vault.
6. Add aanother entries to the local variable, e.g. at the beginning of the list, at the end and in the middle. Run
   the `terraform plan` command again and check how Terraform will behave towards current configuration of secrets.
7. Check how the resource using `count` is represented in the state file.

Helpful links:

* [Resource azurerm_key_vault_secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret)
* [count loop](https://developer.hashicorp.com/terraform/language/meta-arguments/count)


## Task 3 - Log Analytics Workspace (optional)

The purpose of the task is nauczenie się wykorzystywania dynamic blocks.

Let's try to create a Log Analytics Workspace resource and to configure a solution for sending there logs and metrics
from Azure Key Vault. For this purpose, use the `azurerm_monitor_diagnostic_setting` resource and download the available
categories using the `azurerm_monitor_diagnostic_categories` data block. Then make the `enabled_log` and `metric` blocks 
dynamic by using the dynamic block functionality and the for_each loop.

To complete the task, follow these steps:
1. Create a new file, e.g. `monitoring.tf` and define the creation of the Log Analytics resource inside: `azurerm_log_analytics_workspace`.
2. Create a data block of type `azurerm_monitor_diagnostic_categories`, indicating the ID of your Key Vault in the `resource_id` argument.
   This will allow you to download all trackable categories of logs and metrics for your Azure Key Vault resource.
3. Define the `azurerm_monitor_diagnostic_setting` resource where you will configure export of logs from the selected Azure Key Vault to
   defined in the first step of Log Analytics Workspace.
4. Inside the Diagnostic Settings resource, create dynamic `enabled_log` and `metric` blocks. Using a `for_each` loop iterate through 
   log categories (`log_category_types` attribute) and metrics (`metrics` attribute) respectively, which are available thanks to
   Diagnostic Categories resource downloaded in the previous step. This is how you define sending all available categories
   logs and metrics to the designated Log Analytics Workspace.
5. As usual, run the commands `terraform plan` to verify your configuration and `terraform apply` to implement the changes.
6. Verify the creation of the Diagnostic Setting by searching in Azure Key Vault.

Helpful links:

* [Dynamic Blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)
* [Log Analytics Workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace)
* [Monitor Diagnostics Categories](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/monitor_diagnostic_categories)
* [Diagnostic Setting](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting)

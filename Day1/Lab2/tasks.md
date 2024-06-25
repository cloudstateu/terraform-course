#  All the following tasks should be performed in the Terraform folder/configuration used in Lab1 Task2

## Task 1 - Storage Account

The purpose of the task is to learn how to import resources into a state.

In this task, you need to create the Storage Account resource manually in Azure portal, prepare the Terraform code
representing given resource and import the resource into the state using the `terraform import` command.

To complete the task, follow these steps:

1. Create a Storage Account resource in the Azure portal. Use the same region where your resource group is located.
2. Prepare the storage account representation in a new Terraform file called `storage.tf`.
3. Import the created resource using the `terraform import` command.
4. Check for changes to the state file after importing the resource.
5. Run the `terraform plan` command to check the compatibility of the described resource with the one in the cloud.

Helpful links:

* [Resource azurerm_storage_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [Terraform import command](https://developer.hashicorp.com/terraform/cli/commands/import)


## Task 2 - Key Vault

The purpose of the task is to learn how to create resources in the Azure cloud using Terraform.

Let's use the configuration from the previous task to create a new Azure Key Vault resource in a resource group 
referenced with data block. When configuring your Azure Key Vault resource, grant your user permissions for
downloading and creating secrets.

To complete the task, follow these steps:

1. Add a new data block of type `azurerm_client_config` to the `data.tf` file. It contains information about currently
   configured client in the provider. In our case, this will be the currently logged in user.
2. In the newly created `keyvault.tf` file, configure a resource block for Azure Key Vault.
   When configuring a resource, use references to the resource group referenced with data block.
   In `access_policy` block configure permissions for your user.
   * When creating a resource, select sku: Standard
   * The object_id and tenant_id values ​​for the user can be downloaded from the portal or using data
   source `azurerm_client_config`.
3. Run the `terraform plan` command. Check if Terraform detects any configuration errors. Pay attention to the plan displayed.
   Terraform should return a plan with intention to create a single resource.
4. Run `terraform apply` to deploy your Azure Key Vault resource.
5. Verify that the resource creation was successful by searching for the resource in the Azure portal.
6. Check what changes occurred in the state file, pay attention to the differences between `data` and `resource`.

Helpful links:

* [Resource azurerm_key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault)
* [Data azurerm_client_config](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config)


## Task 3 - Virtual Network Shared

The purpose of the task is to learn how to use variables.

Let's create a virtual network `vnet-shared` and an `endpoints` subnet using the `azurerm_virtual_network` and `azurerm_subnet` resources.
Place resource names and network/subnet network address prefixes/spaces as variables. Use a local variable to force resource names to be prefixed with your student number.
Place the resources in the resource group dedicated for you.

To complete the task, follow these steps:

1. Create a `variables.tf` file and define the followign variables: `vnet_name`, `subnet_name`, `vnet_address_space` and `subnet_address_prefixes`.
2. Add a local variable called `prefix` to the `variables.tf` file, which will contain your student number. Let's use it as an prefix
   at the beginning or end of the resources names which you create.* (optional)
3. Create a `network.tf` file and add the `azurerm_virtual_network` and `azurerm_subnet` resources to it, configure using variables and locals.
4. Create a `terraform.tfvars` file and assign values ​​to the variables.
5. Run the `terraform plan` command. Check if Terraform detects any configuration errors.
6. Run the `terraform apply` command to create new resources.
7. Try to pass the variable value to the Terraform configuration using other methods, e.g. from the CLI -var option or environments variables
   TF_VAR_. Try passing the value in several ways at the same time and check the effect.* (optional)


Helpful links:

* [Resource azurerm_virtual_network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [Resource azurerm_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [Terraform variables](https://developer.hashicorp.com/terraform/language/values/variables)
* [Variable definition precedence](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence)


## Task 4 - File Share (Optional task)

Let's try to create a File Share resource for previously built Azure Storage Account.
Azure Storage File Share will be connected to our application for storing files.

Please note:

* Use the existing `storage.tf` file or create a new one, dedicated to the File Share resource.
* When creating File Share, select Quota: 50gb.
* This resource will be dedicated to the application environment.

Helpful links:

* [Storage Account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account)
* [Storage Share](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_share)

## Task 5 - Container Registry

Let's create an Azure Container Registry for storing your application images.

Please note:

* Create a new file and name it e.g. `acr.tf`.
* ACR will be shared between environments, so in subsequent tasks it will be placed in the Shared network.
* When creating a resource, select sku: `Premium`, only this plan allows private communication.
* Create a resource with the administrator user option enabled by defining the appropriate argument and value.
* Block public access to the service you are creating by defining the appropriate argument and value.

Helpful links:

* [Resource azurerm_container_registry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/container_registry)

## Task 6 - DNS Zone/Private Endpoint

Let's create a private endpoint for Azure Container Registry so that the service uses a private network for communication.

Before creating the private endpoint, you should create a private DNS zone resource and link it with the virtual network.
Pass the DNS zone name as a local variable. Use a variable in the form of a map `map(string)` in which the key will be the short name of the service,
and the value is the name of the DNS zone.
Private DNS zones used by the private endpoint should use the recommended names.

Example of a local variable of type `map(string)`:

```terraform
locals {
  zones = {
    "file"       = "privatelink.file.core.windows.net"
    "postgresql" = "privatelink.postgres.database.azure.com"
  }
}
```

Please note:

* For code clarity, create new dedicated files, e.g. `dns.tf` and `endpoints.tf`.
* In the `private_service_connection` block, when creating a private endpoint, you must indicate the resource id for which
   we create an endpoint and the name of the sub-resource. Look for its value in the documentation linked.
* In the `private_dns_zone_group` block, when creating a private endpoint, you must indicate the id of the private DNS zone. Thanks to this
   the appropriate A record pointing to the endpoint's network interface will be automatically added.
* When creating a private endpoint, in the `subnet_id` parameter, you must indicate the subnet intended for the private endpoint.
   Let's use the `endpoints` subnet in the `vnet-shared` network.

Helpful links:

* [Private DNS zone names](https://learn.microsoft.com/pl-pl/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration)
* [Available sub-resource names](https://learn.microsoft.com/en-gb/azure/private-link/private-endpoint-overview#private-link-resource)
* [Resource private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint)
* [Resource private_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone)
* [Resource private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link)
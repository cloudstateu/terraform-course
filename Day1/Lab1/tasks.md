# Terraform Training: Day 1

## Task 1 - Provider

The purpose of the task is to learn how to configure the AzureRM provider and download data on existing Azure resources using data block.

Let's configure the AzureRM provider and download the existing resource group according to the access provided.

To complete the task, follow these steps:

1. Log in to Azure with an account assigned to You using the `az login` command in the console on your local station.
2. Prepare a folder for your Terraform files. Create a `providers.tf` file and configure the AzureRM provider inside. Please make sure to indicate the appropriate
   Subscription ID in the provider's configuration where the downloaded resource group will be located. Indicate the use of a specific version of provider: `3.40.0`.
3. Initialize the configuration using the `terraform init` command.
4. Create a `data.tf` file and add a data block of type `azurerm_resource_group` inside. Configure it according to the documentation,
   to download the required resource group.
5. Run the `terraform plan` command to verify that Terraform has detected the resource group and that there are no errors in
   configuration.
6. Run the `terraform apply` command. Terraform will download the existing resource group from Azure, save it in state and
   will exit without making any changes in infrastructure.
7. Check what has been written to the state file after running the `terraform apply` command.

Helpful links:

* [AzureRM provider documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
* [Data azurerm_resource_group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group)


## Task 2 - Remote Backend

The purpose of the task is to learn how to configure the backend to store and manage the state file remotely.

Let's use the Storage Account service, where we will store the state of our cloud infrastructure.
Please note that the Storage Account instance name **must be globally unique.**

To complete the task, follow these steps:

1. Open the Azure portal. Make sure you are logged in to the tenant used for the current course and
   you can see your dedicated resource group.
2. Manually create a Storage Account in your resource group, use the default settings.
3. Give your user the Storage Blob Data Owner role at the level of the Storage you created.
4. In the newly created storage, create a container called `tfstate`.
5. In your Terraform configuration folder, **create a new folder** and copy the `.tf` files with the code from the previous task into it.
6. Create a new `backend.tf` file and configure the `azurerm` backend block pointing to the new container. For our needs in the
   laboratory, use the authentication method for storage via your Azure Entra ID (Azure AD) account.
7. Change to the new directory and initialize the configuration using the `terraform init` command.
8. Run the `terraform plan` command to verify that Terraform has detected the resource group and that there are no configuration errors.
9. Run the `terraform apply` command. Terraform will download the existing resource group from Azure, save it in state and
   will exit without making any changes to infrastructure.
10. Check what has been written to the state file after running the `terraform apply` command.

Helpful links:

* [Azurerm backend documentation](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)

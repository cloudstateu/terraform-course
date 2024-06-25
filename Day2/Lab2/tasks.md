## Task 1 - Virtual Machine

The purpose of the task is learn using public modules.

In this task, you need to create a virtual machine (Ubuntu) using the public module:
https://registry.terraform.io/modules/Azure/compute/azurerm/latest. For this purpose, use
the `vnet-shared` network and its subnet. When creating the VM, set authentication method to
ssh key and the VM size to "Standard_D2as_v5". Search the documentation for how to set these parameters.
 
To complete the task, follow these steps:
1. Create a new file and name it e.g. `vm.tf`.
2. In the new file, create a module block and use the documentation to create a new virtual machine with Ubuntu
   (UbuntuServer), size "Standard_D2as_v5". Use the network indicated in the task.
   Define your preferred authentication method to ssh key.
   Link to documentation: https://registry.terraform.io/modules/Azure/compute/azurerm/latest
3. To provide access to the machine being created, open the necessary traffic (port) on the Network Security Group (NSG), which 
   is established within the module. Use the `remote_port` argument and specify the appropriate port (22 in case of ssh).
4. Run the `terraform init` command to initialize the module used in the job.
5. As usual, run the commands `terraform plan` to verify your configuration and `terraform apply` to implement the changes.
6. Check on the portal what resources were created with the module.
7. Try to log in to the created machine from the local console via ssh. Use its public IP address.

Helpful links:

* [Public compute module](https://registry.terraform.io/modules/Azure/compute/azurerm/latest)

## Task 2 - Virtual Networks/Peering

The purpose of the task is to learn creating and using own custom modules.

Let's create a module consisting of a single network, connected by peering to the `vnet-shared` network created in the previous tasks.
Remember that peering should be configured in two directions, i.e both from the network created in the module and from the `vnet-shared` network.

Define the following variables in the module:
* vnet_name             - name of the network being created
* vnet_address_space    - address space of the created network
* rg_name               - name of the resource group used in the course
* location              - location of resources used in the course (e.g. from the resource group)
* id-vnet-shared        - id of the network created in one of the previous tasks
* name-vnet-shared      - the name of the network created in one of the previous tasks

To complete the task, follow these steps:

1. Create a new folder for writing the module code.
2. In the new folder, start with creating a `providers.tf` file where you will define the providers needed for the module code. 
   Since provider can be passed from the level at which the module will be called, this following configuration is enough:

   ```terraform
   terraform {
   required_providers {
      azurerm = {
         source = "hashicorp/azurerm"
         configuration_aliases = [
         azurerm.network
         ]
      }
   }
   }
   ```
   The `configuration_aliases` argument will allow you to refer from the outside to the provider used inside the module.
   Ultimately, you will use it to transfer the provider used at a higher level. This way, the provider configuration is saved
   in the place from which the module will be called, it can be passed and used inside the module.
3. Create a `variables.tf` file with the variables listed at the beginning of the task. Give them the appropriate type. Mostly they will be
   variables of the `string` type, while some of them, e.g. address space, can be defined as a list of strings: `list(string)`
4. Create a `main.tf` file in which you will define all the resources listed in the task.
5. Create a network resource and 2 pering resources with a `vnet-shared` network. The network will represent individual environments,
   therefore you can name it in Terraform as "env" e.g. `resource "azurerm_virtual_network" "env"` The name of the resource itself
   should be passed via a variable. The peering name should also include the variable used to name the network.
   This will make the module more dynamic and, consequently enable us to use it for creation of networks for many environments.
6. In the main directory where you will create the code for the remaining tasks, create a new file `network-env.tf`.
7. In the new file, define the call to the module you created. Remember to indicate the source, i.e. the path to
   the folder where you configured the module code. Additionally, write down the `providers` argument to pass the configuration
   provider to the module, e.g.

   ```terraform
   providers = {
      azurerm.network = azurerm
   }
   ```
   Remember also to assign all variables defined inside the module as arguments. Terraform will need these values ​​to invoke the module.
8. As usual, run the commands `terraform plan` to verify your configuration and `terraform apply` to implement the changes.
9. Check the configuration of the resources created. Try to find them in the state file. Pay attention to what their reference looks like.

Helpful links:

* [Virtual Network](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network)
* [Virtual Network Peering](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering)

## Task 3 - Subnet/Network Security Group

The purpose of this task is to learn how to create and use more complex modules.

Let's try to expand the module created in the previous task. Let's define 3 subnets: `app`, `data` and `endpoint` for our network.
Moreover, the `data` subnet should be configured with the so-called service delegation for the `Microsoft.DBforPostgreSQL/flexibleServers` service.
Additionally, a separate instance of Network Security Group should be created and attached to each subnet.

Your module should contain the following variables:
* vnet_name             - name of the network being created
* vnet_address_space    - address space of the created network
* rg_name               - name of the resource group used in the course
* location              - location of resources used in the course (e.g. from the resource group)
* id-vnet-shared        - id of the network created in one of the previous tasks
* name-vnet-shared      - the name of the network created in one of the previous tasks
* sub_app_address_space - address space for `app` subnet
* sub_data_address_space - address space for `data` subnet
* sub_endpoint_address_space - address space for  `endpoint` subnet

To complete the task, follow these steps:

1. Go to the folder where you keep the module code from the previous task
2. Complete the `variables.tf` file with the missing variables necessary for subnet creation.
3. In the next step, define the creation of the 3 indicated subnets: `app`, `data` and `endpoint`. Because the `data` subnet should
   have so called service delegation for the PostgreSQL Flexible Server service, you must use the `delegation` block and
   `service_delegation`. Apart from specifying the `Microsoft.DBforPostgreSQL/flexibleServers` service, you will also need to specify
   the following action: `Microsoft.Network/virtualNetworks/subnets/join/action`.
4. Finally, define 3 Network Security Group resources, one for each subnet. Then connect the NSGs with the appropriate
   subnet resources. NSG resource names should also include the variable used to name the vistual network. As for peering,
   this will make the module more dynamic and, consequently enable to use it to create networks for many environments.
5. In the main directory, `network-env.tf` file where you call your module, add the variables created in this task in a form of
   module arguments. Assign appropriate values to them.
6. As usual, run the commands `terraform plan` to verify your configuration and `terraform apply` to implement the changes.
7. If the module works properly, use it to create 2 networks (with resources defined in the module) corresponding accordingly
   `dev` and `prod` environments. The name of the environment should be included in the name of the networks being created.

   Helpful links:

* [Subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet)
* [Network Security Group](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group)
* [NSG Association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association)


## Task 4 - Private Endpoint: Key Vault

The purpose of the task is to learn how to transfer output data from the module and use it in the main code directory.

Let's set up Private Endpoint resources for the previously created Kay Vault. For this purpose you should use the network created 
in the previous task that belongs to the `dev` environment. To enable the use of this network in the main directory, you will need 
to define the output data in the module through which the subnet resource should be transferred.

To complete the task, follow these steps:

1. In your module's code directory, create a new Terraform code file and name it `outputs.tf`
2. In the new file, create an output block and use it to pass the entire `endpoint` subnet resource as value.
3. In the root directory, define a Private Endpoint resource for Azure Key Vault. Since we want to use Private Endpoint for
   Key Vault service, set an appropriate value to the `subresource_names` argument. Indicate the correct private DNS zone for
   Key Vault resource. Set the `endpoint` subnet transferred from the module using the block created in the previous point.
4. As usual, run the commands `terraform plan` to verify your configuration and `terraform apply` to implement the changes.

Helpful links:

* [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs)
* [Available sub-resource names](https://learn.microsoft.com/en-gb/azure/private-link/private-endpoint-overview#private-link-resource)
* [Resource private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint)

## Task 5 - Private Endpoint: File Share (optional)

If you managed to properly configure the endpoint for the Key Vault service, try doing the same for File Share created in the previous tasks.

Helpful links:

* [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs)
* [Available sub-resource names](https://learn.microsoft.com/en-gb/azure/private-link/private-endpoint-overview#private-link-resource)
* [Resource private_endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint)

## Zadanie 6 - PrivateDNS Zones

In this task, you need to link all previously created private DNS zones to the new `dev` and `prod` environment networks.

Please note:
* In order to link a DNS private zone to a network, you need its ID. Configure access to a network resource by adding a block for it
  in the `outputs.tf` file located in the module folder.
* As for the `vnet-shared` network, make the link name dynamic by combining the zone name or its key in a local variable
   with the name of the network to which the connection is being created.
* Use the `for_each` loop as in the case of a shared network.

Helpful links:

* [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs)
* [Resource private_dns_zone_virtual_network_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link)

## Task 7 - PostgreSql Flexible Server (optional)

Let's try to create a PostgreSql Flexible Server and attach it to the `data` subnet delegated for this service and belonging to the `dev` environment network. 
Configure also the appropriate DNS zone for this service. Define login and server administrator password in the code. Specify the following arguments and values:

  sku_name   = "B_Standard_B1ms"
  version    = "12"
  storage_mb = 32768
  zone       = "1"

Helpful links:

* [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs)
* [Resource Postgresql Flexible Server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server)

## Task 8 - Provider Random (optional)

Try using the `random` provider to create a `random_password` resource and use it to assign the PostgreSql server administrator password.
Try to research invidually on how to use this provider and the resource.

## Task 9 - AKS Idetities & Roles

In this task, you need to create two user-assigned identities used by AKS and assign them appropriate Roles on individual resources.

Requirements:
* Identity `cni_kubelet` with following role:
   - `AcrPull` on Azure Container Registry resource
* Identity `cni` with following roles:
   - `Private DNS Zone Contributor` on the private DNS zone resource for Azure Kubernetes Service
   - `Contributor` on Your dedicated resource group
   - `Managed Identity Operator` on the resource of the second identity being created (`cni_kubelet`)

Helpful links:

* [User Assigned Identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity)
* [Role Assigment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment)

## Task 10 - AKS Cluster

Let's try to create an Azure Kubernetes Service (AKS) cluster that uses the identities created in the previous task and
integrated into the `app` subnet in the `dev` environment (network). In addition to the basic arguments, the resource being defined should
have the following values:

   ```terraform
   dns_prefix                          = "aks-app-dev"
   private_cluster_enabled             = true
   private_cluster_public_fqdn_enabled = true
   private_dns_zone_id                 = "------ID of Private DSN Zone dedicated for AKS------"

   default_node_pool {
     name           = "system"
     node_count     = 1
     vnet_subnet_id = "------ID of subnet indicated in the task------"
     vm_size        = "Standard_B2s"
   }

   identity {
     type         = "UserAssigned"
     identity_ids = ["------ID of cni identity------"]
   }

   kubelet_identity {
     client_id                 = "------client_id of cni_kubelet identity------"
     object_id                 = "------principal_id of cni_kubelet identity------"
     user_assigned_identity_id = "------ID of cni_kubelet uidentity------"
   }
   ```

Helpful links:

* [Azure Kubernetes Service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)

## Task 11 - CI/CD dla Terraform w Azure DevOps (optional)

The purpose of the task is learn how to use CI/CD pipelines to build infrastructure using Terraform in Azure DevOps.

> NOTE: To complete the task, you need access to your own organization in Azure DevOps and appropriate permissions. The current course does not provide access to Azure DevOps environments for students.**

> IMPORTANT: If you want to take full advantage of the demo presented in the **azure-pipelines-approval.yml** file, you must take an additional step of creating the so-called Environment in Azure DevOps - [LINK](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops). If you don't want to make any changes to the YAML file, name the Environment you create as **'ExecutePlan'**

Our purpose is to create a CI/CD pipeline in Azure DevOps for infrastructure managed with Terraform code that will enable automatic creation or updating of resources in the Azure cloud. The pipeline should consist of two phases: Continuous Integration (CI) and Continuous Deployment (CD), defined in the azure-pipelines.yml configuration file. This example file is located in the current repository path (Day2/Lab2/Task11).

To complete the task, follow these steps:

In Azure:

1. Go to Azure Entra ID and create a Service Principal with default settings.
2. Save the Application (client) ID from the Overview Service Principal tab to use when configuring your connection to Azure in Azure DevOps.
3. Generate a Client secret for Service Principal in the Certificates & Secrets tab and save it in a safe place to use it later in Azure DevOps.
4. Grant an RBAC role named "Owner" to the Service Principal at the selected subscription or resource group level.
5. Go to your Azure DevOps environment.

In Azure DevOps:

1. Create a new repository or project for your Terraform code in Azure DevOps.
2. Set up a connection to Azure in Azure DevOps, enabling access to cloud resources:
* Go to Project `Settings`/`Service Connections`/`New Service connection`,
* Select an option from `Azure Resource Manager`/`Service principal (manual)`,
* Complete the required information:
 - Scope Level - select "Subscription",
 - Subscription Id - you can download it from the portal by going to the selected subscription and then to the "Overview" tab. There you will find a "Subscription ID" field,
 - Service principal Id - indicate the "Application (client) ID" saved in the previous steps,
 - Service principal key - indicate the downloaded "Client secret",
 - Check "Grant access permission to all pipelines".
3. Create a configuration file "azure-pipelines.yml" in the repository that will contain the definition of the CI/CD pipeline - for terraform it will be init, plan, apply. If you need help, please use the ready-made example in the assignment repository.
4. Create a new Azure Pipelines:
* From the main menu item on the left side of the portal, select `Azure Pipeline`/`New pipeline`/`Azure Repos Git`
* Select the repository you created where a file with a defined pipeline exists, e.g. `azure-pipelines.yml`:
 - Select `Existing Azure Pipelines YAML File`,
 - Then, from the menu in the "Path" section, select the created file from the repository.

Helpful links:

* [How to create a project in Azure DevOps](https://learn.microsoft.com/en-us/azure/devops/organizations/projects/create-project?view=azure-devops&tabs=browser)
* [Terraform commands for Azure DevOps](https://github.com/microsoft/azure-pipelines-terraform/blob/main/Tasks/TerraformTask/TerraformTaskV4/README.md)

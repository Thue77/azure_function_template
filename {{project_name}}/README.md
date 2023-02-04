# Devloping Azure Functions locally
This repo represents a template to set up local Python development for Azure function. The setup follows [this](https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=python) and [this](https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-local) MS documentation.



## Setup
This templates utilizes the CLI tool, [copier](https://pypi.org/project/copier/), to dynamically create new projects based on this template. To create a new project from this template simply run `copier .\azure_function_tempalte\ <NameOfProject>`, where `<NameOfProject>` is replaced by the appropriate project name.



The local environment is set up automatically by running the Powershell script [env_setup](/utils/env_setup.ps1). Note that at the moment the script only works for Windows machines and it will install `pyenv` by default. If the module `AzureFunctionsCoreTools` is not already installed on the machine, the installation might take some time. For deploying the Azure Function, refer to [deploy_func](/utils/deploy_func.ps1).

For local debugging is is necessary to add the extensions [Azure Functions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) and [Azurite](https://marketplace.visualstudio.com/items?itemName=Azurite.azurite).

An internet connection is necessary for setting up the environment!

## Infrastructure
The infrastructure is defined in [infrastructure](/infrastructure/) and deployed via [deploy_infra](/infrastructure/deploy_infra.ps1). The infrastructure includes an ADF and a KeyVault to make it self contained, but for actual projects, the structure should be different as the Keyvault should be shared be resources in the same environment and the same principle could go fro ADF if used as an orchestrator. Additionally, the infrastructure is only ment for small development and poc projects, as no special security measures have been taken.

Note that the deployment file uses values from a file named "secrets.conf", which is represented by a jinja template.

For more info see [link](https://kyleparrish.com/blog/powershell-script-config-file/).

## General notes
The .gitignore file contains some specific ignores at the bottom added for convenience when testing the template. For instance is the folder name "HelloWorld" ignored to allow for placing the function project in such a folder without comitting set folder to this template.

Furhter it is worth noting that this template is setup specifically for the V2 Programming model, which is still in preview.

### Common issues
Some issues that have been encountered were solved by uninstalling and reinstalling both the ".Net 6 SDK" and the "Azure Functions Core Tools".
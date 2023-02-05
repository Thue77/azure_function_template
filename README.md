# Devloping Azure Functions locally
This repo represents a template to set up local Python development for Azure functions. The setup follows [this](https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-vs-code?tabs=python) and [this](https://learn.microsoft.com/en-us/azure/azure-functions/functions-develop-local) MS documentation.



## Setup
This templates utilizes the CLI tool, [copier](https://pypi.org/project/copier/), to dynamically create new projects based on the template. To create a new project from this template simply run `copier .\azure_function_tempalte\ <NameOfProject>`, where `<NameOfProject>` is replaced by the appropriate project name.



The local environment is set up automatically by running the Powershell script [env_setup](/utils/env_setup.ps1). The project management is done using [pip-tools](https://pypi.org/project/pip-tools/), which means that the requirements files should be generated automatically via `pip-compile` using the specification in [pyproject](pyproject.toml).

 Note that at the moment the script, [env_setup](/utils/env_setup.ps1), only works for Windows machines because it installs [pyenv](https://github.com/pyenv/pyenv) for Windows and [AzureFunctionsCoreTools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Cwindows%2Ccsharp%2Cportal%2Cbash) using `winget`. If these are already installed on the system, then the installation is skipped. If the module `AzureFunctionsCoreTools` is not already installed on the machine, the installation might take some time.

 The following are installed if the do not already exist:

 * [AzureFunctionsCoreTools](https://learn.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=v4%2Cwindows%2Ccsharp%2Cportal%2Cbash) with winget.
 * [pyenv](https://github.com/pyenv/pyenv) from source.
 * [Azurite](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite?tabs=visual-studio) with `npm`.


## Local execution
### Azurite
* To start Azurite run `azurite --silent --location c:\azurite --debug c:\azurite\debug.log`. To use another location simply change "c:\azurite"
* It is possible to connect to the local storage emulator via [Azure Storage Explorer](https://learn.microsoft.com/en-us/azure/storage/common/storage-explorer-emulators).
* The [default connection string](https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azurite?tabs=visual-studio) for Azurite should be set in the variable, "AzureWebJobsStorage" in [local.settings](../blob_reader/local.settings.json). Then the local execution will use the storage emulator. During deployment of the infrastructure the correct connection string to the storage account is already set in the function app setings. 
* Access app settings in Python using `os.environ['AzureWebJobsStorage']`.

### Local Azure function

* To start function run `func start`
* To deploy function run `func azure functionapp publish <app_name>`

### Script for local execution
The Powershell script [execute_func](./%7B%7Bproject_name%7D%7D/execute_func.ps1.jinja) is included to start Azurite and Azure Function locally with a single command


For local debugging it is possible to use VS Code by installing the extensions [Azure Functions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions) and [Azurite](https://marketplace.visualstudio.com/items?itemName=Azurite.azurite). Everything in the project works by default without the VS Code extensions.

## Infrastructure
The infrastructure is defined with bicep code in [infrastructure](/infrastructure/) and deployed via [deploy_infra](/infrastructure/deploy_infra.ps1). The infrastructure includes an ADF and a KeyVault to make it self contained, but for actual projects, the structure should be different as the Keyvault should be shared be resources in the same environment and the same principle could go fro ADF if used as an orchestrator. Additionally, the infrastructure is only ment for small development and poc projects, as no special security measures have been taken.

Note that the deployment file uses values from a file named "secrets.conf", which is represented by a jinja template. The secrets are filled in by the copier command that renders the project template. 

For more info on the format of the resulting "secrets.conf" file and how Powershell reads it, see [link](https://kyleparrish.com/blog/powershell-script-config-file/).




## General notes
This template is setup to work for both programming model V1 and V2, but it is worht noting that some of the templates are not available in V2, which is also still in preview.

### Common issues
* Some issues that have been encountered were solved by uninstalling and reinstalling both the ".Net 6 SDK" and the "Azure Functions Core Tools".
* Sometimes when using `pip-compile` an unhandled error might be thrown from the back-end when building the wheel. To get a proper error message, try to run `python -m build --wheel .` where the folder contains the toml file but not requirements files. 
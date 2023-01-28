param ($folderName, $template)

try {
if (-not($folderName)) {
    throw 'No folder name is given. Please give a foldername'
}

try {
    func --version
}
catch {
    <#Do this if a terminating exception happens#>
    winget install Microsoft.AzureFunctionsCoreTools
}
Write-Host 'checking version of pyenv'
try {
    pyenv --version
}
catch {
    Write-Host 'Pyenv is not installed'
    Write-Host 'Installing pyenv for Windows'
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"
}
Write-Host 'Installing python 3.8.10 with pyenv'
pyenv install 3.8.10
Write-Host 'Activate python 3.8.10 with pyenv'
pyenv global 3.8.10

try {
    poetry --version
}
catch {
    Write-Host 'Poetry is not installed'
    Write-Host 'Install poetry'
    (Invoke-WebRequest -Uri https://install.python-poetry.org -UseBasicParsing).Content | python -
}
Write-Host 'Configure poetry'
poetry config virtualenvs.prefer-active-python true
poetry config virtualenvs.in-project true
Write-Host 'Update pip and install virtual environment'
mkdir $folderName
Copy-Item .\pyproject.toml $folderName
Set-Location $folderName
poetry install
poetry run pip install --upgrade pip
.\.venv\Scripts\activate
Write-Host 'Initialize project for Azure function'
if ($template) {
    Write-Host 'Project started based on template' $template
    func new --name $folderName --worker-runtime python -m V2 --template $template
}
else {
    Write-Host 'Empty function project is initiated. If you wish to use a template instead then try with HTTP Trigger '
    func init --name $folderName --worker-runtime python -m V2
}

}
catch {
    throw $_
}
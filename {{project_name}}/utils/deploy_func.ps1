param ($shortLoaction, $environment, $folderName)
try {
    

if ($shortLoaction -and $environment) {
    Write-Host 'location: ' $shortLoaction
    Write-Host 'environment: ' $environment
}
else {
    throw 'No values given for location and environment. Please give location and environment as cmd inputs, e.g. file.ps1 neu dev'
}

Write-Host 'Collecting variables from conf file'
Foreach ($i in $(Get-Content secrets.conf)){
    Set-Variable -Name $i.split("=")[0] -Value $i.split("=",2)[1]
}

Write-Host 'Logging into Azure using the browser'
Connect-AzAccount -TenantId $TenantId  -Subscription $Subscription

$ResourceGroupName = $ResourceGroupName + '-' + $shortLoaction + '-' + $environment

Write-Host "Setting resource group to $ResourceGroupName"

Set-AzDefault -ResourceGroupName $ResourceGroupName

$funcName = 'func-'+$projectName+ '-' + $shortLoaction + '-' + $environment+'-001'

$path = '.\' + $folderName

Set-Location $path

func azure functionapp publish $funcName

}
catch {
    throw $_
}
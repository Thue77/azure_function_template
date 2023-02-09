param ($shortLoaction, $environment, $mode)

if ($shortLoaction -and $environment) {
    Write-Host 'location: ' $shortLoaction
    Write-Host 'environment: ' $environment
}
else {
    throw 'No values given for location and environment. Please give location and environment as cmd inputs, e.g. file.ps1 neu dev'
}

if ($mode) {
    Write-Host 'Deployment with mode' $mode
}
else {
    $mode = 'Incremental'
    Write-Host 'Default mode used'
}

Write-Host 'Collecting variables from conf file'
Foreach ($i in $(Get-Content secrets.conf)){
    Set-Variable -Name $i.split("=")[0] -Value $i.split("=",2)[1]
}

Write-Host 'Logging into Azure using the browser'
Connect-AzAccount -TenantId $TenantId  -Subscription $Subscription

$ResourceGroupName = 'rg-' + $projectName + '-' + $shortLoaction + '-' + $environment

Write-Host "Setting resource group to $ResourceGroupName"

Set-AzDefault -ResourceGroupName $ResourceGroupName

Write-Host 'Deploying with confirm'

# New-AzResourceGroupDeployment -TemplateFile $TemplateFile -Confirm -HomeIp $HomeIp -WorkIp $WorkIp -azureADObjectID $azureADObjectID -projectName $projectName



New-AzResourceGroupDeployment -TemplateFile $TemplateFile -Confirm  -azureADObjectID $azureADObjectID -projectName $projectName -shortLocation $shortLoaction -Mode $mode


# Write-Host 'List of resources in resource group'

# Get-AzResource -ResourceGroupName $ResourceGroupName



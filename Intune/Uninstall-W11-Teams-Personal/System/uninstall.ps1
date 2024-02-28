<#
.DESCRIPTION
    Uninstalls the "MicrosoftTeams" app package.
    That means the private/home use Teams version that is preinstalled on Win11.
    This script is meant to run as a Software Uninstallation script using Microsoft Intune.
#>

$PackageName = "MicrosoftTeams"
Get-AppxPackage -Name $PackageName -AllUsers | Remove-AppxPackage
Get-AppXProvisionedPackage -Online | Where-Object {$_.DisplayName -eq $PackageName} | Remove-AppxProvisionedPackage -Online
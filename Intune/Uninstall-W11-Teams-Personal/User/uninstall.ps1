<#
.DESCRIPTION
    Uninstalls the "MicrosoftTeams" app package for the current user.
    That means the private/home use Teams version that is preinstalled on Win11.
    This script is meant to run as a Software Uninstallation script using Microsoft Intune.
#>

$PackageName = "MicrosoftTeams"
Get-AppXPackage -Name $PackageName | Remove-AppxPackage
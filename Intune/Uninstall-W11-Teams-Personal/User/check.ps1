<#
.DESCRIPTION
    Checks if the "MicrosoftTeams" app package is installed for the current user.
    That means the private/home use Teams version that is preinstalled on Win11.
    This script is meant to run as a Software Installation Status script using Microsoft Intune.
#>

$PackageName = "MicrosoftTeams"
if(Get-AppXPackage -Name $PackageName) {
    # if this hits true we detected the app
    "Found $PackageName"
    exit 0
}
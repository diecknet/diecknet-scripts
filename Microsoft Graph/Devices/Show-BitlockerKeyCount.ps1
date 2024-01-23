<#
.SYNOPSIS
    Shows how many Bitlocker infos are saved in Entra ID. 
.EXAMPLE
    .\Show-BitlockerKeyCount.ps1
    Outputs a text like this: "Found 42 Bitlocker Keys in Entra ID"
.EXAMPLE
    .\Show-BitlockerKeyCount.ps1 -Silent
    Returns a value like this: 42
.LINK
    https://github.com/diecknet/diecknet-scripts
#>

#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication";      ModuleVersion="2.5.0" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Identity.SignIns";    ModuleVersion="2.5.0" }

param([switch]$Silent)
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Identity.SignIns

# If we're not connected with the Bitlocker Scope yet -> connect.
if((Get-MgContext).Scopes -notcontains "BitLockerKey.ReadBasic.All") {
    Connect-MgGraph -NoWelcome -Scopes "BitLockerKey.ReadBasic.All"
}

# Get all Bitlocker Key entries and count them
### Note for the future: Maybe also use Group-Object here if multiple keys for one device are problematic
[int]$BitlockerCount = Get-MgInformationProtectionBitlockerRecoveryKey -Property "DeviceId" -All | Measure-Object | Select-Object -ExpandProperty Count

if($silent -ne $true) {
    # If Silent mode is not enabled output info here
    Write-Host "Found $BitlockerCount Bitlocker Keys in Entra ID"
} else {
    # If Silent mode is enabled, just return the value
    return $BitlockerCount
}




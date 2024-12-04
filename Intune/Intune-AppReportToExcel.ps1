<#
.SYNOPSIS
    Generates an Intune App Report.

.DESCRIPTION
    This script generates a report of Intune apps. It lists which apps are assigned to which groups 
    including the mode (required, available, uninstall) and whether the app is included or excluded.

.LINK
    https://github.com/diecknet/diecknet-scripts/tree/main/Intune/Intune-AppReportToExcel.ps1

.NOTES
    Version:        1.3.0
    Author:         Andreas Dieckmann
    Changed Date:   2024-12-04
    Purpose/Change: Create tables in Excel for better sorting and filtering

.PARAMETER SkipAuth
    (Optional) Specifies whether to skip the authentication process.

.PARAMETER FilePath
    (Optional) Specifies the path to the output file.

.EXAMPLE
    PS C:\> .\Intune-AppReportToExcel.ps1
    Generates an Intune app report.

.EXAMPLE
    PS C:\> .\Intune-AppReportToExcel.ps1 -FilePath "C:\MyFolder\MyIntuneReport.xlsx"
    Generates an Intune app report and saves it to the specified file location.

.EXAMPLE
    PS C:\> .\Intune-AppReportToExcel.ps1 -SkipAuth
    Generates an Intune app report without performing the authentication process.

.EXAMPLE
    PS C:\> .\Intune-AppReportToExcel.ps1 -Verbose
    Generates an Intune app report and displays verbose output.

#>
[CmdletBinding()]
param(
    [switch]$SkipAuth,
    [Parameter(Mandatory=$false)]
    [string]$FilePath = "C:\temp\IntuneApps.xlsx"
)

#Requires -Modules @{ ModuleName="ImportExcel"; ModuleVersion="7.8.9" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Authentication"; ModuleVersion="2.21.1" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Beta.Devices.CorporateManagement"; ModuleVersion="2.21.1" }
#Requires -Modules @{ ModuleName="Microsoft.Graph.Groups"; ModuleVersion="2.21.1" }

#region functions
function Get-GroupNameById {
    param($GroupId)
    try {
        Get-MgGroup -GroupId $GroupId -ErrorAction Stop | Select-Object -ExpandProperty DisplayName
    } catch {
        "!Deleted Group (ID: $GroupId)"
    }
}

function Get-Apps {

    $GraphParams = @{
        Filter = "(microsoft.graph.managedApp/appAvailability eq null or microsoft.graph.managedApp/appAvailability eq 'lineOfBusiness' or isAssigned eq true)"
        Sort = "displayName"
        Property = "Id, DisplayName"
        All = $true
    }
    
    $AllApps = Get-MgBetaDeviceAppManagementMobileApp @GraphParams
    
    foreach($App in $AllApps) {
        Write-Verbose "Processing $($App.DisplayName)"
        Write-Verbose "-------------------------------------------------"

        $Assignments = foreach($Assignment in Get-MgDeviceAppManagementMobileAppAssignment -MobileAppId $App.Id) {
            <# observations regarding the assignment ids:
                   All Devices = adadadad-808e-44e2-905a-0b7873a8a531_*
                   All Users   = acacacac-9df4-4c7d-9d50-4ef0226f57a9_*
                   Suffix: 1_* = Required
                   Suffix: 0_* = Available
                   Suffix: 2_* = Uninstall
                   Suffix: *_1 = Excluded
                   Suffix: *_0 = Included
            #>
            Write-Verbose $Assignment.Target.AdditionalProperties["@odata.type"]
            Write-Verbose "Group ID: $($Assignment.Target.AdditionalProperties.groupId)"

            switch($Assignment.Target.AdditionalProperties["@odata.type"]) {
                "#microsoft.graph.allDevicesAssignmentTarget" {
                    $GroupName = "All Devices"
                    $GroupMode = "Included"
                }
                "#microsoft.graph.groupAssignmentTarget" {
                    $GroupName = Get-GroupNameById -GroupId $Assignment.Target.AdditionalProperties.groupId
                    $GroupMode = "Included"
                }
                "#microsoft.graph.exclusionGroupAssignmentTarget" {
                    $GroupName = Get-GroupNameById -GroupId $Assignment.Target.AdditionalProperties.groupId
                    $GroupMode = "Excluded"
                }
                "#microsoft.graph.allLicensedUsersAssignmentTarget" {
                    $GroupName = "All Users"
                    $GroupMode = "Included"
                }
            }
            # this is getting outputted to the loop $Assignments = ...
            [PSCustomObject]@{
                Name = $GroupName
                Intent = $Assignment.intent
                Mode = $GroupMode
            }
        }
    
        # this is getting outputted to the loop $AllAppAssignmentsByApp = ...
        [PSCustomObject]@{
            AppId = $App.Id
            Name = $App.DisplayName
            Included_Required = ($Assignments | Where-Object { $_.Intent -eq "required" -and $_.Mode -eq "Included"} | Select-Object -ExpandProperty Name) -join ", "
            Included_Available = ($Assignments | Where-Object { $_.Intent -eq "available" -and $_.Mode -eq "Included"} | Select-Object -ExpandProperty Name) -join ", "
            Included_Uninstall = ($Assignments | Where-Object { $_.Intent -eq "uninstall" -and $_.Mode -eq "Included"} | Select-Object -ExpandProperty Name) -join ", "
            Excluded_Required = ($Assignments | Where-Object { $_.Intent -eq "required" -and $_.Mode -eq "Excluded"} | Select-Object -ExpandProperty Name) -join ", "
            Excluded_Available = ($Assignments | Where-Object { $_.Intent -eq "available" -and $_.Mode -eq "Excluded"} | Select-Object -ExpandProperty Name) -join ", "
            Excluded_Uninstall = ($Assignments | Where-Object { $_.Intent -eq "uninstall" -and $_.Mode -eq "Excluded"} | Select-Object -ExpandProperty Name) -join ", "
    
            # never seen that before, but apparently it exists: 
            AvailableWithoutEnrollment = ($Assignments | Where-Object { $_.Intent -eq "availableWithoutEnrollment"} | Select-Object -ExpandProperty Name) -join ", "
        }
    
    }
}

function Get-AppsForGroups {
    $UsedGroups = $AllAppAssignmentsByApp | ForEach-Object {
        $_.PSObject.Properties | Where-Object { $_.Name -like "Included_*" -or $_.Name -like "Excluded_*" } | ForEach-Object {
            $_.Value
        }
    } | Select-Object -Unique | Where-Object { $_ -ne "" }
    
    foreach ($Group in $UsedGroups) {
        $IncludedRequired = $AllAppAssignmentsByApp | Where-Object { $_.Included_Required -like "*$Group*" } | Select-Object -ExpandProperty Name
        $IncludedAvailable = $AllAppAssignmentsByApp | Where-Object { $_.Included_Available -like "*$Group*" } | Select-Object -ExpandProperty Name
        $IncludedUninstall = $AllAppAssignmentsByApp | Where-Object { $_.Included_Uninstall -like "*$Group*" } | Select-Object -ExpandProperty Name
        $ExcludedRequired = $AllAppAssignmentsByApp | Where-Object { $_.Excluded_Required -like "*$Group*" } | Select-Object -ExpandProperty Name
        $ExcludedAvailable = $AllAppAssignmentsByApp | Where-Object { $_.Excluded_Available -like "*$Group*" } | Select-Object -ExpandProperty Name
        $ExcludedUninstall = $AllAppAssignmentsByApp | Where-Object { $_.Excluded_Uninstall -like "*$Group*" } | Select-Object -ExpandProperty Name
    
        [PSCustomObject]@{
            Name = $Group
            IncludedRequired = $IncludedRequired -join ", "
            IncludedAvailable = $IncludedAvailable -join ", "
            IncludedUninstall = $IncludedUninstall -join ", "
            ExcludedRequired = $ExcludedRequired -join ", "
            ExcludedAvailable = $ExcludedAvailable -join ", "
            ExcludedUninstall = $ExcludedUninstall -join ", "
        }
    
    }
}
#endregion

#region check target dir
try {
    if(Test-Path (Split-Path -Path $FilePath)) {
        Write-Verbose "Target directory exists"
    } else {
        Write-Verbose "Target directory does not exist"
        Write-Verbose "Creating target directory"
        New-Item -Path (Split-Path -Path $FilePath) -ItemType Directory
    }
} catch {
    Write-Error "Failed to find or create target directory"
    Write-Error $_.Exception.Message
    throw
}
#endregion check target dir

#region setup
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Beta.Devices.CorporateManagement
Import-Module ImportExcel
Import-Module Microsoft.Graph.Groups

if(!$SkipAuth) {
    Connect-MgGraph -Scopes "DeviceManagementApps.Read.All","Group.Read.All"
}
#endregion

#region gather data
# All Apps with their assignments
$AllAppAssignmentsByApp = Get-Apps

# All Groups with their assignments
$AllAppAssignmentsByGroup = Get-AppsForGroups
#endregion

#region export excel
try {
    $AllAppAssignmentsByApp | Export-Excel -Path $FilePath -WorksheetName "Apps Overview" -ClearSheet -TableName "Apps_Overview" -TableStyle "Medium15" -AutoSize -AutoFilter
    $AllAppAssignmentsByGroup | Export-Excel -Path $FilePath -WorksheetName "Apps per Group" -ClearSheet -TableName "Apps_per_Group" -TableStyle "Medium15" -AutoSize -AutoFilter
    Write-Output "Exported data to $FilePath"
} catch {
    Write-Error "Failed to export data to Excel"
    Write-Error $_.Exception.Message
    throw
}
#endregion
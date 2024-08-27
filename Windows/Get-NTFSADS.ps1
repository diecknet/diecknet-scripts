<#
.SYNOPSIS
Retrieves NTFS Alternate Data Streams (ADS) for elements in a specified directory.

.DESCRIPTION
This script scans a specified directory (and optionally its subdirectories) for NTFS Alternate Data Streams (ADS). It lists the streams associated with each file, excluding the default data stream unless specified otherwise.

.PARAMETER Path
The path to the directory to scan for NTFS Alternate Data Streams. Defaults to the user's Downloads folder if not specified.

.PARAMETER Recurse
A switch parameter that, if specified, causes the script to scan subdirectories recursively.

.PARAMETER ShowElementsWithDataStreamToo
A switch parameter that, if specified, includes elements with the default data stream in the output.

.EXAMPLE
PS> .\Get-NTFSADS.ps1 -Path "C:\Users\Example\Documents" -Recurse
Scans the "C:\Users\Example\Documents" directory and its subdirectories for NTFS Alternate Data Streams.

.EXAMPLE
PS> .\Get-NTFSADS.ps1 -ShowElementsWithDataStreamToo
Scans the default Downloads directory and includes elements with the default data stream in the output.

.INPUTS
None. You cannot pipe objects to Get-NTFSADS.ps1.

.OUTPUTS
PSCustomObject. Outputs custom objects with the properties:
- Name: The full path of the file.
- Streams: A list of alternate data streams associated with the file.

.NOTES
Version:        1.0
Author:         Andreas Dieckmann
Creation Date:  2024-08-27
Purpose/Change: Initial script development

#>
param(
    [Parameter(Mandatory=$false)]
    [string]$Path = "$($env:USERPROFILE)\Downloads",
    [switch]$Recurse,
    [switch]$ShowElementsWithDataStreamToo
)

if(!(Test-Path $Path)) {
    throw "Could not access the path '$Path'. Please check the path and try again."
}

$Data = Get-ChildItem $Path -Recurse:$Recurse
foreach($Element in $Data) {

    $Streams = Get-Item $Element -Stream * 
    if(!$ShowElementsWithDataStreamToo) {
        $Streams = $Streams | Where-Object {$_.Stream -ne ':$DATA' }
    }

    if($Streams) {
        [PSCustomObject]@{
            Name = $Element.FullName
            Streams = ($Streams | ForEach-Object { $_.Stream })
        }
    }

}
<#
.SYNOPSIS
Converts an Edit Decision List (EDL) file to timestamps and titles.

.DESCRIPTION
This script reads an EDL file specified by the user and extracts timestamps and titles from it. 
I created this to create chapters by adding the timestamps a YouTube video description.

.PARAMETER Path
The path to the EDL file that should be processed. This parameter is mandatory.

.EXAMPLE
PS> .\Convert-EDL2Timestamp.ps1 -Path "C:\path\to\your\file.edl"
This command reads the EDL file located at "C:\path\to\your\file.edl" and outputs the extracted timestamps and titles.

.INPUTS
None. You cannot pipe objects to Convert-EDL2Timestamp.ps1.

.OUTPUTS
String. Outputs strings that combine a timestamp and a title, separated by a space.

.NOTES
Version:        1.0
Author:         Andreas Dieckmann
Creation Date:  2024-06-18
Purpose/Change: Initial script development

.LINK
https://github.com/diecknet/diecknet-scripts/Video%20Editing/Convert-EDL2Timestamp.ps1
#>

[CmdletBinding()]
param(  [Parameter(Mandatory=$true)]
        [Alias("File")]
        [String]
        $Path
)

begin {
    $EDLFileContent = Get-Content -Path $Path -ErrorAction Stop -Encoding UTF8
}

process {
    $Result = for($i = 0; $i -lt ($EDLFileContent | Measure-Object).Count ; $i++){
        $Title = $null # Reset title
        if($EDLFileContent[$i] -match "^\d{3}\s+\d{3}.+?(\d{2}:\d{2}:\d{2})") {
            $Timestamp = $Matches[1]
            Write-Verbose "Found timestamp on line ${i}: $Timestamp"
            $i++ # Move to next line
            if($EDLFileContent[$i] -match "\|M:(.+?) \|") {
                $Title = $Matches[1]
                Write-Verbose "Found title on line ${i}: $Title"
            }
            "$Timestamp $Title" # output to the loop
        }
    }
}

end {
    $Result # output/return the result
}
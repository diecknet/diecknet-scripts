<#
.SYNOPSIS
    This script moves Active Directory computer objects based on a configuration file.

.DESCRIPTION
    The script reads a configuration file to determine source OUs and target OUs.
    It then fetches computer objects from the source OUs and moves them to the target OUs
    based on specified regular expressions.

.EXAMPLE
    Move-ComputerObjects.ps1

    This will run the script with the default configuration file "Move-ComputerObjects-config.psd1"
    located in the same directory as the script.

.EXAMPLE
    Move-ComputerObjects.ps1 -Verbose

    This will run the script and show verbose messages.

.NOTES
    Author: Andreas Dieckmann
    Date: 2024-09-05
    Version: 1.0

.LINK
    https://github.com/diecknet/diecknet-scripts/tree/main/Active%20Directory%20Domain%20Services/Move%20Computer%20Objects
#>

[CmdletBinding()]
param()

if([string]::IsNullOrEmpty($PSScriptRoot)) {
    $LogDirectory = "C:\Tools\Move-ADComputer\Logs\"
} else {
    $LogDirectory = Join-Path -Path $PSScriptRoot -ChildPath "Logs"
}

Start-Transcript -OutputDirectory $LogDirectory -Force

Write-Verbose "Trying to load config file $($ConfigFilePath)"
try {
    $ConfigFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Move-ComputerObjects-config.psd1"
    $Config = Import-PowerShellDataFile $ConfigFilePath
} catch {
    throw "Error while trying to load config file $($ConfigFilePath). Details:`r`n$_"
}

foreach($Source in $Config["Sources"]) {
    Write-Verbose "Fetching Source Computers from $Source"
    $Computers = Get-ADComputer -Filter * -SearchBase $Source -SearchScope OneLevel
    foreach($Computer in $Computers) {
        Write-Verbose "Processing Computer $($Computer.Name)"
        :Targets foreach($Target in $Config["Targets"]) {
            Write-Verbose "Validating Target RegEx $($Target["RegEx"]) against Computername $($Computer.Name)"
            if($Computer.Name -match $Target["RegEx"]) {
                Write-Verbose "RegEx $($Target["RegEx"]) matched. Moving Computer '$($Computer.Name)' to $($Target["TargetOU"])"
                Move-ADObject -Identity $Computer.DistinguishedName -TargetPath $Target["TargetOU"]
                break :Targets # go to next computer
            }
        }
    }
}

Write-Verbose "Checking for older log files to delete..."
Get-ChildItem $LogDirectory -Filter *.txt | 
    Where-Object {$_.CreationTime -lt (Get-Date).AddDays(-$Config["Log"]["DaysToKeep"])} |
    Foreach-Object {
        Write-Verbose "Removing old log file $($_.Name) (Date = $($_.CreationTime)"
        Remove-Item $_.FullName
    }

Stop-Transcript
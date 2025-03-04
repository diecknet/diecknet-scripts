<#
.DESCRIPTION
    This is a very basic example for an Intune detection script.
    It checks if a file exists on the system.
.LINK
    https://github.com/diecknet/diecknet-scripts/tree/main/Intune/Detection-Remediation-Template
#>

if (Test-Path "C:\temp\example.txt") {
    <#
        If the file exists, the script outputs text and exits with code 0. 
        Intune will consider this a successful detection. 
        So the remediation will not get executed.
    #>
    Write-Output "File exists, no remediation needed"
    exit 0

} else {
    <#
        If the file does NOT exist, the script outputs text and exits with code 1. 
        Intune will consider this a NON-successfull detection. 
        So the REMEDIATION WILL get executed.
    #>
    Write-Output "File does not exist, remediation needed"
    exit 1
}
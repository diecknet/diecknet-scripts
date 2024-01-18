<#
.SYNOPSIS
    Exports a list of Active Directory Computer Accounts to a CSV file.
.LINK
    https://github.com/diecknet/diecknet-scripts
#>
Get-ADComputer -ResultSetSize $null -Filter * -Properties LastLogonDate | Select-Object -Property Name,DNSHostName,LastLogonDate | Export-Csv "$(Get-Date -Format "yyyy-MM-dd_HHmmss")_ADComputer.csv" -NoTypeInformation -Encoding utf8
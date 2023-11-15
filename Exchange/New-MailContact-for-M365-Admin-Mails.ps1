<#
.SYNOPSIS
    Creates a MailContact in Exchange to forward all mails from an admin user to a normal user.
.DESCRIPTION
    Creates a MailContact in Exchange to forward all mails from an admin user to a normal user.
    The MailContact is initially created with temporary values, which will get replaced afterwards.
    The final MailContact is hidden from the address list and has no email address policy.
    This is useful if your admin user has no Exchange license.
    The script can be used on-premises and in Exchange Online. If you're using Exchange Hybrid, you probaly want to execute it On-Premises.

    .EXAMPLE
    .\New-MailContact-for-M365-Admin-Mails.ps1 -AdminUPN myadmin@diecknetdemotenant.onmicrosfot.com -NormalUserEmail mynormaluser@demotenant.de

.PARAMETER AdminUPN
    The UPN of the admin user, whose mails should be forwarded.

.PARAMETER NormalUserEmail
    The email address of the normal user, who should receive the forwarded mails.

.PARAMETER AdminUserName
    Optional. The name of the admin user, whose mails should be forwarded. 
    Gets used in the DisplayName of the mail contact and as part of the alias if the alias was not specified manually.

.PARAMETER ContactDisplayName
    Optional. The display name of the mail contact.

.PARAMETER ContactAlias
    Optional. The alias of the mail contact. 
    If not specified, the alias will be generated from the AdminUserName with the prefix "forward-".

.PARAMETER tempExternalEmailAddress
    Optional. The TEMPORARY external email address of the mail contact. 
    If not specified, the external email address will be generated from the AdminUPN with the prefix "forward-".
    This external email address will only be used TEMPORARILY and then replaced with the NormalUserEmail.

.LINK
    https://github.com/diecknet/diecknet-scripts/Exchange/MailContact-for-M365-Admin-Mails.ps1

.LINK
    https://diecknet.de

.NOTES
    Tested with Exchange Server 2016 and Exchange Online PowerShell v3
    Author: Andreas Dieckmann / diecknet
    Licensed under MIT License: https://github.com/diecknet/diecknet-scripts/blob/main/LICENSE

    Script Change Log:
    2023-11-15: Initial release
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    $AdminUPN,
    [Parameter(Mandatory=$true)]
    $NormalUserEmail,

    [Parameter(Mandatory=$false)]
    $AdminUserName,
    [Parameter(Mandatory=$false)]
    $ContactDisplayName,
    [Parameter(Mandatory=$false)]
    $ContactAlias,
    [Parameter(Mandatory=$false)]
    $tempExternalEmailAddress
)

Write-Verbose "Script started."
Write-Verbose "AdminUPN: $AdminUPN"
Write-Verbose "NormalUserEmail: $NormalUserEmail"

if ([string]::IsNullOrWhiteSpace($AdminUserName)) {
    Write-Verbose "No AdminUserName provided, using UPN to generate it"
    $AdminUserName = ($AdminUPN -split "@")[0]
}
Write-Verbose "AdminUserName: $AdminUserName"

if([string]::IsNullOrWhiteSpace($ContactDisplayName)) {
    Write-Verbose "No ContactDisplayName provided, using standard text with AdminUserName"
    $ContactDisplayName = "Forward to $AdminUserName (Admin E-Mails)"
}
Write-Verbose "ContactDisplayName: $ContactDisplayName"

if([string]::IsNullOrWhiteSpace($ContactAlias)) {
    Write-Verbose "No ContactAlias provided, using AdminUserName with default prefix 'forward-'"
    $ContactAlias = "forward-$AdminUserName"
}
Write-Verbose "ContactAlias: $ContactAlias"

if([string]::IsNullOrWhiteSpace($tempExternalEmailAddress)) {
    Write-Verbose "No tempExternalEmailAddress provided, using AdminUPN with default prefix 'forward-'"
    $tempExternalEmailAddress = "forward-$AdminUPN"
}

$contact = New-MailContact -Name $ContactDisplayName -Alias $ContactAlias -ExternalEmailAddress $tempExternalEmailAddress

# the -EmailAddressPolicyEnabled parameter is only available on-premises, so we check if the parameter is available before using it
if((Get-Command Set-MailContact).Parameters["EmailAddressPolicyEnabled"]) {
    Set-MailContact -Identity $contact -EmailAddressPolicyEnabled:$false
}
Set-MailContact -Identity $contact -EmailAddresses $AdminUPN -ExternalEmailAddress $NormalUserEmail -HiddenFromAddressListsEnabled $true

return (Get-Contact -Identity $contact)
function Get-ADObjectByImmutableID {
    <#
    .SYNOPSIS
    Get an AD object by its ImmutableID
    
    .DESCRIPTION
    This function retrieves an AD object by its ImmutableID
    
    .PARAMETER ImmutableID
    The ImmutableID of the object to find
    
    .PARAMETER SearchBase
    The search base to use for the search
    
    .EXAMPLE
    Get-ADObjectByImmutableID -ImmutableID "AvbZABkNi0yoPrbFBLPDpQ=="
    
    .EXAMPLE
    Get-ADObjectByImmutableID -ImmutableID "AvbZABkNi0yoPrbFBLPDpQ==" -SearchBase "OU=Testkreis,DC=demotenant,DC=de"
    
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$ImmutableID,
        [string]$SearchBase
    )

    # Convert Immutable ID to Byte Array
    $ByteArray = [system.convert]::FromBase64String($ImmutableID)
    $BytesHex = "\"+([BitConverter]::ToString($ByteArray) -split "-" -join "\")

    # Define parameters for Get-ADObject
    $ADParameter = @{
        LDAPFilter = "(mS-DS-ConsistencyGuid=$($BytesHex))"
    }
    # Optional parameter: SearchBase
    if($SearchBase) {
        $ADParameter["SearchBase"] = $SearchBase
    }
    
    # Get AD object
    Get-ADObject @ADParameter
}
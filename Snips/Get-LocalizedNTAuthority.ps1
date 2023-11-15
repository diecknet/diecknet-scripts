# Get the localized name of "NT AUTHORITY\SYSTEM" for the current user's language
# for example on German System it would return "NT-AUTORITÄT\SYSTEM"	
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-18")).Translate([System.Security.Principal.NTAccount]).Value

# Get the localized name of "NT AUTHORITY\SELF" for the current user's language
# for example on German System it would return "NT-AUTHORITÄT\SELBST"
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-10")).Translate([System.Security.Principal.NTAccount]).Value
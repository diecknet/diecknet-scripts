# Get the localized name of "NT AUTHORITY\SYSTEM" for the current user's language
# for example on German System it would return "NT-AUTORITÄT\SYSTEM"	
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-18")).Translate([System.Security.Principal.NTAccount]).Value

# Get the localized name of "NT AUTHORITY\SELF" for the current user's language
# for example on German System it would return "NT-AUTHORITÄT\SELBST"
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-10")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\NETWORK SERVICE
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-20")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\LOCAL SERVICE
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-19")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\IUSR
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-17")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\This Organization
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-15")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\REMOTE INTERACTIVE LOGON
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-14")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\TERMINAL SERVER USER
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-13")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\RESTRICTED
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-12")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\Authenticated Users
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-11")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\ENTERPRISE DOMAIN CONTROLLERS
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-9")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\PROXY
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-8")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\ANONYMOUS LOGON
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-7")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\SERVICE
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-6")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\INTERACTIVE
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-4")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\BATCH
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-3")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\NETWORK
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-2")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\DIALUP
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-1")).Translate([System.Security.Principal.NTAccount]).Value

# NT AUTHORITY\ENTERPRISE READ-ONLY DOMAIN CONTROLLERS BETA
([System.Security.Principal.SecurityIdentifier]::new("S-1-5-22")).Translate([System.Security.Principal.NTAccount]).Value

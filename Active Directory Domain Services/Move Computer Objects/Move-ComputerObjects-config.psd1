@{
    Sources = @('CN=Computers,DC=lan,DC=demotenant,DC=de')
    Targets = @(
        @{
            RegEx = '^CL.+'
            TargetOU = 'OU=Computer,OU=Demotenant,DC=lan,DC=demotenant,DC=de'
        },
        @{
            RegEx = '^EU.+'
            TargetOU = 'OU=Testkreis,DC=lan,DC=demotenant,DC=de'
        }
    )
    Log = @{
        DaysToKeep = 30
    }
}
$Daten = Get-ChildItem C:\users\diecknet\Downloads\
foreach($Element in $Daten) {
    [PSCustomObject]@{
        Name = $Element.FullName
        Streams = (
            Get-Item $Element -Stream * | 
                Where-Object {$_.Stream -ne ':$DATA' } |
                ForEach-Object { $_.Stream }
        )
    }
}
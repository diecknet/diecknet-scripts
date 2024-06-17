function Get-ExampleObjects {
    [PSCustomObject]@{
            Name = "Value123"
            Id   = 123
        }, [PSCustomObject]@{
            Name = "Value456"
            Id   = $null
        }
}
$Objects = Get-ExampleObjects

Write-Host "Test with `$null on the right: " -NoNewline
if($Objects.Id -eq $null) {
    "TRUE"
} else {
    "FALSE"
}

Write-Host "Test with `$null on the left:  " -NoNewline
if($null -eq $Objects.Id) {
    "TRUE"
} else {
    "FALSE"
}

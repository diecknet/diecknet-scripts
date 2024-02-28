### BEGIN CONFIG
$ServiceName = "dot3svc"
### END CONFIG


$ServiceInfo = Get-Service -Name $ServiceName

# Output info for monitoring
"Service StartType = $($ServiceInfo.StartType), Service Status = $($ServiceInfo.Status)"

# exit with 1 if we need to remediate
if($ServiceInfo.StartType -ne "Automatic") {
    if($ServiceInfo.Status -eq "Stopped") {
        exit 1
    }
    exit 1
}

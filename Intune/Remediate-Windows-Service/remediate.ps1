### BEGIN CONFIG
$ServiceName = "dot3svc"
### END CONFIG

Set-Service -Name $ServiceName -StartupType Automatic
Start-Service -Name $ServiceName
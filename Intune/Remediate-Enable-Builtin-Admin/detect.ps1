$BuiltinAdmin = Get-LocalUser | Where-Object {$_.Sid -like "*-500" }

# Output info for monitoring
"Username=$($BuiltinAdmin.Name), Enabled=$($BuiltinAdmin.Enabled)"

# exit with 1 if we need to remediate
if($BuiltinAdmin.Enabled -eq $false) {
    exit 1
}
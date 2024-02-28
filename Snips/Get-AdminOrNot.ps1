# PowerShell 7.4+
[System.Environment]::IsPrivilegedProcess

# PowerShell 5.1 (Windows only)
[Security.Principal.WindowsIdentity]::GetCurrent().Groups -contains 'S-1-5-32-544'

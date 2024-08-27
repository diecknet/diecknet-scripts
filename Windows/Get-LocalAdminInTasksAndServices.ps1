<#
.SYNOPSIS
This script checks for services and scheduled tasks that are configured to run under the built-in Administrator account.

.DESCRIPTION
The script retrieves the name of the built-in Administrator account and then checks all services and scheduled tasks on the local machine. It identifies any services or tasks that are configured to run under the built-in Administrator account and displays the corresponding information.

.NOTES
File Name: Get-LocalAdminInTasksAndServices.ps1
Author: Andreas Dieckmann
Date: 2024-08-08

.EXAMPLE
PS C:\> .\Get-LocalAdminInTasksAndServices.ps1
This example runs the script and displays any services or scheduled tasks that are configured to run under the built-in Administrator account.

#>

#region Get Built-in Administrator
$BuiltinAdmin = Get-LocalUser | Where-Object {$_.Sid -like "*-500" }
$BuiltInAdminName = $BuiltinAdmin.Name
$BuiltinAdminDotName = ".\$($BuiltInAdminName)"
#endregion

#region Check Services
$services = Get-WmiObject -Class Win32_Service

foreach ($service in $services) {
    if($service.StartName -eq $BuiltinAdminDotName) {
        "Service: $($service.Name) is configured to run as $($BuiltinAdminDotName)"
    }
}
#endregion

#region Check Scheduled Tasks
$scheduledTasks = Get-ScheduledTask

foreach ($task in $scheduledTasks) {
    $taskPrincipal = $task.Principal
    #if ($taskPrincipal.LogonType -eq "Password") {
        $taskUsername = $taskPrincipal.UserId
        if ($taskUsername -eq $BuiltinAdminName) {
            "Scheduled Task: $($task.TaskName) is configured to run as $($BuiltinAdminName)"
        }
    #}
}
#endregion
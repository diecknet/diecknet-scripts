function Measure-CommandMultipleTimes {
    <#
    .SYNOPSIS
    Measures the execution time of a script block multiple times.

    .DESCRIPTION
    Measures the execution time of a script block multiple times. The result is a simple overview of the average, maximum and minimum duration.

    .PARAMETER ScriptBlock
    The script block that should be executed multiple times.

    .PARAMETER Count
    The number of times the script block should be executed.

    .EXAMPLE
    Measure-CommandMultipleTimes -ScriptBlock { Get-Process } -Count 10
    Measure the execution time of Get-Process 10 times.

    .EXAMPLE
    Measure-CommandMultipleTimes -ScriptBlock { Get-Process }
    Measure the execution time of Get-Process 1000 times.

    .NOTES
    Name: Measure-CommandMultipleTimes

    .LINK
    https://github.com/diecknet/diecknet-scripts/tree/main/Utilities/Measure-CommandMultipleTimes.ps1
    #>

    [CmdletBinding()]
    param(
        [ScriptBlock]$ScriptBlock,
        [int]$Count = 1000
    )

    $AllTests = [System.Collections.Generic.List[PSObject]]::new()

    for($i = 0; $i -lt $Count; $i++) {
        Write-Debug "Iteration #$i"
        $StopWatch = [System.Diagnostics.Stopwatch]::StartNew()

        $ScriptBlock.Invoke()

        $StopWatch.Stop()
        $AllTests.Add($StopWatch.Elapsed)
    }

    # return simple overview
    return ($AllTests.TotalMilliseconds | Measure-Object -Average -Maximum -Minimum)
}

<#
.SYNOPSIS  Reports drives below a free-space threshold across servers.
.PARAMETER ComputerName     One or more server names. Defaults to local.
.PARAMETER ThresholdPercent Warn below this % free. Default 15.
.EXAMPLE   .\Get-DiskSpaceReport.ps1 -ComputerName SERVER01,SERVER02
.NOTES     Author: Mateusz Dubak. Placeholder server names only.
#>
[CmdletBinding()]
param([string[]]$ComputerName = @($env:COMPUTERNAME), [int]$ThresholdPercent = 15)

$report = foreach ($cn in $ComputerName) {
    try {
        Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" -ComputerName $cn -ErrorAction Stop | ForEach-Object {
            $freePct = if ($_.Size) { [math]::Round(($_.FreeSpace / $_.Size) * 100, 1) } else { 0 }
            [PSCustomObject]@{
                Server = $cn; Drive = $_.DeviceID
                FreeGB = [math]::Round($_.FreeSpace / 1GB, 1)
                SizeGB = [math]::Round($_.Size / 1GB, 1)
                FreePct = $freePct; LowSpace = $freePct -lt $ThresholdPercent
            }
        }
    } catch { Write-Warning "Could not query $cn : $_" }
}
$report | Sort-Object FreePct | Format-Table -AutoSize
$report | Where-Object LowSpace | ForEach-Object {
    Write-Warning "LOW: $($_.Server) $($_.Drive) at $($_.FreePct)% free" }

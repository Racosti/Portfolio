<#
.SYNOPSIS  Builds a summary CSV of device reachability from a device list.
.PARAMETER DeviceList  CSV with columns: Name, IP
.PARAMETER OutputPath  CSV output path. Defaults to .\PrinterStatusReport.csv
.EXAMPLE   .\Get-PrinterStatusReport.ps1 -DeviceList .\samples\devices.csv
.NOTES     Author: Mateusz Dubak. Sample list uses placeholder IPs.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$DeviceList, [string]$OutputPath = ".\PrinterStatusReport.csv")

if (-not (Test-Path $DeviceList)) { Write-Error "Device list not found: $DeviceList"; return }
$devices = Import-Csv $DeviceList
$results = foreach ($d in $devices) {
    $online = Test-Connection -ComputerName $d.IP -Count 1 -Quiet -ErrorAction SilentlyContinue
    [PSCustomObject]@{
        Name = $d.Name; IP = $d.IP
        Status = if ($online) { 'Online' } else { 'Unreachable' }
        CheckedUtc = (Get-Date).ToUniversalTime().ToString('s')
    }
}
$results | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
$results | Format-Table -AutoSize
Write-Host "Status report saved to $OutputPath" -ForegroundColor Green

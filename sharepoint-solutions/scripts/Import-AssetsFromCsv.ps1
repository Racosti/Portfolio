<#
.SYNOPSIS Bulk-imports assets from a CSV into a SharePoint "Assets" list.
.NOTES    Author: Mateusz Dubak. Requires PnP.PowerShell. CSV: AssetTag,Category,Status
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$SiteUrl,
      [Parameter(Mandatory)][string]$CsvPath,
      [string]$ListName = "Assets")

if (-not (Test-Path $CsvPath)) { Write-Error "CSV not found: $CsvPath"; return }
Connect-PnPOnline -Url $SiteUrl -Interactive
$rows = Import-Csv $CsvPath
foreach ($r in $rows) {
    Add-PnPListItem -List $ListName -Values @{
        Title = $r.AssetTag; AssetTag = $r.AssetTag
        Category = $r.Category; Status = $r.Status } | Out-Null
}
Write-Host "Imported $($rows.Count) asset(s)." -ForegroundColor Green

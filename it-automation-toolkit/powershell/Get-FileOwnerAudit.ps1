<#
.SYNOPSIS  Audits who created / last modified files in a given folder.
.PARAMETER Path        Root folder to audit.
.PARAMETER OutputPath  CSV output path. Defaults to .\FileOwnerAudit.csv
.EXAMPLE   .\Get-FileOwnerAudit.ps1 -Path "E:\Common\Documents"
.NOTES     Author: Mateusz Dubak. Read-only. Placeholder paths only.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$Path, [string]$OutputPath = ".\FileOwnerAudit.csv")

if (-not (Test-Path $Path)) { Write-Error "Path not found: $Path"; return }
Write-Host "Auditing $Path ..." -ForegroundColor Cyan
Get-ChildItem -Path $Path -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
    [PSCustomObject]@{
        FileName    = $_.Name
        FullPath    = $_.FullName
        Owner       = (Get-Acl $_.FullName).Owner
        SizeKB      = [math]::Round($_.Length / 1KB, 2)
        CreatedUtc  = $_.CreationTimeUtc
        ModifiedUtc = $_.LastWriteTimeUtc
    }
} | Sort-Object ModifiedUtc -Descending |
    Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "Audit saved to $OutputPath" -ForegroundColor Green

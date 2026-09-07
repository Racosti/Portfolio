<#
.SYNOPSIS  Exports a report of enabled Active Directory users to CSV.
.DESCRIPTION Read-only report of enabled AD users (department, title, last logon).
.PARAMETER SearchBase  Optional OU distinguished name to limit the search.
.PARAMETER OutputPath  CSV output path. Defaults to .\ADUserReport.csv
.EXAMPLE   .\Get-ADUserReport.ps1 -OutputPath .\users.csv
.NOTES     Author: Mateusz Dubak. Requires RSAT ActiveDirectory module.
#>
[CmdletBinding()]
param([string]$SearchBase = "", [string]$OutputPath = ".\ADUserReport.csv")

if (-not (Get-Module -ListAvailable -Name ActiveDirectory)) {
    Write-Error "ActiveDirectory module not found. Install RSAT tools."; return
}
Import-Module ActiveDirectory
$props = 'DisplayName','SamAccountName','Department','Title','Enabled','LastLogonDate','Mail'
$params = @{ Filter = 'Enabled -eq $true'; Properties = $props }
if ($SearchBase) { $params['SearchBase'] = $SearchBase }
Write-Host "Querying Active Directory..." -ForegroundColor Cyan
Get-ADUser @params |
    Select-Object DisplayName, SamAccountName, Department, Title,
                  @{N='LastLogon';E={$_.LastLogonDate}}, Mail |
    Sort-Object Department, DisplayName |
    Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8
Write-Host "Report saved to $OutputPath" -ForegroundColor Green

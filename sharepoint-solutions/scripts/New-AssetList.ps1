<#
.SYNOPSIS Provisions an "Assets" list in SharePoint Online with standard columns.
.NOTES    Author: Mateusz Dubak. Requires PnP.PowerShell. Placeholder site URL.
#>
[CmdletBinding()]
param([Parameter(Mandatory)][string]$SiteUrl, [string]$ListName = "Assets")

Connect-PnPOnline -Url $SiteUrl -Interactive
if (-not (Get-PnPList -Identity $ListName -ErrorAction SilentlyContinue)) {
    New-PnPList -Title $ListName -Template GenericList -OnQuickLaunch
}
Add-PnPField -List $ListName -DisplayName "AssetTag" -InternalName "AssetTag" -Type Text -AddToDefaultView -ErrorAction SilentlyContinue
Add-PnPField -List $ListName -DisplayName "Category" -InternalName "Category" -Type Choice -Choices "Laptop","Phone","Monitor" -AddToDefaultView -ErrorAction SilentlyContinue
Add-PnPField -List $ListName -DisplayName "Status" -InternalName "Status" -Type Choice -Choices "Available","Issued","Repair" -AddToDefaultView -ErrorAction SilentlyContinue
Add-PnPField -List $ListName -DisplayName "IssuedDate" -InternalName "IssuedDate" -Type DateTime -AddToDefaultView -ErrorAction SilentlyContinue
Write-Host "List '$ListName' is ready." -ForegroundColor Green

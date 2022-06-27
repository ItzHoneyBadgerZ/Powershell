#todo switch log to write-verbose with a function
#this is a manual process as written, but it's easily automated if desired. I may upload an automation version of this later.
#requires
# PnP PowerShell - Install-Module PnP.PowerShell
# SharePoint Online PowerShell - Install-Module -Name Microsoft.Online.SharePoint.PowerShell
# Permissions to create and edit sites in SharePoint (Azure SharePoint Admin)
Connect-PnPOnline

$siteName = Read-Host "Enter Site Name: "
$owners = (Read-Host "Enter owners separated with a ';' ").Split(';')
$description = Read-Host "Enter site description or press Enter: "
$addFiles = Read-Host "Do you want to add files to the site? Y/N: "
$externalSharing = Read-Host "Do you want the site to be shared externally? Y/N: "
#feel free to uncomment the below line and comment out upper line for a generic description
#$description = "$siteName Created: $(get-date -Format 'MM/dd/yyyy HH:mm')"

#create site
$teamSiteUrl = New-PnPSite -Type TeamSite -Title $siteName -Alias $siteName -Description $description -Owners $owners

#add external sharing if desired
if($externalSharing -eq "y"){
    $sharingLevel = Read-Host "Do you want ExistingExternalUserSharingOnly, ExternalUserSharingOnly, or ExternalUserAndGuestSharing: "
    $adminUrl = "Enter admin URL i.e. 'https://domain-admin.sharepoint.com': "
    Connect-SPOService -Url $adminUrl
    $confirmedURL = Get-SPOSite -Limit All | ?{$_.title -like "*$SiteName"} | select -ExpandProperty URL
    try{
        Set-SPOSite -Identity $confirmedURL -SharingCapability $sharingLevel
        Write-Host "[+] Added Sharing Capability to the site: $siteName" -ForegroundColor Green
    }catch{
        Write-Host "[!] Unable to add SharingCapability" -ForegroundColor DarkRed
        Write-Host "[!] Error: $Error" -ForegroundColor DarkRed
        $error.Clear()
    }
}

if($addFiles -eq "y"){
    $originalFileLocation = Read-Host "Enter site location for origial files, everything after '/sites/', if your url is https://domain.sharepoint.com/sites/DocumentSite/SharePointDocuments, you'd ender 'DocumentSite/SharePointDocuments': "  
    try{
        Copy-PnPFile -SourceUrl "/sites/$originalFileLocation" -TargetUrl "/sites/$($SiteName)/Shared Documents" -Confirm:$false -force
        Write-Host "[+] Added Help Documents" -ForegroundColor Green
    }
    catch{
        Write-Host "[!] Unable to add Help Documents" -ForegroundColor DarkRed
        Write-Host "[!] Error: $Error" -ForegroundColor DarkRed
        $error.Clear()
    }
}

Write-Host "End of site creation." -ForegroundColor Green

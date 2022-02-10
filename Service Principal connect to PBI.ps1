Set-PSRepository PSGallery -InstallationPolicy Trusted
Install-Module -Name MicrosoftPowerBIMgmt -Scope CurrentUser
Import-Module -Name MicrosoftPowerBIMgmt
 $tenant_id = "##"
 $client_id = "##"
 $client_secret = "##"
 
 [securestring]$sec_client_secret = ConvertTo-SecureString $client_secret -AsPlainText -Force
 [pscredential]$credential = New-Object System.Management.Automation.PSCredential ($client_id, $sec_client_secret)
 Connect-PowerBIServiceAccount -Credential $credential -ServicePrincipal -TenantId $tenant_id
 Write-Information "Connected"

 
 
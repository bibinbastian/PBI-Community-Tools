<# 
    This script helps you to perform backup operations for your Power BI Premium dataset. 
    Read more about this script in this blogpost: https://data-marc.com/2022/02/21/script-and-automate-power-bi-backup-operations/
    Also find related documentation here: 
    https://docs.microsoft.com/en-us/power-bi/admin/service-premium-backup-restore-dataset?WT.mc_id=DP-MVP-5003435&
    https://docs.microsoft.com/en-us/analysis-services/multidimensional-models-scripting-language-assl-xmla/backing-up-restoring-and-synchronizing-databases-xmla?WT.mc_id=DP-MVP-5003435&view=asallproducts-allversions#backing_up_databases
#>

# Run parameters, please specify below parameters
$WorkspaceName = "DEMO%20-%20Backup%20data%20model" # Here specify the workspace name, not the id! Please replace spaces for %20. This is used to concatenate the XMLA endpoint later. 
$DatasetName = "Example Model" # DatasetName to find the dataset and later to be used in backup filename

# Base variables
$PbiBaseConnection = "powerbi://api.powerbi.com/v1.0/myorg/"
$XmlaEndpoint = $PbiBaseConnection + $WorkspaceName

$NamePrefix = Get-Date -Format "yyyyMMdd-HHmmss" #Gets Date and Time on which the backup is performed as prefix to list backups easily in order
$BackupFileName = $NamePrefix + "_" + $DatasetName

# Check whether the SQL Server module is installed. If not, it will be installed.
# Install Module (Admin permissions might be required) 
$moduleName = Get-Module -ListAvailable -Verbose:$false | Where-Object { $_.Name -eq "SqlServer" } | Select-Object -ExpandProperty Name;
if ([string]::IsNullOrEmpty($moduleName)) {
    Write-Host -ForegroundColor White "==============================================================================";
    Write-Host -ForegroundColor White  "Install module SqlServer...";
    Install-Module SqlServer -RequiredVersion 21.1.18230 -Scope CurrentUser -SkipPublisherCheck -AllowClobber -Force
    # Check for the latest version this documentation: https://www.powershellgallery.com/packages/SqlServer/
    Write-Host -ForegroundColor White "==============================================================================";
}

# TMSL Script for backup
$TmslScript = 
@"
{
  "backup": {
    "database": "$DatasetName",
    "file": "$BackupFileName.abf",
    "allowOverwrite": false,
    "applyCompression": true
  }
}
"@

# Execute backup operation
Try {
    Invoke-ASCmd -Query $TmslScript -Server: $XmlaEndpoint
}
Catch{
    # Write message if error
    Write-Host "An error occured" -ForegroundColor Red
}

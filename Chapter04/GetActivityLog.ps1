# Prerequisits - install Powershell Power  Bi modules
#Login-PowerBI

#Install-Module -Name MicrosoftPowerBIMgmt.Profile -Force
#Install-Module -Name SqlServer -Force

# 1. Login to app.power.bi
$user = "xxx"
$pass = "yyy"
 
$SecPasswd = ConvertTo-SecureString $pass -AsPlainText -Force
$myCred = New-Object System.Management.Automation.PSCredential($user,$SecPasswd)
Connect-PowerBIServiceAccount -Credential (Get-Credential)
 
# 2. Get Data from app.powerbi/azure for previous day
$Datum = Get-Date((get-date ).AddDays(-1))  -Format "yyyy-MM-dd"
 
$StartDate = $Datum + 'T00:00:00'
$EndDate = $Datum + 'T23:59:59'
 
 
$json = Get-PowerBIActivityEvent -StartDateTime $StartDate -EndDateTime $EndDate | ConvertFrom-Json
$activity = $json | Select Id, CreationTime,Workload, UserId, Activity, ItemName, WorkSpaceName, DatasetName, ReportName, WorkspaceId, ObjectId, DatasetId, ReportId, ReportType ,DistributionMethod, ConsumptionMethod
 
# 3. Insert into SQL Server Database
#Write-SqlTableData -InputData $activity -ServerInstance "MySQLServer2022" -DatabaseName "MyDatabase" -SchemaName "dbo" -TableName "PowerBIActivityLog" -Force
Write-SqlTableData -InputData $activity -ServerInstance "DESKTOP-NQODLCT" -DatabaseName "amt" -SchemaName "dbo" -TableName "PowerBIActivityLog" -Force
#DESKTOP-NQODLCT
$activity
    Get-PowerBIActivityEvent -StartDateTime $StartDate -EndDateTime $EndDate -ResultType JsonString | 
    Out-File -FilePath "c:\temp\AuditLog_$(Get-Date -Date $EndDate -Format yyyyMMdd).json"

$AppId = 'appid guid'
$AppSecret = '[secret value]'
$Tenant = '<tenant guid>'
#Clear
# Prerequisits - install Powershell Power  Bi modules

Install-Module -Name MicrosoftPowerBIMgmt.Profile -Force
# Install module
Install-Module -Name MicrosoftPowerBIMgmt

#Pass credentials
$PWord = ConvertTo-SecureString -String $AppSecret -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $AppId, $PWord
Connect-PowerBIServiceAccount -ServicePrincipal -Credential $Credential -Tenant d289a47a-3ec6-436b-8040-85591cd46d7b

 
$Dates = Get-Date((get-date ).AddDays(-1))  -Format "yyyy-MM-dd"
$StartDate = $Dates + 'T00:00:00'
$EndDate = $Dates + 'T23:59:59'
 
 
$json = Get-PowerBIActivityEvent -StartDateTime $StartDate -EndDateTime $EndDate | ConvertFrom-Json
$activity = $json | Select Id, CreationTime,Workload, UserId, Activity, ItemName, WorkSpaceName, DatasetName, ReportName, WorkspaceId, ObjectId, DatasetId, ReportId, ReportType ,DistributionMethod, ConsumptionMethod
 
$activity
    Get-PowerBIActivityEvent -StartDateTime $StartDate -EndDateTime $EndDate -ResultType JsonString | 
    Out-File -FilePath "c:\temp\AuditLog_$(Get-Date -Date $EndDate -Format yyyyMMdd).json"

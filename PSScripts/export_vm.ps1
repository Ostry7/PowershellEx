function Export-ZertoVMConfig {
    <#
    .Parameter ZVMServer
        String parameter taking either IP address or a hostname of a ZVM you want to get the export from
    .Description
        Script using REST API of a ZVM that provides a .csv file containing all configured VMs and VPGs toghether with SourceSite and TargetSite. 
    .Example
        Export-ZertoVMConfig -ZVMServer "10.10.10.10"
    .Example
        Export-ZertoVMConfig -ZVMServer "ZVM.domain.com"
    #>
    [CmdletBinding()]
    param ([Parameter(Mandatory=$true)][string]$ZVMServer)
# Script variables
$ZertoServer = $ZVMServer
$ZertoPort = "9669"
$Credentials = Get-Credential -Message “Please enter Username and Password for ZVM $($ZertoServer)”
$ZertoUser = $Credentials.UserName
$ZertoPassword = $Credentials.GetNetworkCredential().Password
​
​
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls -bor [Net.SecurityProtocolType]::Tls11 -bor [Net.SecurityProtocolType]::Tls12
# Setting Cert Policy
if ("TrustAllCertsPolicy" -as [type]) {} else {
        Add-Type "using System.Net;using System.Security.Cryptography.X509Certificates;public class TrustAllCertsPolicy : ICertificatePolicy {public bool CheckValidationResult(ServicePoint srvPoint, X509Certificate certificate, WebRequest request, int certificateProblem) {return true;}}"
        [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
}
​
# Building Zerto API string and invoking API
$baseURL = "https://" + $ZertoServer + ":"+$ZertoPort+"/v1/"
​
# Authenticating with Zerto APIs
$xZertoSessionURI = $baseURL + "session/add"
$authInfo = ("{0}:{1}" -f $ZertoUser,$ZertoPassword)
$authInfo = [System.Text.Encoding]::UTF8.GetBytes($authInfo)
$authInfo = [System.Convert]::ToBase64String($authInfo)
$headers = @{Authorization=("Basic {0}" -f $authInfo)}
$sessionBody = '{"AuthenticationMethod": "1"}'
$contentType = "application/json"
$xZertoSessionResponse = Invoke-WebRequest -Uri $xZertoSessionURI -Headers $headers -Method POST -Body $sessionBody -ContentType $contentType -UseBasicParsing
​
#Extracting x-zerto-session from the response, and adding it to the actual API
$xZertoSession = $xZertoSessionResponse.headers.get_item("x-zerto-session")
$zertSessionHeader = @{"x-zerto-session"=$xZertoSession}
​
# Querying API
$VMListURL = $BaseURL+"vms"
$VMList = Invoke-RestMethod -Uri $VMListURL -TimeoutSec 100 -Headers $zertSessionHeader -ContentType "application/JSON"
$VMListTable = $VMList | select VmName, VpgName, SourceSite, TargetSite 
$VMListTable | format-table -AutoSize
$destinationPartition = "C:\"
if (!(Test-Path $destinationPartition)) {
    $destinationPartition = "D:\"
}
try{
$VMListTable | Export-Csv -Path ($destinationPartition + ‘Temp\ProtectedVMs.csv’) -NoTypeInformation
    } catch [System.IO.DirectoryNotFoundException]{
        New-Item -ItemType Directory -Path $destinationPartition -Name "Temp"
        $VMListTable | Export-Csv -Path ($destinationPartition + ‘Temp\ProtectedVMs.csv’) -NoTypeInformation
    }
}
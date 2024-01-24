#######################################
#            ©MarekOstrowski          #
#######################################


function Find-mssqlEV
{
    <#
        .SYNOPSIS
        Send mail notification for newest mssql error using MS EventViewer

        .DESCRIPTION
        Send mail notification for newest mssql error using MS EventViewer using below params

        .EXAMPLE
        PS> Find-mssqlEV
    #>

#EventViewer parameters
$hostname = hostname
$logname = "Application"
$source = "MSSQLSERVER"
$entryType = "Error" # -Error -Information -FailureAudit -SuccessAudit -Warning
$csvFile = "C:\!Temp\error.csv"
$lastDate = "C:\!Temp\date-file.txt"

#Email parameters
$username = "TESTMAIL@TEST.COM"
$password = "PASSWORD"
$reciver = "TESTRECIVERMAIL@TEST.COM"


if (Test-Path $lastDate) {
    Write-Host "Necessary dir already exists!"
}
else{
    Write-Host "Necessary dir doesn't exist I will create the file!"
    New-Item $lastDate -ItemType File 
}

function Send-ToEmail(){
    
    $sstr = ConvertTo-SecureString -string $password -AsPlainText -Force
    $cred = New-Object System.Management.Automation.PSCredential -argumentlist $username, $sstr
    $errorBody = Get-EventLog -LogName $logname -Source $source -entryType $entryType -Newest 1
    $errorBody | Export-Csv -Path $csvFile
    $errorTime =  $errorBody.TimeGenerated
    $errorDetails = $errorBody.Message
    $body = "Error details: 
            Error time generated: $errorTime
            Error message: $errorDetails
            All information in attechement"
    Send-MailMessage -To $reciver -From $username -Subject "$source $entryType on host $hostname" -Body $body -SmtpServer smtp.office365.com -UseSSL -Credential $cred -Port 587 -Attachments $csvFile
    Set-Content $lastDate $errorBody.TimeGenerated.ToString("yyyy.MM.dd hh:mm:ss")
    }

$lastErrorDateFromFile = Get-Content $lastDate
$lastErrorDateFromEventViewer = (Get-EventLog -LogName $logname -Source $source -entryType $entryType -Newest 1).TimeGenerated.ToString("yyyy.MM.dd hh:mm:ss")
 
    if($lastErrorDateFromFile -ne $lastErrorDateFromEventViewer){
        Send-ToEmail;
    }
} 
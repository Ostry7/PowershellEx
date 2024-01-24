#######################################
#            ©MarekOstrowski          #
#######################################
function Backup-mssql
{
    <#
        .SYNOPSIS
        Creating MSSQL database backup. 

        .DESCRIPTION
        Create a backup for propper database which are given in config. Based on $isDifferentialBackup you can create FULL or DIFF db backup. This script can be used in Windows Sheduler.

        .EXAMPLE
        PS> Backup-mssql
    #>
$serverInstance = 'SERVER INSTANCE'
$databaseName = 'DATABASENAME'
$backupLocation = "C:\!Temp"
$currentDate = Get-Date -Format "dd_MM_yyyy"
$username = "USER"
$password = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
$isDifferentialBackup = 1

        if (Test-Path $backupLocation) {
               Write-Host "Backup location Folder Exists"
               Write-Host "Setting backup location: $backupLocation ..."
               Set-Location $backupLocation
               Write-Output "Checking if there are another"
               Write-Host "Creating backup..."
               if($isDifferentialBackup -eq 1){
                Backup-SqlDatabase -ServerInstance $serverInstance -Database $databaseName -BackupFile "$backupLocation\$databaseName`_$currentDate.bak" -Credential ($creds) -Incremental
               }
               else{
                Backup-SqlDatabase -ServerInstance $serverInstance -Database $databaseName -BackupFile "$backupLocation\$databaseName`_$currentDate.bak" -Credential ($creds) 
               }
               
            }
        else
        {
            #PowerShell Create hidden config directory if not exists
            New-Item $backupLocation -ItemType Directory
            Write-Host "Backup location Folder Created successfully"
            Write-Host "Setting backup location: $backupLocation ..."
            Set-Location $backupLocation
            Write-Host "Creating backup..."
            if($isDifferentialBackup -eq 1){
                Backup-SqlDatabase -ServerInstance $serverInstance -Database $databaseName -BackupFile "$backupLocation\$databaseName`_$currentDate.bak" -Credential ($creds) -Incremental
               }
               else{
                Backup-SqlDatabase -ServerInstance $serverInstance -Database $databaseName -BackupFile "$backupLocation\$databaseName`_$currentDate.bak" -Credential ($creds) 
               }
               
        }
}

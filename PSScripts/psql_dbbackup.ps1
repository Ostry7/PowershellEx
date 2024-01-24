#######################################
#            ©MarekOstrowski          #
#######################################
function Backup-psql
{
    <#
        .SYNOPSIS
        Creating PostgreSQL database backup.

        .DESCRIPTION
        Create a backup for propper database which are given in config.

        .EXAMPLE
        PS> Backup-psql
    #>

    $user = 'postgres'
    $databaseName = 'postgres'
    $port = '5432'
    $serverInstance = 'localhost'
    $currentDate = Get-Date -Format "dd_MM_yyyy"
    $backupLocation = "C:\!Temp"
    $env:PGPASSWORD = 'admin';


    if (Test-Path $backupLocation) {
        Write-Host "Backup location Folder Exists"
        Write-Host "Setting backup location: $backupLocation ..."
        Set-Location $backupLocation
        Write-Host "Creating backup..."
        Set-Location "$env:LOCALAPPDATA\Programs\pgAdmin 4\v6\runtime"
        Start-Process .\pg_dump.exe "--host $serverInstance --port $port --username $user -F t -f $backupLocation\$databaseName`_$currentDate.tar"
    }
    else
    {
        New-Item $backupLocation -ItemType Directory
        Write-Host "Backup location Folder Created successfully"
        Write-Host "Setting backup location: $backupLocation ..."
        Set-Location $backupLocation
        Write-Host "Creating backup..."
        Set-Location "$env:LOCALAPPDATA\Programs\pgAdmin 4\v6\runtime"
        Start-Process .\pg_dump.exe "--host $serverInstance --port $port --username $user -F t -f $backupLocation\$databaseName`_$currentDate.tar"
    }
}
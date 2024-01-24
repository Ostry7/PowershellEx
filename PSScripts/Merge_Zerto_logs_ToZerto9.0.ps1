#To Zerto 9.0 - Zerto in this version always compress log files
#Change 2022-09-19


$path = "E:\Zerto\Zerto Virtual Replication\logs\log*.zip"
$pathZip = "E:\Zerto\Zerto Virtual Replication\logs\log*.zip"
$Destination = "C:\Users\plzz09t3\Desktop\ZertoLogs_merged\"
$daysback = (0)
$minutesback = -30
$logpath = "C:\Users\plzz09t3\Desktop\logs\"
$watch = New-Object System.Diagnostics.Stopwatch
$FileNameNew = "C:\Users\plzz09t3\Desktop\ZertoLogs_merged\CombinedFile_new.csv"
$7zippath = “$env:ProgramFiles\7-Zip\7z.exe”
Set-Alias 7zip $7zippath
$LastWrite = (get-date).AddDays(0)
$datetime = (Get-Date).ToString('hh:mm')
$txtFile = "C:\Users\plzz09t3\Desktop\logs\files.txt"
$LastWrite = (get-date).AddDays(-4)
$LogDir = "C:\Users\plzz09t3\Desktop\logs"
$Files = Get-ChildItem -Filter "logs*.txt" -Recurse -File | Where-Object {$_.LastWriteTime -le $LastWrite}
$HowMuchFiles = $Files.count
$watch.Start()
Start-Transcript -Path "$logpath\logs_$(get-date -f MM-dd-yyyy).txt" -Append
Write-Output ("($datetime) [INFO]*****Script parameter*****")
Write-Output ("($datetime) [CONFIG]*****path=$path*****")
Write-Output ("($datetime) [CONFIG]*****destination=$Destination*****")
Write-Output ("($datetime) [CONFIG]*****daysback=$daysback*****")
Write-Output ("($datetime) [CONFIG]*****minutesback=$minutesback*****")

Write-Output ("($datetime) [INFO]*****Deleting all log files*****")  
Remove-Item $Destination\log*.csv
Write-Output ("($datetime) [INFO]*****Deleting all log files done!*****") 

#Delete old CombinedFile_new.csv if exists
if (Test-Path $FileNameNew) {
Write-Output ("($datetime) [INFO]*****Deleting old CombinedFileNew.csv*****")
  Remove-Item $FileNameNew
  write-host "$FileNameNew has been deleted"
Write-Output ("($datetime) [INFO]*****Deleting old CombinedFileNew.csv done!*****")
}

$lastLoadedFileFromTxt = Get-content -tail 1 $txtFile
Write-Output ("Last file name from .txt file: " + $lastLoadedFileFromTxt)
$lastLoadedFileFromDir = Get-ChildItem $path | Sort LastWriteTime | select -last 1
$lastLoadedFileFromDirName = $lastLoadedFileFromDir.Name
Write-Output ("Last file name from log dir: " + $lastLoadedFileFromDirName)


if ($lastLoadedFileFromTxt -ne $lastLoadedFileFromDirName){
#Copy *.zip log files to another folder older than X days
Write-Output ("($datetime) [INFO]*****Start Copying file*****")
Get-ChildItem -Path $pathZip -Recurse|
Where-Object {
  $_.LastWriteTime -gt [datetime]::Now.AddMinutes($minutesback)
}| Copy-Item -Destination $Destination

Clear-Content -path $txtFile –force #clear .txt file
ForEach ($file in Get-ChildItem -Path $Destination -Filter "log*.zip" )
{  
  Write-Output $file;
	Add-Content $txtFile $file.Name;
}

Write-Output ("($datetime) [INFO]*****Copying file done!*****")

#Merging files   --- $lastLoadedFileFromDir = latest file from "E:\Zerto\Zerto Virtual Replication\logs\log*.zip"
#UnZip files

Write-Output ("($datetime) [INFO]*****Start unzip files*****")
Get-ChildItem $Destination -Filter *.zip | Expand-Archive -DestinationPath $Destination -Force
Write-Output ("($datetime) [INFO]*****Unzip files done!*****")
#Delete Zip files
Remove-Item $Destination\log*.zip
Write-Output ("($datetime) [INFO]*****Start Merging files*****")
Get-Content -Filter log*.csv -Path "$Destination\log*.csv" | Add-Content "$Destination\CombinedFile_new.csv" -Force
Write-Output ("($datetime) [INFO]*****Merging files done!*****")
[int]$endMs = (Get-Date).Millisecond
$time = $watch.Elapsed.TotalSeconds 

Write-Output ("($datetime) [INFO]*****Removing old CombinedFile and rename it*****")  
#Remove-Item $Destination\CombinedFile.csv
#Rename-Item $Destination\CombinedFile_new.csv CombinedFile.csv
Move-Item -Path "$Destination\CombinedFile_new.csv" -Destination "$Destination\CombinedFile.csv" -Force
Write-Output ("($datetime) [INFO]*****Removing old CombinedFile and rename it done!*****") 
}
else 
{
    Write-Output ("($datetime) [INFO]*****There aren't new logs*****")
    break;
}

Write-Output ("($datetime) [INFO]*****Files older than $LastWrite :" + $HowMuchFiles +"*****")

if($HowMuchFiles -gt 0){
    ForEach ($File in $Files) {
        $File | Compress-Archive -DestinationPath "$($File.fullname).zip"
        Write-Output ("($datetime) [INFO]*****$File successfully compressed, so delete it*****")
        Remove-Item $LogDir\$File
    }
}
else {
    Write-Output ("($datetime) [INFO]*****There is no files to compress*****")
}
Write-Output ("($datetime) [CONFIG]*****Elapsed time: $time sec*****")
$watch.reset()
Stop-Transcript
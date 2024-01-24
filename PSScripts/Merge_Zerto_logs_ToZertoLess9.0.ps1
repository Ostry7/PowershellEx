$path = "E:\Zerto\Zerto Virtual Replication\logs\log.*.csv"
$Destination = "C:\Users\plzz09t3\Desktop\ZertoLogs_merged\"
$DestinationFilter = "C:\Users\plzz09t3\Desktop\ZertoLogs_merged\log*.csv"
$daysback = (0)
$minutesback = -30
$logpath = "C:\Users\plzz09t3\Desktop\logs\"
$watch = New-Object System.Diagnostics.Stopwatch
$FileNameNew = "C:\Users\plzz09t3\Desktop\ZertoLogs_merged\CombinedFile_new.csv"
$7zippath = “$env:ProgramFiles\7-Zip\7z.exe”
Set-Alias 7zip $7zippath
$LastWrite = (get-date).AddDays(0)
$date=(Get-Date).ToString(‘yyyyMMdd’)
$datetime = (Get-Date).ToString('hh:mm')
$txtFile = "C:\Users\plzz09t3\Desktop\logs\files.txt"
$logfiles = Get-ChildItem -Path $DestinationFilter
$LastWrite = (get-date).AddDays(-4)
$LogDir = "C:\Users\MarekOstrowski\Desktop\!Scripts\test"
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

#Copy *.csv log files to another folder older than X days
Write-Output ("($datetime) [INFO]*****Start Copying file*****")
Get-ChildItem -Path $path -Recurse|
Where-Object {
  $_.LastWriteTime -gt [datetime]::Now.AddMinutes($minutesback)
}| Copy-Item -Destination $Destination
Clear-Content -path $txtFile –force #clear .txt file
foreach($file in $logfiles)
{
	Add-Content $txtFile $file.Name;
}
Write-Output ("($datetime) [INFO]*****Copying file done!*****")
$lastLoadedFileFromTxt = Get-content -tail 1 $txtFile
Write-Output ("Last file name from .txt file: " + $lastLoadedFileFromTxt)

#Merging files
$lastLoadedFileFromDir = Get-ChildItem $path | Sort LastWriteTime | select -last 1
$lastLoadedFileFromDirName = $lastLoadedFileFromDir.Name
Write-Output ("Last file name from log dir: " + $lastLoadedFileFromDirName)

if ($lastLoadedFileFromTxt -ne $lastLoadedFileFromDirName)
{
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

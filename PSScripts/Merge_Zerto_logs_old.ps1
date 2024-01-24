#Copy *.csv log files to another folder older than X days
$path = "E:\Zerto\Zerto Virtual Replication\logs\log.*.csv"
$Destination = "C:\Users\plzz09t3\Desktop\Monitoring\"
$daysback = (0)
$logpath = "C:\Users\plzz09t3\Desktop\logs\"
$watch = New-Object System.Diagnostics.Stopwatch
$FileNameNew = "C:\Users\plzz09t3\Desktop\Monitoring\CombinedFile_new.csv"

$watch.Start()
Start-Transcript -Path "$logpath\logs_$(get-date -f MM-dd-yyyy_HH_mm_ss).txt"
Write-Output ("[INFO]*****Script parameters*****")
Write-Output ("[CONFIG]*****path=$path*****")
Write-Output ("[CONFIG]*****destination=$Destination*****")
Write-Output ("[CONFIG]*****daysback=$daysback*****")

#Delete old CombinedFile_new.csv if exists
Write-Output ("[INFO]*****Deleting old CombinedFileNew.csv*****")
if (Test-Path $FileNameNew) {
  Remove-Item $FileNameNew
  write-host "$FileNameNew has been deleted"
}
Write-Output ("[INFO]*****Deleting old CombinedFileNew.csv done!*****")

Foreach($file in (Get-ChildItem $path))
{
	If($file.LastWriteTime -gt (Get-Date).adddays($daysback).date)
	{
Write-Output ("[INFO]*****Start Copying file $file*****")

		Copy-Item -Path $file.fullname -Destination $Destination
	}
Write-Output ("[INFO]*****Copying file $file done!*****")
}
Write-Output ("[INFO]*****Start Merging files*****")

#Merging *.csv files into one file *.csv

Get-Content -Filter log*.csv -Path "$Destination\log*.csv" | Add-Content "$Destination\CombinedFile_new.csv" -Force
Write-Output ("[INFO]*****Merging files done!*****")
[int]$endMs = (Get-Date).Millisecond
$time = $watch.Elapsed.TotalSeconds 

Write-Output ("[INFO]*****Removing old CombinedFile and rename it*****")  
#Remove-Item $Destination\CombinedFile.csv
#Rename-Item $Destination\CombinedFile_new.csv CombinedFile.csv
Move-Item -Path "$Destination\CombinedFile_new.csv" -Destination "$Destination\CombinedFile.csv" -Force
Write-Output ("[INFO]*****Removing old CombinedFile and rename it done!*****") 

#Uncomment perl task 
 
#Delete all log.*.csv files
Write-Output ("[INFO]*****Deleting all log files*****")  
Remove-Item $Destination\log*.csv
Write-Output ("[INFO]*****Deleting all log files done!*****") 

#ZIP old log_script files
Write-Output ("[INFO]*****ZIP old log script files*****")  
$logpath = "C:\Users\plzz09t3\Desktop\logs\"
# Optional filter to only touch files with specified extension 
$mask = "*.txt" 
$ZipFileName= "_Backup.zip"
$days = 2
$problem = $false
$date = (Get-Date).tostring("yyyy-MM-dd")
$errorMessage="no issue"
  
try {
    # Get all items from specified path, recursing into directories but not returning directories themselves. Excluding files with modificiation dates less than $days
    $files = Get-ChildItem $logpath -Recurse -Include $mask | where {($_.LastWriteTime -lt (Get-Date).AddDays(-$days)) -and ($_.psIsContainer -eq $false)} 
    foreach ($file in $files) {
        $Directory = $logpath + $file.LastWriteTime.Date.ToString('yyyy_MM_dd')
        if (!(Test-Path $Directory)) {
         New-Item $directory -type directory
     }
     Move-Item $file.fullname $Directory
    }
    $folders = Get-ChildItem $logpath -Directory  | % { $_.FullName }
    foreach ($folder in $folders) {
        $zipname = $folder + $ZipFileName
        if (!(test-path $zipname)){
        compress-archive -LiteralPath $folder -DestinationPath $zipname
        }
        if (test-path $zipname){
        remove-item -Recurse $folder 
        }
        else {
        Write-host $zipname + "Hello" + $folder
        }
    }
}
catch {
    $problem = $true
    $errormessage = $_.Exception.Message }
Write-Output ("[INFO]*****ZIP old log script files done!*****")  
Write-Output ("[INFO]*****Deleting old log script files*****")  
Get-ChildItem "C:\Users\plzz09t3\Desktop\logs\logs*" -Recurse -File | Where CreationTime -lt  (Get-Date).AddDays(-2)  | Remove-Item -Force
Write-Output ("[CONFIG]*****Elapsed time: $time sec*****")
Write-Output ("[INFO]*****Deleting old log script files done!*****")  
$watch.reset()
Stop-Transcript
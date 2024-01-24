#######################################
#            ©MarekOstrowski          #
#######################################

$ramThreshold = 80
$cpuThreshold = 80
$i=0

function Show-Menu
{
     param (
           [string]$Title = "CPU and RAM Monitoring"
     )
     Clear-Host
     Write-Host "================ $Title ================"
    
     Write-Host "1: Press 1 to monitor CPU."
     Write-Host "2: Press 2 to monitor RAM"
     Write-Host "3: Press 3 to monitor both CPU and RAM."
     Write-Host "Q: Press Q to quit."
}

function Get-Cpu
{
     $cpuUtilization = (Get-WmiObject -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
     $cpuStr = "$cpuUtilization % of CPU Utilization"

          if($cpuUtilization -gt $cpuThreshold){
               echo "WARNING!!!!! CPU ACHIEVED MORE THAN THRESHOLD"  
          }

          Start-Sleep -Seconds 1
     return $cpuStr
}

function Get-Ram
{
     $ComputerMemory = Get-WmiObject -Class win32_operatingsystem -ErrorAction Stop
     $Memory = ((($ComputerMemory.TotalVisibleMemorySize - $ComputerMemory.FreePhysicalMemory)*100)/ $ComputerMemory.TotalVisibleMemorySize)
     $RoundMemory = [math]::Round($Memory, 0)
     $RoundMemoryStr = "$RoundMemory % of RAM Memory"

          if ($RoundMemory -gt $ramThreshold) {
               echo "WARNING!!!!! RAM ACHIEVED MORE THAN THRESHOLD"
          }

          Start-Sleep -Seconds 1
     return $RoundMemoryStr
}

do
{
     Show-Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           "1" {
                Clear-Host
                "select duration in seconds"
                [int]$durationInSec = Read-Host
                    while($i -le $durationInSec){
                         Get-Cpu  
                         $i=$i+1
                    }$i=0

           } "2" {
            Clear-Host
            "select duration in seconds"
            [int]$durationInSec = Read-Host
               while ($i -le $durationInSec){
                    Get-Ram
                    $i=$i+1
               }$i=0
           } "3" {
            Clear-Host
            "select duration in seconds"
            [int]$durationInSec = Read-Host
               while ($i -le $durationInSec){
                    Get-Cpu
                    Get-Ram
                    $i=$i+1
               }$i=0
           } "q" {
                return
           }
     }
     pause
}
until ($input -eq "q")
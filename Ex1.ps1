#Ex1 - accumulate#

#Create array
$array = @()
do {
 $input = (Read-Host "Please enter elem of array")
 if ($input -ne '') {$array += $input}
}
until ($input -eq '')

#operation square
foreach ($elem in $array){

$x = [Math]::Pow($array[$elem-1],2)
Write-Output $x
}

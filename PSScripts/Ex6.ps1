## Instructions
#
#Reverse a string
#
#For example:
#input: "cool"
#output: "looc"

echo "Write sth: "
$input = Read-Host
$temp = $input.ToCharArray()
[array]::Reverse($temp)
$temp -join ""
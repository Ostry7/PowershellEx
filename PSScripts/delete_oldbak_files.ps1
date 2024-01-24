#######################################
#            ©MarekOstrowski          #
#######################################

function Delete-OldBakFiles
{
    <#
        .SYNOPSIS
        Delete files based on $limit days.

        .DESCRIPTION
        Delete files based on $limit days and propper extention files given in $path= *.XXX .

        .EXAMPLE
        PS> Delete-OldBakFiles
    #>
$limit = (Get-Date).AddDays(0)

$path = "C:\!Temp\*.bak"        #specify *.bak filter for files

Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force
}
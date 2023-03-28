#Ex1 - accumulate#

function accumulateEx1{
    #Create array
    $array = @()

    #Add elems to array
        do {
         $input = (Read-Host "Please enter elem of array")
            if ($input -ne '') {$array += $input}
        }
        until ($input -eq '')

    #operation square
          for($i=1; $i -le $array.count;$i++){        
            $var = [Math]::Pow($array[$i-1],2)
            Write-Output $var
          }

    #Clear array
    $array.Clear()
}
## Description
#
#The Collatz Conjecture or 3x+1 problem can be summarized as follows:
#
#Take any positive integer n. If n is even, divide n by 2 to get n / 2. If n is odd, multiply n by 3 and add 1 to get 3n + 1. Repeat the process indefinitely. The conjecture states that no matter which number you start with, you will always reach 1 eventually.
#
#Given a number n, return the number of steps required to reach 1.
#Examples
#
#Starting with n = 12, the steps would be as follows:
#
#```
#12  
#6  
#3  
#10  
#5  
#16  
#8  
#4  
#2  
#1  
#```
#
#Resulting in 9 steps. So for input n = 12, the return value would be 9.
Function Invoke-CollatzConjecture() {
    <#
    .SYNOPSIS
    Calculate the number of steps to reach 1 using the Collatz conjecture.

    .DESCRIPTION
    Take any positive integer n. If n is even, divide n by 2 to get n / 2. If n is odd, multiply n by 3 and add 1 to get 3n + 1. Repeat the process indefinitely. The conjecture states that no matter which number you start with, you will always reach 1 eventually.

    .PARAMETER Number
    The number to perform the Collatz Conjecture function on.

    .EXAMPLE
    Invoke-CollatzConjecture -Number 12
    #>
    [CmdletBinding()]
    Param(
        [Int64]$Number
    )
    
$input = Read-Host

    if($input -le 0) {
        throw "error: Only positive numbers are allowed"
    }

    $Counter = 0 

    while($input -ne 1){
        if ($input % 2 -eq 0){
            $input /=2
        }
        else {
            $input = ($input * 3) + 1
        }
    $Counter++
    }
$Counter
}
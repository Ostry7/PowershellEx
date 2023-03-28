## Instructions
#
#Given a year, report if it is a leap year.
#
#The tricky thing here is that a leap year in the Gregorian calendar occurs:
#
#```text
#on every year that is evenly divisible by 4
#  except every year that is evenly divisible by 100
#    unless the year is also evenly divisible by 400
#```
#
#For example, 1997 is not a leap year, but 1996 is.  1900 is not a leap
#year, but 2000 is.
#
### Notes
#
#Though our exercise adopts some very simple rules, there is more to
#learn!
#
#For a delightful, four minute explanation of the whole leap year
#phenomenon, go watch [this youtube video][video].
#
#[video]: http://www.youtube.com/watch?v=xX96xng7sAE

echo "Enter a year: "
$input  = Read-Host


$i = 0
    if ($input % 4 -eq 0){
        $i=1
    }
    if ($input % 4 -ne 0){
        $i=5
    }
    if (($input % 100 -eq 0) -AND ($i=1)){
        $i=2
    }
    if(($input % 100 -ne 0) -AND ($i=1)){
        $i=3
    }
    if(($input % 400 -eq 0) -AND ($i=2)){
        $i=4
    }
    if(($input % 400 -ne 0) -AND ($i=2)){
        $i=6
    }

switch ($i){
    "5" {echo "NOT leap year"; break}
    "3" {echo "leap year"; break}
    "4" {echo "leap year"; break}
    "6" {echo "NOT leap year"; break}
}
    
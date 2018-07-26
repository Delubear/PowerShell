#import-module activedirectory

quser /server:servername | out-file temp.txt
$file = get-content temp.txt| foreach-object {
$sep = " "
$part = $_.split($sep)
$final = $part[0]

}

#get-content temp.csv | where-object {$_ -contains "time"} | foreach-object {$_ -replace ""} | out-file temp2.csv

import-csv temp2.csv | ForEach-Object {
$userID = $_.USERNAME
write-host $userID
}

read-host "test"
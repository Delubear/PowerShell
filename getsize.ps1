$folders = get-childitem \\filepath |  Measure-Object -Property Length -Sum

foreach($folder in $folders){
write-host $folder.Sum
}

read-host "test"
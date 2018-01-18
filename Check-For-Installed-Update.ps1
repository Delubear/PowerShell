$Server = Read-Host "Enter Computer to Find Updates On"
$KB = (Read-Host "Enter KB Number To Search For").ToUpperInvariant()
Get-HotFix -Id $KB -ComputerName $Server
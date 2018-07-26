$Dir = "$path"
$Output = "$outputPath"

Get-ChildItem -Path $Dir -Recurse | ?{ $_.PSIsContainer } | Select-Object FullName | foreach{
    $_.FullName | Out-File $Output -Append
}
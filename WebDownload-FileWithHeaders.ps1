$url = "URL" 
$path = "path"

$webClient = New-Object System.Net.WebClient
$webClient.Headers.add('header','value')
$webClient.DownloadFile($url, $path)
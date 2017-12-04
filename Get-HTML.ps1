# Pull HTML data from webpage. Does not seem to work if page requires HTTPS
$url = "http://www.delubear.com"
[net.httpwebrequest]$request = [net.webrequest]::create($url)
[net.httpwebresponse]$response = $request.GetResponse()
$responseStream = $response.GetResponseStream()
$sr = New-Object IO.StreamReader($responseStream)
$result = $sr.ReadToEnd()
$result

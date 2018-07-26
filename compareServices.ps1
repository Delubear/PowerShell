
[string]$server1 = "server1";
[string]$server2 = "server2";
 
Write-Host "Fetching list of services on $server1 ..."
$services1=gwmi -computer $server1 win32_service
 
Write-Host "Fetching list of services on $server2 ..."
$services2=gwmi -computer $server2  win32_service
 
$allServices = @{}
 
foreach($serviceEnum in $services1)
{
	$service = '' | Select-Object Name, State1, State2;
 
	$service.Name = $serviceEnum.Name;
	$service.State1 = $serviceEnum.State;
	$service.State2 = "--test--";
	
	$allServices.Add($service.Name, $service);
}
 
foreach($serviceEnum in $services2)
{
	if ($allServices.ContainsKey($serviceEnum.Name))
	{
		$allServices[$serviceEnum.Name].State2 = $serviceEnum.State;
	}
	else
	{
		$service = '' | Select-Object Name, State1, State2;
	
		$service.Name = $serviceEnum.Name;
		$service.State1 = "--test--";
		$service.State2 = $serviceEnum.State;
		
		$allServices.Add($service.Name, $service);
	}
}
 
$allServices.Values | Format-Table -Property Name, State1, State2 >> P:\Scripts\compare.csv
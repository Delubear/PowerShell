$file = "P:\P1.csv"
$file2 = "P:\P2.csv"
$file3 = "P:\P3.csv"

$data = get-content $file
$data2 = get-content $file2

foreach($item in $data2)
{
	$entry0 = Select-String -Path $file -Pattern $item

	[string]$email = $item

	$entry = $entry0.ToString()
	$entry2 = $entry.Split(':')[3]
	$entry3 = $entry2.Split(',')
	
	[string]$CIF = $entry3[0]
	[string]$Name = $entry3[2]

	add-content -Path $file3 "$($email) , $($CIF) , $($Name)"

	write-host "$($email) , $($CIF) , $($Name)"
}

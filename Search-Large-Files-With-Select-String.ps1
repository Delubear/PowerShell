$file = "Path.csv"
$file2 = "Path2.csv"
$file3 = "Path3.csv"

$data = get-content $file
$data2 = get-content $file2

foreach($item in $data2)
{
	$baseLine = Select-String -Path $file -Pattern $item

	[string]$email = $item

	$Line = $baseLine.ToString()
	$Section = $Line.Split(':')[3]
	$Array = $Section.Split(',')
	
	[string]$ID = $Array[0]
	[string]$Name = $Array[2]

	add-content -Path $file3 "$($email) , $($ID) , $($Name)"

	write-host "$($email) , $($ID) , $($Name)"
}

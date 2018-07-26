add-pssnapin *exchange*

$folders = get-publicfolder -recurse -resultsize unlimited

foreach($folder in $folders)
{
	$stats = get-publicfolderstatistics $folder.identity

	$name = ($folder | select Name).Name
	$LAT = ($stats | select LastAccessTime).LastAccessTime
	$LMT = ($stats | select LastModificationTime).LastModificationTime
	$Count = ($stats | select ItemCount).ItemCount


	add-content -path P:\pubfolderdata.txt "$name , $LAT , $LMT , $Count "
}
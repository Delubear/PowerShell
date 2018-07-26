Add-PSSnapin *exchange*

$Distros = "email1", "email2"

foreach($Distro in $Distros)
{
    $Count = (Get-MessageTrackingLog -Start 10/01/2017 -Recipient $Distro -ResultSize 99999 | Measure-Object | Select Count).Count
    Add-Content P:\path1.CSV "$Distro , $Count"
}

foreach($Distro in $Distros)
{
    $Count = (Get-MessageTrackingLog -Start 10/01/2017 -Sender $Distro -ResultSize 99999 | Measure-Object | Select Count).Count
    Add-Content P:\path2.CSV "$Distro , $Count"
}

add-pssnapin *exchange*

$distros = Get-DistributionGroup

$results = ""

foreach($distro in $distros)
{
    $userlist = ""
    $name = $distro.Name
    $users = $distro | get-distributiongroupmember
    foreach($u in $users)
    {
        $userlist += "`r`n :" + $u.DisplayName
    }
    $results += "$name $userlist `r`n `r`n"
} 

$results|  out-file p:\distroTest2.txt
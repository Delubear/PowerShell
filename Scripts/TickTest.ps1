$cs = Get-Content -Path ".\Ticker.cs"

Add-Type -TypeDefinition "$cs" -Language CSharp

$list = New-Object "System.Collections.Generic.List[ITicker]"

$f = New-Object Food
$f.Name = "bob"

$list += $f
$g = New-Object Food
$g.Name = "joe"
$list += $g

$f.TakeAction()
$f.TicksToWait = 10

$g.TakeAction()
$g.TicksToWait = 10


$i = 100
while($i -gt 0)
{
    foreach($j in $list)
    {
        if($j.TicksToWait -le 0)
        {
            $j.Name
            $j.TakeAction()
            $j.TicksToWait += Get-Random -Minimum 1 -Maximum 100
        }
        else
        {
            $j.DecreaseTicks()
        }
    }    
    $i--;
}
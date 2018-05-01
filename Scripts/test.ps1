<#$cs = @"
public class Yell
{
    public string Hello()
    {
        return "Hello there!";
    }

    public string Hello(string str)
    {
        return "Hello " + str;
    }

    public static string Eat()
    {
        return "Food";
    }
}
"@
#>
<#
$cs = Get-Content -Path ".\test2.cs"

Add-Type -TypeDefinition "$cs"
$myObj = New-Object Yell
Write-Host $myObj.Hello()
Write-Host $myObj.Hello("bob")
$c = [Yell]::Eat()
Write-Host $c

$Card = New-Object Cards
$Card.Name = "Ace"
$d = $Card.GetName()
Write-Host $d
$card.Name.GetType()
#>

Class Dog
{
    [string]$Name
    [int]$Age
    static [int]$Paws = 4
}

$g = New-Object Dog
$g.Age = 4
$g::Paws
Write-Host $g.Age
$g
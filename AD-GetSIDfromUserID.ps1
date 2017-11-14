Import-Module ActiveDirectory

While($true){
$UserProf = $Null
while($UserProf -eq $Null){
$userID = Read-Host "Enter UserID"
$UserProf = Get-ADUser -LDAPFilter "(sAMAccountName=$UserID)"
if($UserProf -eq $Null){write-host "User does not exist, please check UserID"}}

$objUser = New-Object System.Security.Principal.NTAccount("DomainName", "$userID")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value
}
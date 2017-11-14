Import-module Activedirectory
Write-Host "Enter UserID to Unlock in Active Directory" -ForegroundColor Green

$UserProf = $Null
while($UserProf -eq $Null){
$userID = Read-Host "Enter UserID"
$UserProf = Get-ADUser -LDAPFilter "(sAMAccountName=$UserID)"
if($UserProf -eq $Null){write-host "User does not exist, please check UserID"}}

Unlock-ADAccount $userid
#############################################
# Use to assign User full rights to a folder named after their UserID
# i.e. chrisb would be my UserID and personal folder name
# Each User has a folder in this location
# This will update the User's folder itself plus everyfile therein
###################################
$startingDir = "\\path with each user folder"
$Right="FullControl"

foreach($user in $(Get-ChildItem $startingDir)){
    Write-Host "Updating permissions for User $user ..."
    $Principal="domain\$user"
    $rule=New-Object System.Security.AccessControl.FileSystemAccessRule($Principal, $Right, "Allow")

    $acl2 = Get-Acl $user.FullName
    $acl2.SetAccessRule($rule)
    Set-Acl $user.FullName $acl2

    foreach ($file in $(Get-ChildItem "$startingDir\$user" -Recurse)){
        $acl = Get-Acl $file.FullName
        $acl.SetAccessRule($rule)
        Set-Acl $file.FullName $acl
    }
}


$startingDir = "\\path with each user folder"
$Right="FullControl"

foreach($user in $(Get-ChildItem $startingDir)){
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
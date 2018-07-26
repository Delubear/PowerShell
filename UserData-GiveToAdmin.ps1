# Takes Ownership of every folder/file in \\path\userdata\
# Also gives full access permissions to every folder/file

$startingDir = "\\path\drive$\userdata"
$Right="FullControl"

## Takes ownership of file to user running script, otherwise unable to set proper ownership later
takeown /f $startingDir /R /D Y

foreach($user in $(Get-ChildItem $startingDir)){
    $userID = $user.Name.Split('.')[0]
    $Principal="domain\user"    # replace with whichever Admin user is running this

    $rule=New-Object System.Security.AccessControl.FileSystemAccessRule($Principal, $Right, "Allow")
    $acl2 = Get-Acl $user.FullName
    $acl2.SetOwner([System.Security.Principal.NTAccount] $Principal)
    $acl2.SetAccessRule($rule)
    Set-Acl $user.FullName $acl2

    foreach ($file in $(Get-ChildItem "$startingDir\$user" -Recurse)){
        $acl = Get-Acl $file.FullName
	$acl.SetOwner([System.Security.Principal.NTAccount] $Principal)
        $acl.SetAccessRule($rule)
        Set-Acl $file.FullName $acl
    }
}
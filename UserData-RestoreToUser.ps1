# Restores Ownership of every folder/file in \\path\drive$\userdata\ to the correct User (if possible)
# Also removes full access permissions to every folder/file from Admin

$startingDir = "\\path\drive$\userdata"
$Right="FullControl"

foreach($user in $(Get-ChildItem $startingDir)){
    $userID = $user.Name.Split('.')[0]
    $Principal="domain\user"  #Same Admin must run this that ran the 'take' script, replace username with that username
    $Principal2="domain\$userID"

    $rule=New-Object System.Security.AccessControl.FileSystemAccessRule($Principal, $Right, "Allow")
    $acl2 = Get-Acl $user.FullName
    $acl2.SetOwner([System.Security.Principal.NTAccount] $Principal2)
    $acl2.SetAccessRule($rule)
    $acl2.removeAccessRule($rule)
    Set-Acl $user.FullName $acl2

    foreach ($file in $(Get-ChildItem "$startingDir\$user" -Recurse)){
        $acl = Get-Acl $file.FullName
	$acl.SetOwner([System.Security.Principal.NTAccount] $Principal2)
        $acl.removeAccessRule($rule)
        Set-Acl $file.FullName $acl
    }
}
$value = ""
$strKeyIEConnections = "$_\Software\RegistryPath\"
$strRegType = [Microsoft.Win32.RegistryHive]::Users
$strRegKey  = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($strRegType, $s)
$strRegKey  = $strRegKey.OpenSubKey($strKeyIEConnections)
$value = $strRegKey.GetValue('RegistryKeyName')


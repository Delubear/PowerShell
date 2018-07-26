

$url = "https://website.com"
$username = "username" 
$password = "password" 

$ie = New-Object -com InternetExplorer.Application 
$ie.visible=$true
$ie.navigate("$Url") 
while($ie.ReadyState -ne 4) {start-sleep -m 100} 
$ie.document.getElementById("user").value= "$username" 
$ie.document.getElementById("password").value = "$password" 
Start-sleep -s 1


Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.SendKeys]::SendWait('~'); #sends the Enter Key

#read elements again and see if possible to click text






#$wshell = New-Object -ComObject wscript.shell;
#$wshell.AppActivate('Internet')
#Sleep 1
#$wshell.SendKeys('~')   #sends the Enter Key
## Only runs on machines with PSEXEC installed.
## https://docs.microsoft.com/en-us/sysinternals/downloads/psexec
## https://ss64.com/nt/psexec.html

$Servers = "server1", "server2"

#foreach($Server in $Servers)
#{
    
    psexec $Server -d cmd /c gpupdate /force

    #Start-Sleep -Seconds 30
#}

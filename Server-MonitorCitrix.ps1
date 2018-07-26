$thread = [System.Threading.Thread]::CurrentThread
$thread.Priority = "Lowest"

while($true)
{
    $DataArray = $null
    $Jobs = $null

    $DataArray = @()
    $Jobs = @()
    $Servers = "server1", "server2"
    
    foreach($Server in $Servers)
    {    
        $job = 
        {           
Start-Sleep -Seconds 2
	    $thread = [System.Threading.Thread]::CurrentThread
	    $thread.Priority = "Lowest" 
            $ConvertToGB = (1024 * 1024 * 1024)
            $PC = Get-Counter -Counter "\Processor(_Total)\% Processor Time" -ComputerName $args
	    $PD = $PC.CounterSamples | Select CookedValue

            $cpu = ($PD.CookedValue.ToString().Split('.')[0]) + "%"

Start-Sleep -Seconds 2

            $disk = Get-WmiObject Win32_LogicalDisk -ComputerName $args -Property Size, FreeSpace| Select-Object Size,FreeSpace    

            $Size = ([math]::Round($disk[1].Size / $ConvertToGB))
            $Free = ([math]::Round($disk[1].FreeSpace / $ConvertToGB))
            $DiskPercent = (($Size - $Free) / $Size * 100).ToString().Split('.')[0]
            $DiskAmount = $Size - $Free

Start-Sleep -Seconds 2

            $RamTotal = (Get-WmiObject -Class win32_physicalmemory -Property Capacity -ComputerName $args | Measure-Object -Property Capacity -Sum | Select-Object -ExpandProperty Sum) / 1MB
            $RamAvail = ((Get-Counter '\Memory\Available MBytes' -ComputerName $args).CounterSamples | Select CookedValue).CookedValue.ToString()
            $RamPercent = (($RamTotal - $RamAvail) / $RamTotal * 100).ToString().Split('.')[0]

            $CompName = $args[0].ToString().ToUpper()

Start-Sleep -Seconds 2

            $Users = query user /server:$args

            $UserArray = @()
            foreach($User in $Users) 
            { 
                $UserArray += $User.Split(' ')[1]
            }
            $UserArray = $UserArray -replace "USERNAME",""

            $ServerResult = "$CompName"
            $CPUResult = "$cpu"
            $DiskResult = "$Free GB - $DiskAmount/$Size GB"
            $RAMResult = "$RamPercent%"
            $UserResults = "$UserArray"

            $NewObj = New-Object -TypeName System.Object
            Add-Member -InputObject $NewObj -MemberType NoteProperty -Name ServerName -Value $ServerResult
            Add-Member -InputObject $NewObj -MemberType NoteProperty -Name CPU -Value $CPUResult
            Add-Member -InputObject $NewObj -MemberType NoteProperty -Name RAM -Value $RAMResult
            Add-Member -InputObject $NewObj -MemberType NoteProperty -Name Disk -Value $DiskResult
            Add-Member -InputObject $NewObj -MemberType NoteProperty -Name LoggedinUsers -Value $UserResults

	    Start-Sleep -seconds 2

            return $NewObj
        }   

        $id = [System.Guid]::NewGuid()
        $Jobs += $id
        Start-Job -ScriptBlock $job -Name $id -args $Server >$null 2>&1
    }

    foreach($j in $Jobs)
    {
        Wait-Job -Name $j  >$null 2>&1
        $obj = Receive-Job -Name $j | select ServerName, CPU, RAM, Disk, LoggedinUsers
        $DataArray += $obj
    }

    Remove-Job *
    Clear-Host
    $DataArray | Format-Table -AutoSize -Wrap
    Start-Sleep -Seconds 10
}
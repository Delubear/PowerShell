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
            $ConvertToGB = (1024 * 1024 * 1024)
            $PC = Get-Counter -Counter "\Processor(_Total)\% Processor Time" -ComputerName $args

            $cpu = ($PC.CounterSamples.CookedValue.ToString().Split('.')[0]) + "%"
            $disk = Get-WmiObject Win32_LogicalDisk -ComputerName $args | Select-Object Size,FreeSpace    

            $Size = ([math]::Round($disk.Size[1] / $ConvertToGB))
            $Free = ([math]::Round($disk.FreeSpace[1] / $ConvertToGB))
            $DiskPercent = (($Size - $Free) / $Size * 100).ToString().Split('.')[0]
            $DiskAmount = $Size - $Free

            $RamTotal = (Get-WmiObject -Class win32_physicalmemory -Property Capacity -ComputerName $args | Measure-Object -Property Capacity -Sum | Select-Object -ExpandProperty Sum) / 1MB
            $RamAvail = (Get-Counter '\Memory\Available MBytes' -ComputerName $args).CounterSamples.CookedValue
            $RamPercent = (($RamTotal - $RamAvail) / $RamTotal * 100).ToString().Split('.')[0]

            $CompName = $args[0].ToString().ToUpper()

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
}
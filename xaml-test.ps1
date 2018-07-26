<# 
    .SYNOPSIS 
        WPF XAML Codes in PowerShell. 
     
    .DESCRIPTION 
        An Attempt to use XAML Codes for GUI design. 
        This script gets Service, Process and OS information. 
        The Output Files will be saved in C:\Temp 
         
    .NOTE 
        Choose the location where you have desired access to save the output file and to create a STYLE.CSS 
         
    .DEVELOPER 
        Chendrayan Venkatesan 
     
#> 
 
Add-Type -AssemblyName PresentationFramework 
[xml]$xaml = 
@" 
<Window 
        xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" 
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" 
        Title="PowerShell WPF" Height="244" Width="525" FontFamily="Calibri" FontWeight="Bold" ResizeMode="NoResize"> 
    <Grid Background="#58000000"> 
        <GroupBox Header="Tools" Height="129" HorizontalAlignment="Left" Margin="142,20,0,0" Name="groupBox1" VerticalAlignment="Top" Width="200"> 
            <Grid> 
                <Button Content="Services" Height="23" HorizontalAlignment="Left" Margin="6,27,0,0" Name="Services" VerticalAlignment="Top" Width="75" /> 
                <Button Content="Process" Height="23" HorizontalAlignment="Left" Margin="107,27,0,0" Name="Process" VerticalAlignment="Top" Width="75" /> 
                <Button Content="OS" Height="23" HorizontalAlignment="Left" Margin="58,66,0,0" Name="OS" VerticalAlignment="Top" Width="75" /> 
            </Grid> 
        </GroupBox> 
        <Label Content="Test Placeholder" Height="28" HorizontalAlignment="Left" Margin="288,165,0,0" Name="label1" VerticalAlignment="Top" /> 
    </Grid> 
</Window> 
 
"@ 
 

 
Function Servicereport() { 
    $system = Get-Wmiobject -Class Win32_Service | ConvertTo-Html -Fragment 
    ConvertTo-Html -Body $system -CssUri P:\Scripts\style.CSS -Title "Services" | Out-File C:\Temp\Services.html 
    Start-Sleep 2 
    Invoke-Item C:\Temp\Services.HTML 
} 
 
Function Processreport() { 
    $Process = Get-Wmiobject -Class Win32_Process | Select Caption , Path , Name , ProcessID | ConvertTo-Html -Fragment 
    ConvertTo-Html -Body $Process -CssUri P:\Scripts\style.CSS -Title "Process" | Out-File C:\Temp\Process.html 
    Start-Sleep 2 
    Invoke-Item C:\Temp\Process.HTML 
} 
 
Function OS() { 
    $OS = Get-WmiObject -Class Win32_OperatingSystem | ConvertTo-Html -Fragment 
    ConvertTo-Html -Body $OS -CssUri P:\Scripts\style.CSS -Title "OS Information" | Out-File C:\Temp\OS.Html 
    Start-Sleep 2 
    Invoke-Item C:\Temp\OS.HTML  
} 
 
$reader = (New-Object System.Xml.XmlNodeReader $xaml) 
$Window = [Windows.Markup.XamlReader]::Load( $reader ) 
 
$button1 = $Window.FindName("Services") 
$button2 = $Window.FindName("Process") 
$button3 = $Window.FindName("OS") 
$Method1 = $button1.add_click 
$Method2 = $button2.add_click 
$Method3 = $button3.add_click 
$Method1.Invoke( {Servicereport}) 
$Method2.Invoke( {Processreport}) 
$Method3.Invoke( {OS})  
 
$Window.ShowDialog() | Out-Null
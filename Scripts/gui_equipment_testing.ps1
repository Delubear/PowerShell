#Load Dependencies
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()


$CSV = "C:\Temp\db.csv"

#Needs work :: Issue if directory doesnt exist, doesnt create it
if(!(Test-Path $CSV))
{
    New-Item $CSV
}

class Equipment
{
    [String]$HostName
    [String]$MAC
    [String]$Model
}

function AddEquipment($HostName, $MAC, $Model)
{
    $Equipment = [Equipment]::New()
    $Equipment.HostName = $HostName
    $Equipment.MAC = $MAC
    $Equipment.Model = $Mbodel

    $Equipment | Export-Csv $CSV -Append

    Hide_Add_Screen
    Show_Main_Screen
}

#Returns Equipment Object
function GetEquipmentByHost([String]$Hosts)
{
    [Equipment] $SelectedEquipment = Import-Csv $CSV | Where-Object {$_.HostName -eq $Hosts} | Select-Object -First 1
    return $SelectedEquipment
}

#Returns Array of Equipment Objects
function GetEquipmentListByModel([String]$Model)
{
    [Equipment[]] $SelectedEquipment = Import-Csv $CSV | Where-Object {$_.Model -eq $Model}
    return $SelectedEquipment
}


#############################################################################3



#region begin GUI{ 

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '421,237'
$Form.text                       = "Equipment Management Tool"
$Form.TopMost                    = $false

# Main Screen Interface
$Add_Button                      = New-Object system.Windows.Forms.Button
$Add_Button.text                 = "Add"
$Add_Button.width                = 60
$Add_Button.height               = 30
$Add_Button.location             = New-Object System.Drawing.Point(14,18)
$Add_Button.Font                 = 'Microsoft Sans Serif,10'
$Add_Button.Visible              = $true

$Search_Button                   = New-Object system.Windows.Forms.Button
$Search_Button.text              = "Search"
$Search_Button.width             = 60
$Search_Button.height            = 30
$Search_Button.location          = New-Object System.Drawing.Point(14,59)
$Search_Button.Font              = 'Microsoft Sans Serif,10'
$Search_Button.Visible            = $true

#region begin AddInterface{
# Adding Interface
$Submit_Add_Button               = New-Object system.Windows.Forms.Button
$Submit_Add_Button.text          = "Submit"
$Submit_Add_Button.width         = 60
$Submit_Add_Button.height        = 30
$Submit_Add_Button.location      = New-Object System.Drawing.Point(36,160)
$Submit_Add_Button.Font          = 'Microsoft Sans Serif,10'
$Submit_Add_Button.Visible       = $false

$Host_Label                      = New-Object system.Windows.Forms.Label
$Host_Label.text                 = "Hostname:"
$Host_Label.AutoSize             = $true
$Host_Label.width                = 25
$Host_Label.height               = 10
$Host_Label.location             = New-Object System.Drawing.Point(16,17)
$Host_Label.Font                 = 'Microsoft Sans Serif,10'
$Host_Label.Visible              = $false

$Host_Text                       = New-Object system.Windows.Forms.TextBox
$Host_Text.multiline             = $false
$Host_Text.width                 = 100
$Host_Text.height                = 20
$Host_Text.location              = New-Object System.Drawing.Point(26,33)
$Host_Text.Font                  = 'Microsoft Sans Serif,10'
$Host_Text.Visible               = $false

$MAC_Label                       = New-Object system.Windows.Forms.Label
$MAC_Label.text                  = "MAC:"
$MAC_Label.AutoSize              = $true
$MAC_Label.width                 = 25
$MAC_Label.height                = 10
$MAC_Label.location              = New-Object System.Drawing.Point(16,65)
$MAC_Label.Font                  = 'Microsoft Sans Serif,10'
$MAC_Label.Visible               = $false

$MAC_Text                        = New-Object system.Windows.Forms.TextBox
$MAC_Text.multiline              = $false
$MAC_Text.width                  = 100
$MAC_Text.height                 = 20
$MAC_Text.location               = New-Object System.Drawing.Point(26,84)
$MAC_Text.Font                   = 'Microsoft Sans Serif,10'
$MAC_Text.Visible                = $false

$Model_Label                     = New-Object system.Windows.Forms.Label
$Model_Label.text                = "Model"
$Model_Label.AutoSize            = $true
$Model_Label.width               = 25
$Model_Label.height              = 10
$Model_Label.location            = New-Object System.Drawing.Point(16,111)
$Model_Label.Font                = 'Microsoft Sans Serif,10'
$Model_Label.Visible             = $false

$Model_Text                      = New-Object system.Windows.Forms.TextBox
$Model_Text.multiline            = $false
$Model_Text.width                = 100
$Model_Text.height               = 20
$Model_Text.location             = New-Object System.Drawing.Point(26,129)
$Model_Text.Font                 = 'Microsoft Sans Serif,10'
$Model_Text.Visible              = $false
#endregion AddInterface }

# Adding Controls
$Form.controls.AddRange(@($Add_Button,$Search_Button))
$Form.controls.AddRange(@($Submit_Add_Button,$Host_Label,$Host_Text,$MAC_Label,$MAC_Text,$Model_Label,$Model_Text))


#region gui events {
$Add_Button.Add_Click({ Show_Add_Screen })
$Search_Button.Add_Click({ Searchfunction })
$Submit_Add_Button.Add_Click({ AddEquipment($Host_Text.Text, $MAC_Text.Text, $Model_Text.Text) })
#endregion events }

function Show_Add_Screen()
{
    $Submit_Add_Button.Visible       = $true
    $Host_Label.Visible              = $true
    $Host_Text.Visible               = $true
    $MAC_Label.Visible               = $true
    $MAC_Text.Visible                = $true
    $Model_Label.Visible             = $true
    $Model_Text.Visible              = $true

    Hide_Main_Screen
}
function Hide_Add_Screen()
{
    $Submit_Add_Button.Visible       = $false
    $Host_Label.Visible              = $false
    $Host_Text.Visible               = $false
    $MAC_Label.Visible               = $false
    $MAC_Text.Visible                = $false
    $Model_Label.Visible             = $false
    $Model_Text.Visible              = $false
}
function Hide_Main_Screen()
{
    $Add_Button.Visible              = $false
    $Search_Button.Visible           = $false
}
function Show_Main_Screen()
{
    $Add_Button.Visible              = $true
    $Search_Button.Visible           = $true
}


#endregion GUI }


#Write your logic code here

[void]$Form.ShowDialog()
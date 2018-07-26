#Void is a .NET parameter (sort of) that tells the method here to do the operation but be quiet about it
#begin to draw forms
#The Ampersand (&) has a special meaning in PowerShell.  It means Invoke, or Execute.  If we didn’t use this, PS would attempt to display the content of the variable instead.
#We’ll be using the Systems.Windows.Forms.Label (Abbreviated as simply Forms.whatever from now on), Forms. TextBox and Forms.Button controls to add the rest of our app for now.  While I’m here, if you’d like a listing of all of the available other .net controls you can make use of, check out this link: http://msdn.microsoft.com/en-us/library/system.windows.forms.aspx
#Some notes about this.  Location here is given in (x,y) with distances being pixels away from the upper left hand corner of the form.  Using this method of building a GUI from scratch, it is not uncommon to spend some time fiddling with the sizing by tweaking values and executing, back and forth.
#At this point you may be noticing a whole lot of forms form forms.  I know, there is a lot of retyping the same things.  In fact, this whole procedure is begging to be made into a simple New-Control function, but I haven’t had time to hash it out yet, maybe in a future post!  Also, one thing I want to draw attention to is the $OKButton.Add_Click; specifying this property will associate the contents of the $ping_computer_click variable (currently empty) as a function to execute when the button is clicked.  We’ll go over that in a future post!
#• If you don’t want the user to be able to resize your beautiful tool, then simply set $form.MaximumSize and $form.MinimumSize equal to $Form.Size.
#One of the cool things you can do with the System.Windows.Forms object is to modify it’s KeyPreview property to True and then add listeners for certain key presses to have your form respond to them. Basically if you enable KeyPreview, your form itself will intecept a key press and can do things with it before the control that is selected gets the press. So instead of the user having to click the X button or click enter, yowe can tell the form to do something when the user hits Escape or Enter instead.

#region Boring beginning stuff
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
#endregion
 
#region begin to draw forms
$Form = New-Object System.Windows.Forms.Form
$Form.Text = "Computer Pinging Tool"
$Form.Size = New-Object System.Drawing.Size(300,170)
$Form.StartPosition = "CenterScreen"
$Form.KeyPreview = $True
$Form.MaximumSize = $Form.Size
$Form.MinimumSize = $Form.Size
 
$label = New-Object System.Windows.Forms.label
$label.Location = New-Object System.Drawing.Size(5,5)
$label.Size = New-Object System.Drawing.Size(240,30)
$label.Text = "Type any computer name to test if it is on the network and can respond to ping"
$Form.Controls.Add($label)
$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Size(5,40)
$textbox.Size = New-Object System.Drawing.Size(120,20)
#$textbox.Text = "Select source PC:"
$Form.Controls.Add($textbox)
 
$ping_computer_click =
{
#region Actual Code
 
$statusBar1.Text = "Testing..."
$ComputerName = $textbox.Text
 
if (Test-Connection $ComputerName -quiet -Count 2){
Write-Host -ForegroundColor Green "Computer $ComputerName has network connection"
$result_label.ForeColor= "Green"
$result_label.Text = "System Successfully Pinged"
}
Else{
Write-Host -ForegroundColor Red "Computer $ComputerName does not have network connection"
$result_label.ForeColor= "Red"
$result_label.Text = "System is NOT Pingable"
}
 
$statusBar1.Text = "Testing Complete"
#endregion
}
 
$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(140,38)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click($ping_computer_click)
$Form.Controls.Add($OKButton)
 
$result_label = New-Object System.Windows.Forms.label
$result_label.Location = New-Object System.Drawing.Size(5,65)
$result_label.Size = New-Object System.Drawing.Size(240,30)
$result_label.Text = "Results will be listed here"
$Form.Controls.Add($result_label)
 
$statusBar1 = New-Object System.Windows.Forms.StatusBar
$statusBar1.Name = "statusBar1"
$statusBar1.Text = "Ready..."
$form.Controls.Add($statusBar1)
 
$Form.Add_KeyDown({if ($_.KeyCode -eq "Enter"){& $ping_computer_click}})
$Form.Add_KeyDown({if ($_.KeyCode -eq "Escape")
{$Form.Close()}})
#endregion begin to draw forms
 
#Show form
$Form.Topmost = $True
$Form.Add_Shown({$Form.Activate()})
[void] $Form.ShowDialog()
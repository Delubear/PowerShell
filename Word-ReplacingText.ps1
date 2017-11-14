Add-Type -AssemblyName Microsoft.Office.Interop.Word

$list = Get-ChildItem "path\*" -Recurse -Include "*.doc*"

foreach($item in $list){
$objWord = New-Object -comobject Word.Application
$objWord.Visible = $false
$objDoc = $objWord.Documents.Open($item.FullName)

$objSelection = $objWord.Selection
    
$objWord.Selection.Find.Text = "text to find"
if($objWord.Selection.Find.Execute()){
    $objWord.Selection.Text = "text to replace it with"
}
    
$objDoc.Save()
$objDoc.Close()
    
$objWord.Quit()
}
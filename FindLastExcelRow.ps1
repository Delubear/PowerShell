
$XLSoriginData = "path.xls"
$XLSfinalData = "P:\test.xlsm"
##CSV to File

$Excel = New-Object -ComObject excel.application
$Excel.visible = $true
$Excel.DisplayAlerts = $False
$xlup = -4162
$WorkBook = $excel.Workbooks.Open($XLSoriginData)
$WorkBook2 = $excel.Workbooks.open($XLSfinalData)
$Worksheet = $Workbook.WorkSheets.item(1)
$Worksheet.activate()

$rangeAc = $WorkSheet.Range("A2:G18")   ##Data to copy/move
$rangeAc.Copy() | out-null        

$Worksheet2 = $Workbook2.Worksheets.item(9)  ##change to be numeric month variable
$worksheet2.activate()   

$lastRow = $Worksheet2.Cells.Range("A1048576").End($xlup).row   #finds last used row, only run once since it will update after data is written using $nextrow
$nextRow = $lastRow + 1  #grabs the next row

$range = $Worksheet2.Range("A$nextRow")  #writes data to that last row to the specified column
$Worksheet2.paste($range)


#$Worksheet2.Paste($rangeAp)
#$workbook.close($false)
#$workbook2.SaveAs($file)
#$workbook2.close($false)    
#$Excel.Quit()
#[Runtime.Interopservices.Marshal]::ReleaseComObject($excel) # Release COM




##unused, didnt quite work right
#$lastRow = $Worksheet2.UsedRange.rows.count + 1
#$Excel.Range("A" + $lastRow).activate()
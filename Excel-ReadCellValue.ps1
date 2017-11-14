$excel = new-object -com Excel.Application -Property @{Visible = $false} 
$workbook = $excel.Workbooks.Open("path.xls")
$workbook.sheets.item(1).activate()
$WorkbookTotal=$workbook.Worksheets.item(1)

$value = $WorkbookTotal.Cells.Item(row#, column#).Text

$workbook.Close($false)
$excel.quit()
$filePath = "path.xlsx"

$excelObj = New-Object -ComObject Excel.Application

$excelObj.Visible = $true

$workBook = $excelObj.Workbooks.Open($filePath)

$workSheet = $workBook.Sheets.Item(1)

$workBook.worksheets.add()
$workBook.worksheets.add()
$workBook.worksheets.add()

$workBook.Save()

$excelObj.Quit()
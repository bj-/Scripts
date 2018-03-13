Attribute VB_Name = "CallModule"

Public Sub PercentFuelMarkUsing(sSource, TempWorkPage, AvgOctan, sRowAO, cdSource, CallFrom, cResult, YearSdvigX, sTarget)

' Вычисление процентного соотношения испльзования марок топлива
' ===============================================

Dim sSheet As String
Dim OctanIndex(100) As String
Dim TotalUsingFuel(100)
Dim TotalUsingFuelPercent(100)
Dim ResultArrayNameBySort(100)  ' такое же число как и максимальное значение для любых сортируемых данных
Dim ResultArrayNameByChild1(100)


MaxOctFuelIndex = 1
MaxOctFuelIntexTemp1 = 100      ' Примерное максимальное кол-во Марок топлива.
                                ' (указать число больше чем кол-во марок)
MaxSourceFuelLine = 100         ' Кол-во строк с исходными данными

FuelUsingPercentText = "Fuel Using %"  ' текст заголовка

Set sCells = Sheets(sSource).Cells
If CallFrom = "CompileReport" Then Set tCells = Sheets(sTarget).Cells
'==========================   C O D E   =============================

'================    Array Fuel Octan index

For temp1 = 1 To MaxOctFuelIntexTemp1
    If Sheets(TempWorkPage).Cells(temp1, 1) <> Empty Then
        OctanIndex(temp1) = Sheets(TempWorkPage).Cells(temp1, 1)
    Else
        MaxOctFuelIndex = temp1 - 1
        temp1 = MaxOctFuelIntexTemp1
    End If
Next temp1

'================


' Всего топлива использовано. по маркам.

For im = 1 To MaxSourceFuelLine
    For j = 1 To MaxOctFuelIndex
        If Not OctanIndex(j) = "" Then
            If sCells(im, cdSource(3)) = OctanIndex(j) Then
                TotalUsingFuel(j) = TotalUsingFuel(j) + Sheets(sSource).Cells(im, cdSource(2))
                TotalUsingFuelAll = TotalUsingFuelAll + Sheets(sSource).Cells(im, cdSource(2))
                j = MaxOctFuelIndex
            End If
        Else
            j = MaxOctFuelIndex
        End If
    Next j
Next im

TotalUsingFuelPercentOne = TotalUsingFuelAll / 100 ' величина в 1 % от использованного топлива

'Процентное соотношение марок использованного топлива
For ims = 1 To MaxSourceFuelLine
    If TotalUsingFuel(ims) <> "" Then
        TotalUsingFuelPercent(ims) = TotalUsingFuel(ims) / TotalUsingFuelPercentOne
    End If
Next ims



If CallFrom = "Update" Then   ' Если вызывали по кнопке Update то пишем в такие ячейки:
    ' Select Max
    Call CallModule.MaxValue(TotalUsingFuelPercent, MaxOctFuelIntexTemp1, ResultX, ResultY)
    ' write result
    Sheets(sSource).Cells(sRowAO, cdSource(3) - 1) = "" & OctanIndex(ResultY) & " :"
    Sheets(sSource).Cells(sRowAO, cdSource(3)) = ResultX & "%"
End If


'return a   ResultArrayNameBySort, ResultArrayNameByChild1
If CallFrom = "CompileReport" Then  'Если вызывали по кнопке Compile a report
    ' Sorting by max percent Fuel mark using
    Call CallModule.SortingTwoFieldDesc(TotalUsingFuelPercent, OctanIndex, MaxOctFuelIntexTemp1, ResultArrayNameBySort, ResultArrayNameByChild1)
    ' writing result

    tCells(YearSdvigX, cResult(8)) = FuelUsingPercentText  ' заголовок
    tCells(YearSdvigX, cResult(8)).Font.Bold = True
    FuelMarkSdvig = 1               ' каунтер для перехода на сл. строку
    For gh = 1 To MaxOctFuelIntexTemp1
        If ResultArrayNameBySort(gh) <> "" And ResultArrayNameByChild1(gh) <> "" Then
            tCells(YearSdvigX + FuelMarkSdvig, cResult(8)).NumberFormat = "@"
            tCells(YearSdvigX + FuelMarkSdvig, cResult(8)).HorizontalAlignment = -4152
            tCells(YearSdvigX + FuelMarkSdvig, cResult(8)) = ResultArrayNameByChild1(gh) & " :"
            tCells(YearSdvigX + FuelMarkSdvig, cResult(8) + 1) = ResultArrayNameBySort(gh) & "%"
            FuelMarkSdvig = FuelMarkSdvig + 1
        End If
    Next gh
End If
'Range("f3").NumberFormat = "General"

End Sub

Public Function SortingOneFieldDesc(ByVal ArrayNameBySort, ByVal MaxValue, ResultArrayNameBySort)

' Сортировка только одного поля без првязки к другому.

start:
    a = 1
    b = a + 1
    TransferCount = 0

ContinueSorting:
    
    If ArrayNameBySort(a) < ArrayNameBySort(b) Then
        tempx = ArrayNameBySort(a)
        ArrayNameBySort(a) = ArrayNameBySort(b)
        ArrayNameBySort(b) = tempx
        TransferCount = TransferCount + 1
    Else
        a = a + 1
        b = b + 1
    End If
    If b < MaxValue Then GoTo ContinueSorting
    If TransferCount > 0 Then GoTo start
    

For i = 0 To MaxValue
    'ResultArrayNameBySort
    ResultArrayNameBySort(i) = ArrayNameBySort(i)
Next i
End Function

Public Function SortingTwoFieldDesc(ByVal ArrayNameBySort, ByVal ArrayNameByChild1, ByVal MaxValue, ResultArrayNameBySort, ResultArrayNameByChild1)

' Сортировка только одного поля без првязки к другому.

'Dim ArrayNameByChild1(100)

start:
    a = 1
    b = a + 1
    TransferCount = 0

ContinueSorting:
    
    If ArrayNameBySort(a) < ArrayNameBySort(b) Then
        tempx = ArrayNameBySort(a)
        ArrayNameBySort(a) = ArrayNameBySort(b)
        ArrayNameBySort(b) = tempx
        tempY = ArrayNameByChild1(a)
        ArrayNameByChild1(a) = ArrayNameByChild1(b)
        ArrayNameByChild1(b) = tempY
        TransferCount = TransferCount + 1
    Else
        a = a + 1
        b = b + 1
    End If
    If b < MaxValue Then
        GoTo ContinueSorting
    End If
    If TransferCount > 0 Then
        GoTo start
    End If

'Dim ResultArrayNameBySort(100)

For i = 1 To MaxValue
    ResultArrayNameBySort(i) = ArrayNameBySort(i)
    ResultArrayNameByChild1(i) = ArrayNameByChild1(i)
Next i

End Function

Public Function MaxValue(ByVal ArrayName, ByVal MaxValues, ResultX, ResultY)

'ResultX -- Фактическое максимальное значение.
'ResultY -- номер для использования данных из массива

For a = 1 To MaxValues
    If a <= MaxValues - 1 Then
        If ArrayName(a) > ResultX Then
            ResultX = ArrayName(a)
            ResultY = a
        End If
    End If
Next a

End Function

Public Function CalculateTableSizeFuel(StartCells, ByVal SheetForSearth, cDate1, TableSize, EndRow)

' Вычисляем длину таблицы и первую строчку подписи.

Set sCells = Sheets(SheetForSearth).Cells

For i = StartCells To 65535
    If sCells(i, cDate1) = Empty And TableSize = Empty Then
        TableSize = i - 1
    Else
        If sCells(i, cDate1) = "No Change" And TableSize <> Empty Then
            EndRow = i + 1
            i = 65535
        End If
    End If
Next i

End Function

Public Function CalculateSumRowsValue(ByVal FirstRow, ByVal EndRow, ByVal ColumnNumber, ByVal SourceCells, SumResult)
' Вычисляем сумму значений в столбце

SumResult = Empty
CountRow = (EndRow + 1) - FirstRow

For i = 1 To CountRow
    SumResult = SumResult + SourceCells(FirstRow + (i - 1), ColumnNumber)
Next i

End Function


Public Function ClearSheet(ByVal SheetName, ByVal ClearMethod)

' ClearMethod - сообщает что именно надо очистить.
' Синтаксис:
'   "All"     - Все
'   "Formats" - Только формат
'   "Values"  - Только значения
'

If ClearMethod = "All" Or ClearMethod = "Values" Then
    Sheets(SheetName).Range("a1:h65535") = ""
End If

If ClearMethod = "All" Or ClearMethod = "Formats" Then
    Sheets(SheetName).Range("a1:h65535").Font.Bold = False
    Sheets(SheetName).Range("a1:h65535").HorizontalAlignment = 1
    Sheets(SheetName).Range("a1:h65535").MergeCells = False
End If

End Function




Public Function AddRow(ByVal SheetName, ByVal SearchInColoumn, ByVal SearchName, ByVal StartRow)

' добавляет строчку в таблицу
'   SheetName       - имя воркшита в котором производить все действия.
'   SearchInColoumn - в какой колонки искать (номер)
'   SearchName      - какой текст искать
'   StartRow        - с какой сточки искать

Set tCells = Sheets(SheetName).Cells

For i = StartRow To 65536
    If tCells(i, SearchInColoumn) = Empty And SelectCellsAfterCopy = Empty Then
        SelectCellsAfterCopy = i
    End If
    If tCells(i, SearchInColoumn) = SearchName Then
        CopiedRowNum = i - 1
        i = 65536
    End If
Next i

Rows(CopiedRowNum & ":" & CopiedRowNum).Select
Selection.Copy
Selection.Insert Shift:=xlDown

tCells(SelectCellsAfterCopy, SearchInColoumn).Select

End Function


Public Function WriteReport(ByVal sDateY, ByVal sDateM, ByVal sDateD, ByVal MilleAge, ByVal ManySum, ByVal SourceColumn, ByVal TDataCol, ByVal Formulas, ByVal TotalColumn, ByVal SourceSheet, ByVal TargetSheet, ByVal MaxParam)
' Записываем отчет.

'   NOT USED

' Исходные данные
'   SDateY          - год                               (Массив)
'   SDateM          - месяц                             (Массив)
'   SDateD          - день                              (Массив)
'   MilleAge        - пробег на данный день             (Массив)
'   ManySum         - Сумма затраченных средств в данный день (массив)
'   SourceColumn    - исходные колонки                  (Массив)
'   TDataCol        - Колонки в которые пишем           (Массив)
'   Formulas        - по какой формуле расчитывать      (Массив)
'   TotalColumn     - Всего колонок для работы
'   SourceSheet     - страница и исходными данными (sheet.name)
'   TargetSheet     - куда писать отчет. (sheet.name)
'   MaxParam        - Максимум параметров в массивах
'
' Not Use'   SDataDate       - Датацеликом                       (Массив)
'
' ============== Code
Dim RashodSum(15)           ' сумма расходов в месяц
Dim Probeg(15)              ' пробег по месяцам
FirstYearSdvig = 5

'Set sCells = Sheets(SourceSheet).Cells
Set tCells = Sheets(TargetSheet).Cells

' ======== Start and End Year

StartYear = sDateY(1)
For i = 1 To MaxParam
    If sDateY(i) > EndYear Then EndYear = sDateY(i)
    If sDateY(i) = Empty Then i = MaxParam
Next i
'EndYear = SDataY(ASrcTotalArrayCounter)
YearCounter = (EndYear - StartYear) + 1

' ======== Write data

Set sCells = Sheets(SourceSheet).Cells
Set tCells = Sheets(TargetSheet).Cells

For sYears = 1 To YearCounter          ' цикл по годам
CurYear = StartYear + sYears - 1       ' Какой сейчас год считаем

For sMonth = 1 To 12                            ' цикл по месяцам
RashodSum(sMonth) = Empty

For sParam = 1 To MaxParam
    If sDateY(sParam) = CurYear And sDateM(sParam) = sMonth Then ' тот-ли год и месяц
        ' Считаем сумму расходов для данного месяца
        RashodSum(sMonth) = RashodSum(sMonth) + ManySum(sParam)
        ' считаем пробег по месяцам
        If FirstMonthWithData = False And SkipChangeFirstMonthWithData = False Then
            FirstMonthWithData = True  ' Для правильного определения пробега в первом месяце.
        End If
        If FirstMonthWithData Then    ' стартовый пробег первого месяца.
            'ProbegStart = MilleAge(sParam)
            Probeg(sMonth - 1) = MilleAge(sParam)
            SkipChangeFirstMonthWithData = True
            FirstMonthWithData = False
        End If
        If sDateM(sParam + 1) = sMonth + 1 Or sDateY(sParam + 1) = CurYear + 1 Then ' записываем данные о пробеге.
            Probeg(sMonth) = MilleAge(sParam) - Probeg(sMonth - 1)
        End If
    Else
        If (sDateY(sParam) >= sYears And sDateM(sParam) > sMonth) Or sDateY(sParam) > sYears Then
            sParam = MaxParam ' Если проверять дальше бессмысленно -- берем следующий месяц/год.
        End If
    End If
Next sParam

' ======== Записываем результат для данного месяца.

YearSdvig = FirstYearSdvig + sYears - 1    ' с какой строчки начинается текущий год

If RashodSum(sMonth) <> Empty Then      ' записываем результат
    tCells(YearSdvig + 1 + sMonth, TDataCol(2)) = RashodSum(sMonth)
End If


Next sMonth
Next sYears

End Function

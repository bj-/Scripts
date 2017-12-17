Attribute VB_Name = "CarStatistics"
Sub StatisticsOfFuelDepletion(StartCells, sSource, sTarget, TempWorkPage, Date1, cDate1, dSource, cdSource, CallFrom)
' Macro for calculating:
'   1. Km per month
'   2. Fuel litres per month
'   3. Litres/100Km
'   3. Fuel price - RUR and USD
'   4. Dominanting fuel mark
'
' Write by Andy Smirnov (c) 2000
'


Dim MemoA(20) As String
Dim MemoB(20) As String
Dim Result(20) As String
Dim cResult(20)
Dim Mont(20) As String
Dim TotalResult(20) As String
Dim AverageResult(20) As String

NationalCurrency = "RUR" ' National currency code
SummOperator = "sum"    ' For National Localisation

MaxStart = StartCells + 10   ' Max line for start find data source

MaxParameters = 10      ' Maximum coloumn with data

Result(8) = "a"         ' Month name
cResult(8) = 1
Result(1) = "b"         ' Result - Km per month
cResult(1) = "2"
Result(7) = "c"         ' Result - Litres/100 km
cResult(7) = "3"
Result(2) = "d"         ' Result - Litres per month
cResult(2) = "4"
Result(3) = "e"         ' Result - Octan
cResult(3) = "5"
Result(4) = "f"         ' Result - RUR per month
cResult(4) = "6"
Result(5) = "g"         ' Result - USD per month
cResult(5) = "7"
Result(6) = "h"         ' Result - rub/litr
cResult(6) = "8"

ResultCount = 7         ' Count Result argument

StartColun = "a"        ' первая и последняя колонки таблицы
EndColumn = "h"

FirstYearSdvig = 4      ' Free line on Result sheet before report
YearLen = 16            ' Year len (Line count per year -- 12 month + 'Average' and 'Total' line)

Mont(1) = "January"     ' Month Name
Mont(2) = "February"
Mont(3) = "March"
Mont(4) = "April"
Mont(5) = "May"
Mont(6) = "June"
Mont(7) = "July"
Mont(8) = "August"
Mont(9) = "September"
Mont(10) = "October"
Mont(11) = "November"
Mont(12) = "December"

' Advanced Settings
sTotal = "TOTAL:"               ' Total sum on years
sAverage = "Average:"           ' Average sum on years
sATotal = "Total:"              ' Total for All Years
sAAverage = "Average:"          ' Average for All Month

'Set tCells = Sheets(sTarget).Cells

' ===========================   C o d e   ==========================

' сбрасываем форматирование and clear table
Call CallModule.ClearSheet(Sheets(sTarget).Name, "All")

' ==============   Calculating Table Size   ==============

Call CallModule.CalculateTableSizeFuel(StartCells, sSource, cDate1, TableSize, EndRow)

' ==============   Calculating Start and End Year   ==============

For i = StartCells To MaxStart                        ' Identify start year
    If Year(Sheets(sSource).Range(Date1 & i)) <> 1899 And i < MaxStart Then
        StartYear = Year(Sheets(sSource).Range(Date1 & StartCells))
    End If
Next i

EndYear = Year(Sheets(sSource).Range(Date1 & TableSize))

YearCounter = (EndYear - StartYear) + 1

' ===============   Write Report   ===============

For yr = StartYear To EndYear

YearSdvig = (yr - StartYear) * YearLen + FirstYearSdvig

' ===============   Make Header   ===============

If yr = StartYear Then              ' Make Table Header
    'Title
    Sheets(sTarget).Range(StartColun & "1:" & EndColumn & "1").MergeCells = True
    Sheets(sTarget).Cells(1, 1) = Sheets(sSource).Cells(2, 2)
    Sheets(sTarget).Cells(1, 1).Font.Bold = True
    Sheets(sTarget).Cells(1, 1).Font.Size = 16
    Sheets(sTarget).Cells(1, 1).HorizontalAlignment = -4108
    ' Header
    Sheets(sTarget).Range(Result(8) & FirstYearSdvig - 1) = "Month"
    Sheets(sTarget).Range(Result(1) & FirstYearSdvig - 1) = "Milleage"
    Sheets(sTarget).Range(Result(7) & FirstYearSdvig - 1) = "Litres/100Km"
    Sheets(sTarget).Range(Result(2) & FirstYearSdvig - 1) = "Litres"
    Sheets(sTarget).Range(Result(3) & FirstYearSdvig - 1) = "Octan"
    Sheets(sTarget).Range(Result(4) & FirstYearSdvig - 1) = NationalCurrency
    Sheets(sTarget).Range(Result(5) & FirstYearSdvig - 1) = "USD"
    Sheets(sTarget).Range(Result(6) & FirstYearSdvig - 1) = NationalCurrency & " / litre"
    For i = 1 To MaxParameters
        If Result(i) <> Empty Then
            Sheets(sTarget).Range(Result(i) & FirstYearSdvig - 1).Font.Bold = True
            'Range(Result(i) & FirstYearSdvig).
        End If
    Next i
End If
For i = 1 To 12
    Sheets(sTarget).Range(Result(8) & YearSdvig + i) = Mont(i)
Next i
Sheets(sTarget).Range(StartColun & YearSdvig & ":" & EndColumn & YearSdvig).MergeCells = True
Sheets(sTarget).Range(Result(8) & YearSdvig) = "Year " & yr
Sheets(sTarget).Range(Result(8) & YearSdvig).Font.Bold = True
Sheets(sTarget).Range(Result(8) & YearSdvig).HorizontalAlignment = -4108


For Mon = 1 To 12           ' Zapolnyaem dannye

'Sheets(sSource).Select

For cs = StartCells To TableSize                              ' Opredelyaet pervuyu yacheyku s nujnym mesyatsem
    If Sheets(sSource).Range(Date1 & cs) = "" And cs < MaxStart Then          ' Ishem pervuyu zapis
    Else
        If Year(Sheets(sSource).Range(Date1 & cs)) = yr Then
            If Month(Sheets(sSource).Range(Date1 & cs)) = Mon Then
                If cs = StartCells Then
                    MemoA(1) = dSource(1) & cs     ' for correctly calkulating sum of Km per month
                Else
                    MemoA(1) = dSource(1) & cs - 1
                End If
                For i = 2 To MaxParameters
                    MemoA(i) = dSource(i) & cs
                Next i
                del1 = cs                       ' del2 - del1 = kol-vo zapisey
                cs = 1000
            End If
        End If
    End If
Next cs

If del1 <> Empty Then
For c2 = del1 + 1 To TableSize + 1 ' Opredelyaet poslednuyu yacheyku s nujnym mesyatsem
    If Sheets(sSource).Range(Date1 & c2) = "" And c2 < MaxStart Then           ' Opredelyaem poslednuu zapis
    Else
        If Year(Sheets(sSource).Range(Date1 & c2)) = yr Or Year(Sheets(sSource).Range(Date1 & c2)) = 1899 Then
            If Sheets(sSource).Range(Date1 & c2) = Empty Or Month(Sheets(sSource).Range(Date1 & c2)) = Mon + 1 Then
                For i = 1 To MaxParameters
                    MemoB(i) = dSource(i) & c2 - 1
                Next i
                del2 = c2                       ' del2 - del1 = kol-vo zapisey
                c2 = 1000
            End If
        Else
            If Year(Sheets(sSource).Range(Date1 & c2)) = yr + 1 Then
                For i = 1 To MaxParameters
                    MemoB(i) = dSource(i) & c2 - 1
                Next i
                del2 = c2                       ' del2 - del1 = kol-vo zapisey
                c2 = 1000
            End If
        End If
    End If
Next c2
End If

delr = del2 - del1          ' kol-vo zapisey v mesyatse

If MemoA(1) = Empty Or MemoA(2) = Empty Then
Else
    If Sheets(sSource).Range(MemoA(1)) = Empty Or Sheets(sSource).Range(MemoA(2)) = Empty Then    ' poverka nalichia dannyh
    Else
        'Sheets(sTarget).Select
        Sheets(sTarget).Range(Result(1) & Mon + YearSdvig) = "=" & SummOperator & "('" & sSource & "'!" & MemoB(1) & "-'" & sSource & "'!" & MemoA(1) & ")"   ' zapisyvaet operator =SUM(memoA:memoB)
        Sheets(sTarget).Range(Result(2) & Mon + YearSdvig) = "=" & SummOperator & "('" & sSource & "'!" & MemoA(2) & ":" & MemoB(2) & ")"
        Sheets(sTarget).Range(Result(3) & Mon + YearSdvig) = "=" & SummOperator & "(" & SummOperator & "('" & sSource & "'!" & MemoA(3) & ":" & MemoB(3) & ")/" & delr & ")"
        Sheets(sTarget).Range(Result(4) & Mon + YearSdvig) = "=" & SummOperator & "('" & sSource & "'!" & MemoA(4) & ":" & MemoB(4) & ")"
        Sheets(sTarget).Range(Result(5) & Mon + YearSdvig) = "=" & SummOperator & "('" & sSource & "'!" & MemoA(5) & ":" & MemoB(5) & ")"
        Sheets(sTarget).Range(Result(6) & Mon + YearSdvig) = "=" & SummOperator & "(" & SummOperator & "('" & sSource & "'!" & MemoA(6) & ":" & MemoB(6) & ")/" & delr & ")"
        Sheets(sTarget).Range(Result(7) & Mon + YearSdvig) = "=" & SummOperator & "(" & Result(2) & Mon + YearSdvig & "/(sum(" & Result(1) & Mon + YearSdvig & "/100)))"
        For i = 1 To MaxParameters * 2
            MemoA(i) = Empty
            MemoB(i) = Empty
        Next i
    End If
End If

Next Mon

' =================== Total Rows =======================
'Sheets(sTarget).Select

RowInYearStart = Empty
RowInYearEnd = Empty

For i = 1 To 13
    If Sheets(sTarget).Range(Result(1) & YearSdvig + i) <> Empty And RowInYearStart = Empty Then
        RowInYearStart = i
    Else
        If Sheets(sTarget).Range(Result(1) & YearSdvig + i) = Empty And RowInYearStart <> Empty Then
            RowInYearEnd = i
            i = 13
        End If
    End If
Next i

RowInYear = RowInYearEnd - RowInYearStart           ' Kol-vo zapisey v godu

For i = 1 To ResultCount   ' Average Result
Sheets(sTarget).Range(Result(i) & YearSdvig + 13) = "=" & SummOperator & "(" & SummOperator & "(" & Result(i) & YearSdvig + 1 & ":" & Result(i) & YearSdvig + 12 & ")/" & RowInYear & ")"
Sheets(sTarget).Range(Result(i) & YearSdvig + 13).Font.Bold = True
Next i
Sheets(sTarget).Range(Result(8) & YearSdvig + 13) = sAverage
Sheets(sTarget).Range(Result(8) & YearSdvig + 13).Font.Bold = True

Sheets(sTarget).Range(Result(1) & YearSdvig + 14) = "=" & SummOperator & "(" & Result(1) & YearSdvig + 1 & ":" & Result(1) & YearSdvig + 12 & ")"
Sheets(sTarget).Range(Result(2) & YearSdvig + 14) = "=" & SummOperator & "(" & Result(2) & YearSdvig + 1 & ":" & Result(2) & YearSdvig + 12 & ")"
Sheets(sTarget).Range(Result(4) & YearSdvig + 14) = "=" & SummOperator & "(" & Result(4) & YearSdvig + 1 & ":" & Result(4) & YearSdvig + 12 & ")"
Sheets(sTarget).Range(Result(5) & YearSdvig + 14) = "=" & SummOperator & "(" & Result(5) & YearSdvig + 1 & ":" & Result(5) & YearSdvig + 12 & ")"
Sheets(sTarget).Range(Result(1) & YearSdvig + 14).Font.Bold = True
Sheets(sTarget).Range(Result(2) & YearSdvig + 14).Font.Bold = True
Sheets(sTarget).Range(Result(4) & YearSdvig + 14).Font.Bold = True
Sheets(sTarget).Range(Result(5) & YearSdvig + 14).Font.Bold = True
Sheets(sTarget).Range(Result(8) & YearSdvig + 14) = sTotal
Sheets(sTarget).Range(Result(8) & YearSdvig + 14).Font.Bold = True

' ================== Total on All Year =================

For i = 1 To MaxParameters
    If AverageResult(i) = Empty Then AverageResult(i) = 0
    If TotalResult(i) = Empty Then TotalResult(i) = 0
    If Result(i) <> Empty Then
        If Sheets(sTarget).Range(Result(i) & YearSdvig + 14) <> sTotal And Sheets(sTarget).Range(Result(i) & YearSdvig + 13) <> sAverage Then
            AverageResult(i) = AverageResult(i) + Sheets(sTarget).Range(Result(i) & YearSdvig + 13)
            TotalResult(i) = TotalResult(i) + Sheets(sTarget).Range(Result(i) & YearSdvig + 14)
        End If
    End If
Next i

Next yr

For i = 1 To MaxParameters
    If Result(i) <> Empty Then
        Sheets(sTarget).Range(Result(i) & YearSdvig + 16) = AverageResult(i) / YearCounter
        Sheets(sTarget).Range(Result(i) & YearSdvig + 16).Font.Bold = True
        If TotalResult(i) <> 0 Then
            Sheets(sTarget).Range(Result(i) & YearSdvig + 17) = TotalResult(i)
        End If
        Sheets(sTarget).Range(Result(i) & YearSdvig + 17).Font.Bold = True
    End If
Next i
Sheets(sTarget).Range(Result(8) & YearSdvig + 16) = sAAverage
Sheets(sTarget).Range(Result(8) & YearSdvig + 17) = sATotal

YearSdvigX = YearSdvig + 19
Call CallModule.PercentFuelMarkUsing(sSource, TempWorkPage, AvgOctan, sRowAO, cdSource, CallFrom, cResult, YearSdvigX, sTarget)

End Sub



Public Sub StatisticsOfMaintranceCosts()
' Считаем статистику пррасходам на содержание машины ( отчет )

'переменные
Dim StartCells


StartCells = 4
MaintCostsSheet = MaintenanceCosts.Name   ' исходная страница
ReportSheet = MaintenanceCostsReport.Name ' Страница с отчетом

cDate1 = 1      ' колонка с датами
MilleAge = 2    ' Колонка с пробегом

Set mCells = Sheets(MaintCostsSheet).Cells

' ===========================   C o d e   ==========================


' ==============   Calculating Table Size   ==============

'считаем длину таблицы
Call CallModule.CalculateTableSizeFuel(StartCells, MaintCostsSheet, cDate1, TableSize, EndRow)
'интересует только EndRow

EndRow = EndRow - 2

TableLen = (EndRow + 1) - StartCells ' полезная длина таблицы

' ====   Calculating Start and End Year For table with spaces on Data column  =============

'StartCells, MaxStart, sSource, StartYear, EndYear

'StartCells
'TableLen
'EndRow

Dim ASrcDateY(10000)            ' \  Набмраем массив для качественного опередения
Dim ASrcDateM(10000)            '  > даты времени
Dim ASrcDateD(10000)            ' /
Dim ASrcDate(10000)             ' Просто массив изначальных дат
Dim ASrcFirstRow(10000)         ' \первая и последняя строка для каждой даты.
Dim ASrcEndRow(10000)           ' /
Dim ASrcMilleAge(10000)         ' Пробег в данный день
Dim ASrcSum(10000)              ' Сумма затраченных средств в данный день.
MaxParamForArray = 10000        ' Кол-во максимальных параметров.

For i = StartCells To EndRow
    If mCells(i, cDate1) <> "" And i = StartCells Then
        a = 1
        ASrcDateY(a) = Year(mCells(i, cDate1))
        ASrcDateM(a) = Month(mCells(i, cDate1))
        ASrcDateD(a) = Day(mCells(i, cDate1))
        ASrcDate(a) = mCells(i, cDate1)
        ASrcMilleAge(a) = mCells(i, MilleAge)
        ASrcFirstRow(a) = i
    End If
    If mCells(i, cDate1) <> "" And i > StartCells Then
        a = a + 1
        ASrcDateY(a) = Year(mCells(i, cDate1))
        ASrcDateM(a) = Month(mCells(i, cDate1))
        ASrcDateD(a) = Day(mCells(i, cDate1))
        ASrcDate(a) = mCells(i, cDate1)
        ASrcMilleAge(a) = mCells(i, MilleAge)
        ASrcFirstRow(a) = i
        ASrcEndRow(a - 1) = i - 1
    End If
    If i = EndRow Then
        ASrcEndRow(a) = i - 1
    End If
    ASrcTotalArrayCounter = a
Next i

For i = 1 To ASrcTotalArrayCounter   ' Считаем сумму затраченных стредств
    Call CallModule.CalculateSumRowsValue(ASrcFirstRow(i), ASrcEndRow(i), 9, mCells, SumResult)
    ASrcSum(i) = SumResult
Next i


'======= Write Report

'Set RmcCells = Sheet(MaintenanceCostsReport).Cells

Dim tColumn(20)

'DateCol = 1
tColumn(1) = 3  ' Milleage
tColumn(2) = 7  ' Cost

'tColumn(1) = Empty        ' Date
'tColumn(2) = 3            ' Milleage
'tColumn(3) = Empty        ' Costs USD - Repair
'tColumn(4) = 7            ' Costs USD - запчасти / предметы из накладных расходов
'tColumn(5) = Empty        '
'tColumn(6) = Empty        '
'tColumn(7) = Empty        '
'tColumn(8) = Empty        '
'tColumn(9) = Empty        '
'tColumn(10) = Empty       '

TotalColumn = 2

'Stop

Call CallModule.WriteReport(ASrcDateY, ASrcDateM, ASrcDateD, ASrcMilleAge, ASrcSum, "xxx", tColumn, "xxx", TotalColumn, MaintCostsSheet, ReportSheet, MaxParamForArray)


'================ Приводим месяц к двухзначному числу.

End Sub

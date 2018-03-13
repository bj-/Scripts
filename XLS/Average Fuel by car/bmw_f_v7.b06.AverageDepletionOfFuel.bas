Attribute VB_Name = "AverageDepletionOfFuel"
Sub AverageDepletionOfFuel(StartCells, sSource, TempWorkPage, Date1, cDate1, dSource, cdSource, CallFrom)

Dim SummOperator As String

SummOperator = "sum"    ' For National Localisation

AvDepFuel = 6    ' Result Colunn
AvgOctan = 5
AvgRUR = 6
AvgUSD = 7
AvgRurLi = 8
AvgLi = 4

Set sCells = Sheets(sSource).Cells

' ==============   Calculating Table Size   ==============

Call CallModule.CalculateTableSizeFuel(StartCells, sSource, cDate1, TableSize, EndRow)

LineCount = TableSize - (StartCells - 1)


' ==============  Write Result

sCells(EndRow + 7, AvDepFuel) = "=" & SummOperator & "(" & SummOperator & "(" & dSource(2) & StartCells & ":" & dSource(2) & TableSize & ")/" & SummOperator & "(" & SummOperator & "(" & dSource(1) & TableSize + 1 & "-" & dSource(1) & StartCells & ")/100))"
sCells(EndRow, AvgLi) = "=" & SummOperator & "(" & SummOperator & "(" & dSource(2) & TableSize & ":" & dSource(2) & StartCells & ")/" & LineCount & ")"
'Sheets(sSource).Range(AvgOctan & sRow + 1) = "=" & SummOperator & "(" & SummOperator & "(" & dSource3 & TableSize & ":" & dSource3 & StartCells & ")/" & LineCount & ")"
sCells(EndRow + 2, AvgRUR) = "=" & SummOperator & "(" & SummOperator & "(" & dSource(4) & TableSize & ":" & dSource(4) & StartCells & ")/" & LineCount & ")"
sCells(EndRow + 3, AvgUSD) = "=" & SummOperator & "(" & SummOperator & "(" & dSource(5) & TableSize & ":" & dSource(5) & StartCells & ")/" & LineCount & ")"
sCells(EndRow + 4, AvgRurLi) = "=" & SummOperator & "(" & SummOperator & "(" & dSource(6) & TableSize & ":" & dSource(6) & StartCells & ")/" & LineCount & ")"


' ================ write Max percent fuel mark using

sRowAO = EndRow + 1

Call CallModule.PercentFuelMarkUsing(sSource, TempWorkPage, AvgOctan, sRowAO, cdSource, CallFrom, cResult, YearSdvigX, sTarget)

End Sub

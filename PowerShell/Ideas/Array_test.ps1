

$myArray[0] = "col1","Hello",3.5,"World"
$myArray[1] = 1,"Hello",3.5,"World"

$myArray2 = @(
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="1";ColB="Hello";ColC="Hello";CoLd="Hello"},
            @{ColA="2";ColB="Hello";ColC="Hello";CoLd="Hello"}
#            (ColA="3";"Hello",3.5,"World"),
#            (ColA="4","Hello",3.5,"World"),
#            (ColA="5","Hello",3.5,"World")
            )


# write-host $myArray
$myArray2  | Format-Table # -AutoSize  # -GroupBy "ColB"



#Write-Host "ColumnA`tColumnB`tColumnC"
#Write-Host "D`tD`tF"
#Write-Host "{0}'t{1}'t{3}" –f $data1,$data2,$data3

#Get-ChildItem "C:\Windows" -Name
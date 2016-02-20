@echo off
cls
echo "Можно запускать до наступления нирваны"

echo "Убиваем Хаб сервер"
taskkill.exe /f /im hubserver.exe

echo "Хаотично и без спросу удаляем очереди"
del c:\shturman\bin\hub*.queue /s
del c:\shturman\bin\*.queue /s
del D:\shturman\bin\*.queue /s
del G:\shturman\bin\*.queue /s

echo "Стартим Хаб сервер"
net start ShturmanHub

echo "...Можно повторить..."

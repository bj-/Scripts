@echo off
cls
echo "����� ����᪠�� �� ����㯫���� ��ࢠ��"

echo "������� ��� �ࢥ�"
taskkill.exe /f /im hubserver.exe

echo "����筮 � ��� ���� 㤠�塞 ��।�"
del c:\shturman\bin\hub*.queue /s
del c:\shturman\bin\*.queue /s
del D:\shturman\bin\*.queue /s
del G:\shturman\bin\*.queue /s

echo "���⨬ ��� �ࢥ�"
net start ShturmanHub

echo "...����� �������..."

Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\Shturman.ini');

  IniFile.WriteString('Update.Client', 'Component', 'ShturmanOnBoardInUpd');
  IniFile.Closefile;
end.


Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\update.ini');

  IniFile.WriteString('Update', 'Version', '0.14.3');
  IniFile.Closefile;
end.
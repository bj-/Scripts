                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\Shturman.ini');

  IniFile.WriteString('Update.Client', 'Component', 'ShturmanOnBoard1');
  IniFile.Closefile;
end.


Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\Shturman.ini');

  IniFile.WriteString('MainUnit', 'BaudRate', '57600');
  IniFile.Closefile;
end.


Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\update.ini');

  IniFile.WriteString('Update', 'Version', '0.14.3');
  IniFile.Closefile;
end.

Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\Shturman.ini');

  IniFile.WriteString('ModemPort', 'ExtVPNLogin', 'ST\Block');
  IniFile.Closefile;
end.


Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\Shturman.ini');

  IniFile.WriteString('BlueGiga', 'Send10Percent', '1');
  IniFile.Closefile;
end.

type shturman.ini
net stop ShturmanBlueGiga
net start ShturmanBlueGiga





Program p1;
begin
IniFile.SetFileName('C:\Shturman\Bin\Shturman.ini');

  IniFile.WriteString('HubBridge.Pool', 'Gate01', '192.168.51.85:45796');
  IniFile.WriteString('HubBridge.Pool', 'Gate02', '192.168.51.85:45796');
  IniFile.Closefile;
end.

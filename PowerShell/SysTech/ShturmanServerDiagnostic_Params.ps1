	[string]$ServerName = "Root4" # Название для шапки (в скрипте)
	[string]$ServerAlias = "Root" # Реальный алиас хабсервера из ini файла
	[string]$ServerDriveSystem = "C:"
	[string]$ServerDriveShturman = "D:"
	[string]$ServerLocalPath = "D:\Shturman"
	[string]$ServerLocalQueuePath = "D:\Shturman\Bin"
	[string]$ServerLocalLogPath = "D:\Shturman\Logs"
	[string]$ServerLocalErrorsPath = "D:\Shturman\Bin\Errors"
	[string]$ServerLocalMessagesAndFramesPath = "D:\Shturman\Bin\Log"
	[array]$ServerServicesLogRequired = 
#                                        ("BOINorms","Data","Diag","FOS","Hub","Log","Location","RRs","Update") # Root4
                                        ("Data","Diag","Hub","Log","Update") # Root4
#                                        ("BOINorms","Data","FOS","Hub","Log","Location","RRs")                 # SuperRoot
#                                        ("Hub","Log")                                                          # Gate02
#                                        ("Https", "Data","Hub","Log","Solver")                                 # Root3
#                                        ("Https", "Data","Hub","Log","Fresher","Solver","DataTransfer")        # Anal
	[array]$ServerServicesExeRequired = 
#                                        ("HttpsServer","BOINormsServer","DataStorageServer","DiagServer","FOSServer","HubServer","LogServer3","MetroLocationsServer","RRsServer","UpdateServer")  # Root4
                                        ("DataStorageServer","DiagServer","","HubServer","LogServer3","UpdateServer")  # Root4
#                                        ("BOINormsServer","DataStorageServer","FOSServer","HubServer","LogServer3","MetroLocationsServer","RRsServer")                              # SuperRoot
#                                        ("HubServer","LogServer3")                                                                                                                  # Gate02
#                                        ("HttpsServer", "DataStorageServer","HubServer","LogServer","SolverServer")                                                                 # Root3
#                                        ("HttpsServer", "DataStorageServer","HubServer","LogServer","FresherServer","SolverServer","DataTransferServer")                            # Anal


	[string]$SQLServerDBName = "Shturman_Metro" # имя БД
#                                "Shturman3"# имя БД
	[bool]$SQL = $FALSE
	[array]$SQLQueries = ( # Выполняемые запросы
                            (
                                "BlockLastConnect",
                                "Block Conn Time (ago)",
                                "SELECT TOP 1 DateDiff(SECOND,MAX([Connected]),GetDate()) AS [TimeAgo] FROM [servers] WHERE [SerialNo] LIKE 'STB%'"  # Запрос
                            ),
                            (
                                "DriversOnTrains",
                                "Drivers on trains",
                                "SELECT count(*) AS [cnt] FROM SensorsCardio sc, Sensors s, Servers sv, Vehicles ve, MetroTrains mt, users u, persons p where sc.Guid = s.guid and sc.UserGuid = u.Guid and u.PersonsGuid = p.Guid and sc.ServersGuid =sv.Guid and ve.Guid = mt.Guid and mt.IsActive = 1 and sc.IsConnected = 1  and sc.UserGuid = ve.UsersGuid"
                            )
                         )

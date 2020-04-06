	[string]$ServerName = "Root4H4" # Название для шапки (в скрипте)
	[string]$ServerAlias = "Root" # Реальный алиас хабсервера из ini файла
	[string]$ServerDriveSystem = "C:"
	[string]$ServerDriveShturman = "D:"
	[string]$ServerLocalPath = "D:\Shturman"
	[string]$ServerLocalQueuePath = "D:\Shturman4\BIN"
	[string]$ServerLocalLogPath = "D:\Shturman4\BIN\Log"
	[string]$ServerLocalErrorsPath = "D:\Shturman4\BIN\Errors"
	[string]$ServerLocalMessagesAndFramesPath = "D:\Shturman4\BIN\Log"
	[array]$ServerServicesLogRequired = 
#                                        ("BOINorms","Data","Diag","FOS","Hub","Log","Location","RRs","Update") # Root4
#                                        ("BOINorms","Data","FOS","Hub","Log","Location","RRs")                 # SuperRoot
                                        ("Hub4")        # SuperRoot
#                                        ("Log")                 # SuperRoot
#                                        ("Hub","Log")                                                          # Gate02
#                                        ("Https", "Data","Hub","Log","Solver")                                 # Root3
#                                        ("Https", "Data","Hub","Log","Fresher","Solver","DataTransfer")        # Anal
	[array]$ServerServicesExeRequired = 
#                                        ("HttpsServer","BOINormsServer","DataStorageServer","DiagServer","FOSServer","HubServer","LogServer3","MetroLocationsServer","RRsServer","UpdateServer")  # Root4
#                                        ("BOINormsServer","DataStorageServer","FOSServer","HubServer","LogServer3","MetroLocationsServer","RRsServer")                              # SuperRoot
                                        ("ShturmanHub")                # SuperRoot
#                                        ("LogServer3")                              # SuperRoot
#                                        ("HubServer","LogServer3")                                                                                                                  # Gate02
#                                        ("HttpsServer", "DataStorageServer","HubServer","LogServer","SolverServer")                                                                 # Root3
#                                        ("HttpsServer", "DataStorageServer","HubServer","LogServer","FresherServer","SolverServer","DataTransferServer")                            # Anal


	[bool]$SQL = $FALSE

	SET NOCOUNT ON;

	DECLARE @LogMessage NVARCHAR(MAX) = '';

	DECLARE @MinimumDate DATETIME2(7) = DATEADD(DAY, -3, GETDATE());
	
	-- AccDAta
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM AccData
			WHERE Measured > @MinimumDate;
		SET @LogMessage = @LogMessage + 'AccData: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'AccData: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- Journal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM Journal
			WHERE Created > @MinimumDate;
		SET @LogMessage = @LogMessage + 'Journal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'Journal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- ModemsCells
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM ModemsCells
			WHERE Created > @MinimumDate;
		SET @LogMessage = @LogMessage + 'ModemsCells: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'ModemsCells: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- ModemsPowers
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM ModemsPowers
			WHERE Created > @MinimumDate;
		SET @LogMessage = @LogMessage + 'ModemsPowers: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'ModemsPowers: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- ModemsSms
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM ModemsSms
			WHERE Created > @MinimumDate;
		SET @LogMessage = @LogMessage + 'ModemsSms: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'ModemsSms: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- SensorsDataRRSO2
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM SensorsDataRRSO2
			WHERE Received > @MinimumDate;
		SET @LogMessage = @LogMessage + 'SensorsDataRRSO2: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'SensorsDataRRSO2: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- SensorsEJournalStatic
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM SensorsEJournalStatic
			WHERE StateChanged > @MinimumDate;
		SET @LogMessage = @LogMessage + 'SensorsEJournalStatic: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'SensorsEJournalStatic: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- StateValues
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM StateValues
			WHERE Calculated > @MinimumDate;
		SET @LogMessage = @LogMessage + 'StateValues: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'StateValues: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	--StateValuesNormalStorage
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM StateValuesNormalStorage
		FROM StateValuesNormalStorage
			INNER JOIN StateValuesNormal ON StateValuesNormalGuid = StateValuesNormal.Guid
		WHERE Calculated > @MinimumDate;
		SET @LogMessage = @LogMessage + 'StateValuesNormalStorage: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'StateValuesNormalStorage: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	--StateValuesStorageNew
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM StateValuesStorageNew
			WHERE Calculated > @MinimumDate;
		SET @LogMessage = @LogMessage + 'StateValuesStorageNew: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'StateValuesStorageNew: ' + ERROR_MESSAGE() + ', ';
	END CATCH


	-- DriversSignals
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM DriversSignals
			WHERE Played > @MinimumDate;
		SET @LogMessage = @LogMessage + 'DriversSignals: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'DriversSignals: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- SensorsBatteryJournal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM SensorsBatteryJournal
			WHERE Changed > @MinimumDate;
		SET @LogMessage = @LogMessage + 'SensorsBatteryJournal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'SensorsBatteryJournal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- SensorsData
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM SensorsData
			WHERE Finished > @MinimumDate;
		SET @LogMessage = @LogMessage + 'SensorsData: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'SensorsData: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- SensorsJournal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM SensorsJournal
			WHERE Changed > @MinimumDate;
		SET @LogMessage = @LogMessage + 'SensorsJournal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'SensorsJournal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- ServersJournal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM ServersJournal
			WHERE Changed > @MinimumDate;
		SET @LogMessage = @LogMessage + 'ServersJournal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'ServersJournal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- ServersOnBoardJournal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM ServersOnBoardJournal
			WHERE Started > @MinimumDate;
		SET @LogMessage = @LogMessage + 'ServersOnBoardJournal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'ServersOnBoardJournal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- ServersPositionsHistory
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM ServersPositionsHistory
			WHERE Received > @MinimumDate;
		SET @LogMessage = @LogMessage + 'ServersPositionsHistory: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'ServersPositionsHistory: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- Sessions
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM Sessions
			WHERE Finished > @MinimumDate;
		SET @LogMessage = @LogMessage + 'Sessions: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'Sessions: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- StateValuesNew
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM StateValuesNew
			WHERE Calculated > @MinimumDate;
		SET @LogMessage = @LogMessage + 'StateValuesNew: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'StateValuesNew: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	--StateValuesNormal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM StateValuesNormal
			WHERE Calculated > @MinimumDate;
		SET @LogMessage = @LogMessage + 'StateValuesNormal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'StateValuesNormal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- TrainsTimeTables
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM TrainsTimeTables
			WHERE Finished > @MinimumDate;
		SET @LogMessage = @LogMessage + 'TrainsTimeTables: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'TrainsTimeTables: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- UsersJournal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM UsersJournal
			WHERE Finished > @MinimumDate;
		SET @LogMessage = @LogMessage + 'UsersJournal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'UsersJournal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- UsersMedicalInspections
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM UsersMedicalInspections
			WHERE InspectionsDate > @MinimumDate;
		SET @LogMessage = @LogMessage + 'UsersMedicalInspections: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'UsersMedicalInspections: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	-- UsersMedicalInspectionsSending
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM UsersMedicalInspectionsSending
			WHERE Sended > @MinimumDate;
		SET @LogMessage = @LogMessage + 'UsersMedicalInspectionsSending: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'UsersMedicalInspectionsSending: ' + ERROR_MESSAGE();
	END CATCH

	-- ServersTrafficJournal
	BEGIN TRAN T;
	BEGIN TRY
		DELETE FROM ServersTrafficJournal
			WHERE [Day] > @MinimumDate;
		SET @LogMessage = @LogMessage + 'ServersTrafficJournal: '+ CAST(@@ROWCOUNT AS VARCHAR(10)) + ', ';
		COMMIT TRAN T;
	END TRY
	BEGIN CATCH
		IF @@TRANCOUNT > 0
			ROLLBACK TRAN T;
		SET @LogMessage = @LogMessage + 'ServersTrafficJournal: ' + ERROR_MESSAGE() + ', ';
	END CATCH

	PRINT @LogMessage
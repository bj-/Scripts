/*  �������� � ������ ���� (��������� ���������� ���� ���� ������������� �� �����   */
select 
	u.Guid,
	p.LastName,
	u.RolesGuid, 
	u.Rights
FROM users as [u]
INNER JOIN Persons as [p] ON u.PersonsGuid = p.Guid

where IsActive = 1
and RolesGuid IN ('00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000004')
ORDER BY RolesGuid

/*
-- ��������� (� ��� ������ �����)
	������/�������: 
UPDATE [users] 
	SET [Rights] = 'ANALYST_ID,CONNECT_AS_CLIENT,ALL_DRV_STATES,SEMI_DRV_STATES,VIEW_ALARM,VIEW_ALARM_JOURNAL_SLEEP,VIEW_ALARM_JOURNAL_STRESS,VIEW_ALARM_JOURNAL_MILLIAGE,VIEW_ALARM_JOURNAL_SENDTOMEDINS,VIEW_ALARM_JOURNAL_ROUTES,VIEW_ALARM_JOURNAL_DEVICES,VIEW_ALARM_JOURNAL_SENSORS,VIEW_ALARM_JOURNAL_SERVERS,VIEW_ALARM_JOURNAL_TRAIN,VIEW_ALARM_JOURNAL_RRERROR,VIEW_ALARM_JOURNAL_NODRIVER,'
	WHERE [RolesGuid] = '00000000-0000-0000-0000-000000000004'
	AND [Guid] IN ('141B142C-071D-4AB8-B3AB-9BC84D870387', '21B415D4-F9EA-4C42-A4F3-2F67361CCD73')
	
	
	
	������/������/�����: 
UPDATE [users] 
	SET [Rights] = 'ANALYST_ID,CONNECT_AS_CLIENT,ALL_DRV_STATES,SEMI_DRV_STATES,SHOW_VALIDITY_REPORT,SHOW_WAGONS_ONLINE_REPORT,VIEW_ALARM,VIEW_ALARM_JOURNAL_SLEEP,VIEW_ALARM_JOURNAL_STRESS,VIEW_ALARM_JOURNAL_MILLIAGE,VIEW_ALARM_JOURNAL_SENDTOMEDINS,VIEW_ALARM_JOURNAL_ROUTES,VIEW_ALARM_JOURNAL_DEVICES,VIEW_ALARM_JOURNAL_SENSORS,VIEW_ALARM_JOURNAL_SERVERS,VIEW_ALARM_JOURNAL_TRAIN,VIEW_ALARM_JOURNAL_RRERROR,VIEW_ALARM_JOURNAL_NODRIVER,'
	WHERE [RolesGuid] = '00000000-0000-0000-0000-000000000004'
	AND [Guid] IN ('17EFA42F-AAA5-4D0A-9436-A6129C657CC8', 'E7C8CC8A-B887-4509-AC0F-109F8771F8C8', '31CF00B8-96B2-4C81-9D12-5CFF2A8AE7AC')


UPDATE [users] 
	SET [Rights] = 'ANALYST_ID,CONNECT_AS_CLIENT,ALL_DRV_STATES,SEMI_DRV_STATES,SHOW_VALIDITY_REPORT,VIEW_ALARM,VIEW_ALARM_JOURNAL_SLEEP,VIEW_ALARM_JOURNAL_STRESS,VIEW_ALARM_JOURNAL_MILLIAGE,VIEW_ALARM_JOURNAL_SENDTOMEDINS,VIEW_ALARM_JOURNAL_ROUTES,VIEW_ALARM_JOURNAL_DEVICES,VIEW_ALARM_JOURNAL_SENSORS,VIEW_ALARM_JOURNAL_SERVERS,VIEW_ALARM_JOURNAL_TRAIN,VIEW_ALARM_JOURNAL_RRERROR,VIEW_ALARM_JOURNAL_NODRIVER,'
	WHERE [Guid] = '17EFA42F-AAA5-4D0A-9436-A6129C657CC8'


--*/

/*
-- ��������� 
UPDATE [users] 
--	SET [Rights] = 'CONNECT_AS_CLIENT,EDIT_ROUTES,CONFIRM_ALARM,VIEW_STATE,VIEW_HISTORY_STATE,ALL_DRV_STATES,SEMI_DRV_STATES,VIEW_ALARM_JOURNAL_SLEEP,VIEW_ALARM_JOURNAL_STRESS,VIEW_ALARM_JOURNAL_MILLIAGE,VIEW_ALARM_JOURNAL_SENDTOMEDINS,VIEW_ALARM_JOURNAL_ROUTES,VIEW_ALARM_JOURNAL_DEVICES,VIEW_ALARM_JOURNAL_SENSORS,VIEW_ALARM_JOURNAL_SERVERS,VIEW_ALARM_JOURNAL_TRAIN,VIEW_ALARM_JOURNAL_NODRIVER,'
	SET [Rights] = 'CONNECT_AS_CLIENT,EDIT_ROUTES,CONFIRM_ALARM,VIEW_STATE,VIEW_HISTORY_STATE,ALL_DRV_STATES,SEMI_DRV_STATES,VIEW_ALARM,VIEW_ALARM_JOURNAL_SLEEP,VIEW_ALARM_JOURNAL_STRESS,VIEW_ALARM_JOURNAL_MILLIAGE,VIEW_ALARM_JOURNAL_SENDTOMEDINS,VIEW_ALARM_JOURNAL_ROUTES,VIEW_ALARM_JOURNAL_DEVICES,VIEW_ALARM_JOURNAL_SENSORS,VIEW_ALARM_JOURNAL_SERVERS,VIEW_ALARM_JOURNAL_TRAIN,VIEW_ALARM_JOURNAL_RRERROR,VIEW_ALARM_JOURNAL_NODRIVER,'
	WHERE [RolesGuid] = '00000000-0000-0000-0000-000000000002'

--*/


/*
-- ��������������
UPDATE [users] 
	SET [Rights] = 'SUPERVISOR,ANALYST_ID,CONNECT_AS_GARNITURE,CONNECT_AS_CLIENT,EDIT_OPTIONS,EDIT_DICTIONARIES,EDIT_ROUTES,CONFIRM_ALARM,VIEW_STATE,VIEW_HISTORY_STATE,ALL_DRV_STATES,SEMI_DRV_STATES,UNDEFINED_DRV_STATE,VIEW_DRIVERS_DIGNALS,JOURNAL_ALL_EVENTS,JOURNAL_USERS,JOURNAL_BLOCKS,JOURNAL_SENSORS,JOURNAL_SERVER,JOURNAL_TRAIN,JOURNAL_ROUTES,JOURNAL_DEVICES,VIEW_ALARM,VIEW_ALARM_JOURNAL_SLEEP,VIEW_ALARM_JOURNAL_STRESS,VIEW_ALARM_JOURNAL_MILLIAGE,VIEW_ALARM_JOURNAL_SENDTOMEDINS,VIEW_ALARM_JOURNAL_MEDNOTPASS,VIEW_ALARM_JOURNAL_ROUTES,VIEW_ALARM_JOURNAL_DEVICES,VIEW_ALARM_JOURNAL_SENSORS,VIEW_ALARM_JOURNAL_SERVERS,VIEW_ALARM_JOURNAL_TRAIN,VIEW_ALARM_JOURNAL_RRERROR,VIEW_ALARM_JOURNAL_NODRIVER,'
	WHERE [RolesGuid] = '00000000-0000-0000-0000-000000000001'


--*/
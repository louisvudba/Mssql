/*********** LOGIN ***********/
SET NOEXEC OFF
GO
USE [master]
GO
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_timesheet_api')
	ALTER LOGIN [retail_timesheet_api] WITH PASSWORD = 0x0200d123547c164dcf5edf2431a977e5b7a7c44b2f68fa23e2260125f4fffbc06403f53fbd35bdcc9272e712bd1aaad6297135c6f4ae554a4d45a8768b41adfbed565a930133 HASHED
ELSE
	CREATE LOGIN [retail_timesheet_api] WITH PASSWORD = 0x0200d123547c164dcf5edf2431a977e5b7a7c44b2f68fa23e2260125f4fffbc06403f53fbd35bdcc9272e712bd1aaad6297135c6f4ae554a4d45a8768b41adfbed565a930133 HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'retail_timesheet_worker')
	ALTER LOGIN [retail_timesheet_worker] WITH PASSWORD = 0x02008c6c6a072b62199e97a82f83b4292ff53f400f31695aa64924bd6c157a8cc39933896bfcba0e0f892d3fe7006e010af104986aab5775204febdd0f8b5346dde318752e6d HASHED
ELSE
	CREATE LOGIN [retail_timesheet_worker] WITH PASSWORD = 0x02008c6c6a072b62199e97a82f83b4292ff53f400f31695aa64924bd6c157a8cc39933896bfcba0e0f892d3fe7006e010af104986aab5775204febdd0f8b5346dde318752e6d HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF

USE [$(DatabaseName)]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_timesheet_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_timesheet_api', 'retail_timesheet_api';
ELSE
	BEGIN
		CREATE USER [retail_timesheet_api] FOR LOGIN [retail_timesheet_api];
		ALTER ROLE [db_owner] ADD MEMBER [retail_timesheet_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'retail_timesheet_worker' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'retail_timesheet_worker', 'retail_timesheet_worker';
ELSE
	BEGIN
		CREATE USER [retail_timesheet_worker] FOR LOGIN [retail_timesheet_worker];
		ALTER ROLE [db_owner] ADD MEMBER [retail_timesheet_worker];
	END
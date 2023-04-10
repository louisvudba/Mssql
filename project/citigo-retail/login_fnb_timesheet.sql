/*********** LOGIN ***********/
SET NOEXEC OFF
GO
USE [master]
GO
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_timesheet_api')
	ALTER LOGIN [fnb_timesheet_api] WITH PASSWORD = 0x0200b0f0b85638d1a820126e2dd7048c6ae4887117a47e35dbd2baaf154380aa7877657b2ff72ecf343ad17f2b76d35f908c24849b11f8fb31032c0c9116f9dfa3d50f1717ac HASHED
ELSE
	CREATE LOGIN [fnb_timesheet_api] WITH PASSWORD = 0x0200b0f0b85638d1a820126e2dd7048c6ae4887117a47e35dbd2baaf154380aa7877657b2ff72ecf343ad17f2b76d35f908c24849b11f8fb31032c0c9116f9dfa3d50f1717ac HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF
IF EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'fnb_timesheet_worker')
	ALTER LOGIN [fnb_timesheet_worker] WITH PASSWORD = 0x0200e00333ab61dee6b76cfd0f18f4033fc5f6b6e4b32ea81e7a8f1f760c6203897d32fe581ff8cdbd72155f2a51b8eda403d1a2130f620df3280f32d3868fe8f883bb4f929d HASHED
ELSE
	CREATE LOGIN [fnb_timesheet_worker] WITH PASSWORD = 0x0200e00333ab61dee6b76cfd0f18f4033fc5f6b6e4b32ea81e7a8f1f760c6203897d32fe581ff8cdbd72155f2a51b8eda403d1a2130f620df3280f32d3868fe8f883bb4f929d HASHED, DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = us_english, CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF

USE [$(DatabaseName)]
GO
IF @@ERROR <> 0 SET NOEXEC ON
GO
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_timesheet_api' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_timesheet_api', 'fnb_timesheet_api';
ELSE
	BEGIN
		CREATE USER [fnb_timesheet_api] FOR LOGIN [fnb_timesheet_api];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_timesheet_api];
	END
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'fnb_timesheet_worker' AND type = 'S' AND authentication_type = 1 AND name NOT IN ('dbo'))
	EXEC sp_change_users_login 'update_one', 'fnb_timesheet_worker', 'fnb_timesheet_worker';
ELSE
	BEGIN
		CREATE USER [fnb_timesheet_worker] FOR LOGIN [fnb_timesheet_worker];
		ALTER ROLE [db_owner] ADD MEMBER [fnb_timesheet_worker];
	END
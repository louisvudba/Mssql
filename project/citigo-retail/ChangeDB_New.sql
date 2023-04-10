--DEPLOY
USE KiotVietShard14;
GO
ALTER ROLE [db_owner] ADD MEMBER [app];ALTER ROLE [db_datareader] DROP MEMBER [app];
ALTER ROLE [db_owner] ADD MEMBER [debugger];ALTER ROLE [db_datareader] DROP MEMBER [debugger];
ALTER ROLE [db_owner] ADD MEMBER [qa];ALTER ROLE [db_datareader] DROP MEMBER [qa];
ALTER ROLE [db_owner] ADD MEMBER [trace];ALTER ROLE [db_datareader] DROP MEMBER [trace];
ALTER ROLE [db_owner] ADD MEMBER [fiximei];ALTER ROLE [db_datareader] DROP MEMBER [fiximei];
ALTER ROLE [db_owner] ADD MEMBER [svc];ALTER ROLE [db_datareader] DROP MEMBER [svc];
GO
USE KiotVietTimeSheetS14;
GO
ALTER ROLE [db_owner] ADD MEMBER [apptimesheet];ALTER ROLE [db_datareader] DROP MEMBER [apptimesheet];
GO
USE [KiotVietPromotionG2]
GO
--ALTER ROLE [db_owner] ADD MEMBER [svc];ALTER ROLE [db_datareader] DROP MEMBER [svc];
ALTER ROLE [db_owner] ADD MEMBER [app];ALTER ROLE [db_datareader] DROP MEMBER [app];
GO
USE [KiotVietWarrantyG2]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appwarranty];ALTER ROLE [db_owner] DROP MEMBER [appwarranty];
--ALTER ROLE [db_datareader] ADD MEMBER [app];ALTER ROLE [db_owner] DROP MEMBER [app];
GO
USE [KiotVietYC14]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appKYC14];ALTER ROLE [db_owner] DROP MEMBER [appKYC14];
GO
USE [KiotVietTimeSheetS5];
GO
ALTER ROLE [db_owner] ADD MEMBER [apptimesheet];ALTER ROLE [db_datareader] DROP MEMBER [apptimesheet];
GO
USE [KiotVietYC5]
GO
ALTER ROLE [db_owner] ADD MEMBER [appKYC5];ALTER ROLE [db_datareader] DROP MEMBER [appKYC5];
GO

-- ROLLBACK
USE KiotVietShard14;
GO
ALTER ROLE [db_datareader] ADD MEMBER [app];ALTER ROLE [db_owner] DROP MEMBER [app];
ALTER ROLE [db_datareader] ADD MEMBER [debugger];ALTER ROLE [db_owner] DROP MEMBER [debugger];
ALTER ROLE [db_datareader] ADD MEMBER [qa];ALTER ROLE [db_owner] DROP MEMBER [qa];
ALTER ROLE [db_datareader] ADD MEMBER [trace];ALTER ROLE [db_owner] DROP MEMBER [trace];
ALTER ROLE [db_datareader] ADD MEMBER [fiximei];ALTER ROLE [db_owner] DROP MEMBER [fiximei];
ALTER ROLE [db_datareader] ADD MEMBER [svc];ALTER ROLE [db_owner] DROP MEMBER [svc];
GO
USE KiotVietTimeSheetS14;
GO
ALTER ROLE [db_datareader] ADD MEMBER [apptimesheet];ALTER ROLE [db_owner] DROP MEMBER [apptimesheet];
GO
USE [KiotVietPromotionG2]
GO
--ALTER ROLE [db_datareader] ADD MEMBER [svc];ALTER ROLE [db_owner] DROP MEMBER [svc];
ALTER ROLE [db_datareader] ADD MEMBER [app];ALTER ROLE [db_owner] DROP MEMBER [app];
GO
USE [KiotVietWarrantyG2]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appwarranty];ALTER ROLE [db_owner] DROP MEMBER [appwarranty];
--ALTER ROLE [db_datareader] ADD MEMBER [app];ALTER ROLE [db_owner] DROP MEMBER [app];
GO
USE [KiotVietYC14];
GO
ALTER ROLE [db_datareader] ADD MEMBER [appKYC14];ALTER ROLE [db_owner] DROP MEMBER [appKYC14];
GO
USE [KiotVietTimeSheetS5];
GO
ALTER ROLE [db_datareader] ADD MEMBER [apptimesheet];ALTER ROLE [db_owner] DROP MEMBER [apptimesheet];
GO
USE [KiotVietYC5];
GO
ALTER ROLE [db_datareader] ADD MEMBER [appKYC5];ALTER ROLE [db_owner] DROP MEMBER [appKYC5];
GO

--- RESEED

DECLARE @v_tableName varchar(100);
declare @v_sql_command NVARCHAR(1000);
declare @intX int;
DECLARE reseed_cursor CURSOR
FOR
SELECT t.name
FROM sys.schemas AS s
INNER JOIN sys.tables AS t
ON s.[schema_id] = t.[schema_id]
WHERE EXISTS
(
SELECT 1 FROM sys.identity_columns
WHERE [object_id] = t.[object_id]
)
and t.name not like 'sys%'

OPEN reseed_cursor;
FETCH NEXT FROM reseed_cursor INTO @v_tableName;
WHILE @@FETCH_STATUS = 0
begin
set @v_sql_command = concat('select @cnt=max(Id) +1000000 from [',@v_tableName,']');
--exec (@v_sql_command);
print @v_sql_command;
EXECUTE sp_executesql @v_sql_command, N'@cnt int OUTPUT', @cnt=@intX OUTPUT;
print @intX;
print @v_tableName;

declare @sql varchar(max)='dbcc checkident([@v_tableName], reseed, @int );'
select @sql=replace(@sql, '@int',@intX)
select @sql=replace(@sql, '@v_tableName',@v_tableName)
print @sql
exec (@SQL)


FETCH NEXT FROM reseed_cursor INTO @v_tableName;
end;
CLOSE reseed_cursor;
DEALLOCATE reseed_cursor;

--- RESTART SEQUENCES FROM Old Server Scripts
ALTER SEQUENCE [AllowanceSeq] RESTART WITH 90000001001001;
ALTER SEQUENCE [BranchSettingSeq] RESTART WITH 90000001012501;
ALTER SEQUENCE [ClockingHistorySeq] RESTART WITH 90000001020201;
ALTER SEQUENCE [ClockingSeq] RESTART WITH 90000002691001;
ALTER SEQUENCE [CommissionBranchSeq] RESTART WITH 90000001010301;
ALTER SEQUENCE [CommissionDetailSeq] RESTART WITH 90000001575201;
ALTER SEQUENCE [CommissionSeq] RESTART WITH 90000001018701;
ALTER SEQUENCE [DeductionSeq] RESTART WITH 90000001005101;
ALTER SEQUENCE [DepartmentSeq] RESTART WITH 90000001000601;
ALTER SEQUENCE [EmployeeProfilePictureSeq] RESTART WITH 90000001000901;
ALTER SEQUENCE [EmployeeSeq] RESTART WITH 90000001059801;
ALTER SEQUENCE [FingerPrintLogSeq] RESTART WITH 90000001000001;
ALTER SEQUENCE [FingerPrintSeq] RESTART WITH 90000001065001;
ALTER SEQUENCE [HolidaySeq] RESTART WITH 90000001006501;
ALTER SEQUENCE [EmployeeBranchSeq] RESTART WITH 90000011003601;
ALTER SEQUENCE [JobTitleSeq] RESTART WITH 90000001000401;
ALTER SEQUENCE [PayRateSeq] RESTART WITH 90000001059701;
ALTER SEQUENCE [PayRateTemplateSeq] RESTART WITH 90000001005501;
ALTER SEQUENCE [PaysheetSeq] RESTART WITH 90000001020201;
ALTER SEQUENCE [PayslipSeq] RESTART WITH 90000001021101;
ALTER SEQUENCE [SettingsSeq] RESTART WITH 90000001000301;
ALTER SEQUENCE [ShiftSeq] RESTART WITH 90000001012901;
ALTER SEQUENCE [TimeSheetSeq] RESTART WITH 90000001190001;
ALTER SEQUENCE [PenalizeSeq] RESTART WITH 90000001002001;
ALTER SEQUENCE [ClockingPenalizeSeq] RESTART WITH 90000001004001;
ALTER SEQUENCE [PayslipPenalizeSeq] RESTART WITH 90000001011001;
ALTER SEQUENCE [PayslipClockingPenalizeSeq] RESTART WITH 90000001011001;


-- DEPLOY
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

--ROLLBACK
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
ALTER ROLE [db_owner] ADD MEMBER [svc];ALTER ROLE [db_datareader] DROP MEMBER [svc];
ALTER ROLE [db_owner] ADD MEMBER [app];ALTER ROLE [db_datareader] DROP MEMBER [app];
GO
USE [KiotVietWarrantyG2]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appwarranty];ALTER ROLE [db_owner] DROP MEMBER [appwarranty];
ALTER ROLE [db_datareader] ADD MEMBER [app];ALTER ROLE [db_owner] DROP MEMBER [app];
GO
USE [KiotVietYC14]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appKYC14];ALTER ROLE [db_owner] DROP MEMBER [appKYC14];
GO


--- TIMESHEET

--------------------------------------SEQUENCE  – áp dụng với TIMESHEET
SELECT t.name, t.current_value , cast(t.current_value as bigint) +1000000 as value_aff
from KiotVietTimeSheetS14.sys.sequences as t order by 1

SELECT current_value FROM sys.sequences WHERE name = 'AllowanceSeq' ;
--140000000100301
SELECT NEXT VALUE FOR dbo.AllowanceSeq
--140000000100301

DECLARE @v_tableName varchar(100);
declare @v_sql_command NVARCHAR(1000);
declare @intX bigint;
DECLARE resetSequence_cursor CURSOR
FOR
SELECT t.name, cast(t.current_value as bigint) +1000000
from KiotVietTimeSheetS14.sys.sequences as t

OPEN resetSequence_cursor;
FETCH NEXT FROM resetSequence_cursor INTO @v_tableName,@intX;
WHILE @@FETCH_STATUS = 0
begin
set @v_sql_command = concat('ALTER SEQUENCE [',@v_tableName,']',' RESTART WITH ' + cast(@intX as nvarchar(20)) + ';');
--set @v_sql_command = concat('select @cnt=max(Id) +100000 from [',@v_tableName,']');
--exec (@v_sql_command);
print @v_sql_command;
--EXECUTE sp_executesql @v_sql_command, N'@cnt int OUTPUT', @cnt=@intX OUTPUT;
--print @intX;
--print @v_tableName;

FETCH NEXT FROM resetSequence_cursor INTO @v_tableName,@intX;;
end;
CLOSE resetSequence_cursor;
DEALLOCATE resetSequence_cursor;


CREATE LOGIN [svc]
WITH PASSWORD = 0x020037d4a831220028f93b0721d7fbcde08114d2c2518562cb0096f67fa12332d8509c7d120691f4c1ccf9d8a7fe4a1774aba6dd37923812bc216ab07d32566a0d9cd69dd348 HASHED
    , SID = 0x734f3d985535f548a89dc09137e586ac
    , DEFAULT_DATABASE = [KiotVietShard7]
    , DEFAULT_LANGUAGE = us_english
    , CHECK_POLICY = OFF
    , CHECK_EXPIRATION = OFF

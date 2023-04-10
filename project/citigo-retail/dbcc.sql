SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
SET XACT_ABORT ON
GO
PRINT @@SERVERNAME
GO
USE [master];
GO
IF OBJECT_ID('dbo.sp_foreachdb') IS NULL
  EXEC ('CREATE PROCEDURE dbo.sp_foreachdb AS RETURN 0;');
GO
ALTER PROCEDURE dbo.sp_foreachdb
    @command NVARCHAR(MAX),
    @replace_character NCHAR(1) = N'?',
    @print_dbname BIT = 0,
    @print_command_only BIT = 0,
    @suppress_quotename BIT = 0,
    @system_only BIT = NULL,
    @user_only BIT = NULL,
    @name_pattern NVARCHAR(300) = N'%',
    @database_list NVARCHAR(MAX) = NULL,
    @recovery_model_desc NVARCHAR(120) = NULL,
    @compatibility_level TINYINT = NULL,
    @state_desc NVARCHAR(120) = N'ONLINE',
    @is_read_only BIT = 0,
    @is_auto_close_on BIT = NULL,
    @is_auto_shrink_on BIT = NULL,
    @is_broker_enabled BIT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE
        @sql NVARCHAR(MAX),
        @dblist NVARCHAR(MAX),
        @db NVARCHAR(300),
        @i INT;

    IF @database_list > N''
    BEGIN
        ;WITH n(n) AS
        (
            SELECT ROW_NUMBER() OVER (ORDER BY s1.name) - 1
            FROM sys.objects AS s1
            CROSS JOIN sys.objects AS s2
        )
        SELECT @dblist = REPLACE(REPLACE(REPLACE(x,'</x><x>',','),
        '</x>',''),'<x>','')
        FROM
        (
            SELECT DISTINCT x = 'N''' + LTRIM(RTRIM(SUBSTRING(
            @database_list, n,
            CHARINDEX(',', @database_list + ',', n) - n))) + ''''
            FROM n WHERE n <= LEN(@database_list)
            AND SUBSTRING(',' + @database_list, n, 1) = ','
            FOR XML PATH('')
        ) AS y(x);
    END

    CREATE TABLE #x(db NVARCHAR(300));

    SET @sql = N'SELECT name FROM sys.databases WHERE 1=1'
        + CASE WHEN @system_only = 1 THEN
            ' AND database_id IN (1,2,3,4)'
            ELSE '' END
        + CASE WHEN @user_only = 1 THEN
            ' AND database_id NOT IN (1,2,3,4)'
            ELSE '' END
        + CASE WHEN @name_pattern <> N'%' THEN
            ' AND name LIKE N''%' + REPLACE(@name_pattern, '''', '''''') + '%'''
            ELSE '' END
        + CASE WHEN @dblist IS NOT NULL THEN
            ' AND name IN (' + @dblist + ')'
            ELSE '' END
        + CASE WHEN @recovery_model_desc IS NOT NULL THEN
            ' AND recovery_model_desc = N''' + @recovery_model_desc + ''''
            ELSE '' END
        + CASE WHEN @compatibility_level IS NOT NULL THEN
            ' AND compatibility_level = ' + RTRIM(@compatibility_level)
            ELSE '' END
        + CASE WHEN @state_desc IS NOT NULL THEN
            ' AND state_desc = N''' + @state_desc + ''''
            ELSE '' END
        + CASE WHEN @is_read_only IS NOT NULL THEN
            ' AND is_read_only = ' + RTRIM(@is_read_only)
            ELSE '' END
        + CASE WHEN @is_auto_close_on IS NOT NULL THEN
            ' AND is_auto_close_on = ' + RTRIM(@is_auto_close_on)
            ELSE '' END
        + CASE WHEN @is_auto_shrink_on IS NOT NULL THEN
            ' AND is_auto_shrink_on = ' + RTRIM(@is_auto_shrink_on)
            ELSE '' END
        + CASE WHEN @is_broker_enabled IS NOT NULL THEN
            ' AND is_broker_enabled = ' + RTRIM(@is_broker_enabled)
        ELSE '' END;

        INSERT #x EXEC sp_executesql @sql;

        DECLARE c CURSOR
            LOCAL FORWARD_ONLY STATIC READ_ONLY
            FOR SELECT CASE WHEN @suppress_quotename = 1 THEN
                    db
                ELSE
                    QUOTENAME(db)
                END
            FROM #x ORDER BY db;

        OPEN c;

        FETCH NEXT FROM c INTO @db;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @sql = REPLACE(@command, @replace_character, @db);

            IF @print_command_only = 1
            BEGIN
                PRINT '/* For ' + @db + ': */'
                + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
                + @sql
                + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10);
            END
            ELSE
            BEGIN
                IF @print_dbname = 1
                BEGIN
                    PRINT '/* ' + @db + ' */';
                END

                EXEC sp_executesql @sql;
            END

            FETCH NEXT FROM c INTO @db;
    END

    CLOSE c;
    DEALLOCATE c;
END
GO
USE [Monitoring]
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.tables WHERE name = 'DbccLog')
    CREATE TABLE [dbo].[DbccLog]
    (
        [Id] INT IDENTITY(1, 1) NOT NULL,
        [DbId] BIGINT NULL,
        [DatabaseName] sysname NULL,
        [CommandId] INT NULL,
        [Error] BIGINT NULL,
        [Level] BIGINT NULL,
        [State] BIGINT NULL,
        [MessageText] VARCHAR(7000) NULL,
        [RepairLevel] VARCHAR(7000) NULL,
        [TimeStamp] DATETIMEOFFSET(7) NOT NULL,
        CONSTRAINT [PK_DbccLog]
            PRIMARY KEY CLUSTERED ([Id] ASC)
            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON,
                  ALLOW_PAGE_LOCKS = ON
                 )
    )
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.tables WHERE name = 'CommandLog')
    CREATE TABLE [dbo].[CommandLog](
        [Id] int IDENTITY(1,1) NOT NULL,
        [DatabaseName] sysname NULL,
        [SchemaName] sysname NULL,
        [ObjectName] sysname NULL,
        [ObjectType] char(2) NULL,
        [IndexName] sysname NULL,
        [IndexType] tinyint NULL,
        [StatisticsName] sysname NULL,
        [PartitionNumber] int NULL,
        [ExtendedInfo] xml NULL,
        [Command] Nvarchar(max) NOT NULL,
        [CommandType] Nvarchar(60) NOT NULL,
        [StartTime] DATETIMEOFFSET(7) NOT NULL,
        [EndTime] DATETIMEOFFSET(7) NULL,
        [ErrorNumber] int NULL,
        [ErrorMessage] Nvarchar(max) NULL,
        CONSTRAINT [PK_CommandLog] PRIMARY KEY CLUSTERED
        (
            [Id] ASC
        )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    )
GO
IF OBJECT_ID('dbo.usp_Dba_CommandLog') IS NULL
  EXEC ('CREATE PROCEDURE dbo.usp_Dba_CommandLog AS RETURN 0;');
GO
ALTER PROCEDURE dbo.usp_Dba_CommandLog
    @DatabaseName sysname = NULL,
    @SchemaName sysname = NULL,
    @ObjectName sysname = NULL,
    @ObjectType CHAR(2) = NULL,
    @IndexName sysname = NULL,
    @IndexType TINYINT = NULL,
    @StatisticsName sysname = NULL,
    @PartitionNumber INT = NULL,
    @ExtendedInfo XML = NULL,
    @Command NVARCHAR(max) = NULL,
    @CommandType NVARCHAR(60) = NULL,
    @StartTime DATETIMEOFFSET(7) = NULL,
    @EndTime DATETIMEOFFSET(7) = NULL,
    @ErrorNumber INT = NULL,
    @ErrorMessage NVARCHAR(max) = NULL,
    @Id INT OUTPUT
AS
BEGIN
    INSERT INTO dbo.CommandLog
    (
        DatabaseName,
        SchemaName,
        ObjectName,
        ObjectType,
        IndexName,
        IndexType,
        StatisticsName,
        PartitionNumber,
        ExtendedInfo,
        CommandType,
        Command,
        StartTime,
        EndTime,
        ErrorNumber,
        ErrorMessage
    )
    VALUES
    (@DatabaseName, @SchemaName, @ObjectName, @ObjectType, @IndexName, @IndexType, @StatisticsName, @PartitionNumber,
     @ExtendedInfo, @CommandType, @Command, @StartTime, @EndTime, @ErrorNumber, @ErrorMessage)

    SET @Id = SCOPE_IDENTITY()
END
GO
IF OBJECT_ID('dbo.usp_Dba_DatabaseIntegrity') IS NULL
  EXEC ('CREATE PROCEDURE dbo.usp_Dba_DatabaseIntegrity AS RETURN 0;');
GO
ALTER PROCEDURE dbo.usp_Dba_DatabaseIntegrity
    @DatabaseName NVARCHAR(max) = NULL,
    @CheckCommands NVARCHAR(max) = 'CHECKDB',
    @PhysicalOnly NVARCHAR(max) = 'N',
    @DataPurity NVARCHAR(max) = 'N',
    @NoIndex NVARCHAR(max) = 'N',
    @ExtendedLogicalChecks NVARCHAR(max) = 'N',
    @TabLock NVARCHAR(max) = 'N',
    @MaxDOP INT = NULL,
    @LockTimeout INT = NULL,
    @Comment NVARCHAR(max) = NULL,
    @TimeLimitFrom TIME = '00:00',
    @TimeLimitTo TIME = '06:00'
AS
BEGIN
    SET NOCOUNT ON

    /* Time for maintenance */
    IF NOT (FORMAT(GETDATE(),'HH:mm') BETWEEN @TimeLimitFrom AND @TimeLimitTo)
        RETURN

    DECLARE @StartMessage NVARCHAR(max),
            @EndMessage NVARCHAR(max),
            @ErrorMessage NVARCHAR(max),
            @ErrorMessageOriginal NVARCHAR(max)

    DECLARE @Error INT = 0,
            @ReturnCode INT = 0

    DECLARE @StartTime DATETIMEOFFSET(7),
            @EndTime DATETIMEOFFSET(7)
    DECLARE @EmptyLine NVARCHAR(max) = CHAR(9)

    DECLARE @Command NVARCHAR(max) = N'',
            @LogId INT = 0

    DECLARE @DbccResult TABLE
    (
        [Error] BIGINT NULL,
        [Level] BIGINT NULL,
        [State] BIGINT NULL,
        [MessageText] VARCHAR(7000) NULL,
        [RepairLevel] VARCHAR(7000) NULL,
        [Status] BIGINT NULL,
        [DbId] BIGINT NULL,
        [DbFragId] BIGINT NULL,
        [ObjectId] BIGINT NULL,
        [IndexId] BIGINT NULL,
        [PartitionId] BIGINT NULL,
        [AllocUnitId] BIGINT NULL,
        [RidDbId] BIGINT NULL,
        [RidPruId] BIGINT NULL,
        [File] BIGINT NULL,
        [Page] BIGINT NULL,
        [Slot] BIGINT NULL,
        [RefDbId] BIGINT NULL,
        [RefPruId] BIGINT NULL,
        [RefFile] BIGINT NULL,
        [RefPage] BIGINT NULL,
        [RefSlot] BIGINT NULL,
        [Allocation] BIGINT NULL
    )

    /* Generate Command */
    IF @LockTimeout IS NOT NULL
        SET @Command = 'SET LOCK_TIMEOUT ' + CAST(@LockTimeout * 1000 AS NVARCHAR) + '; '
    SET @Command += 'DBCC CHECKDB (' + QUOTENAME(@DatabaseName)
    IF @NoIndex = 'Y'
        SET @Command += ', NOINDEX'
    SET @Command += ') WITH NO_INFOMSGS, ALL_ERRORMSGS, TABLERESULTS'
    IF @DataPurity = 'Y'
        SET @Command += ', DATA_PURITY'
    IF @PhysicalOnly = 'Y'
        SET @Command += ', PHYSICAL_ONLY'
    IF @ExtendedLogicalChecks = 'Y'
        SET @Command += ', EXTENDED_LOGICAL_CHECKS'
    IF @TabLock = 'Y'
        SET @Command += ', TABLOCK'
    IF @MaxDOP IS NOT NULL
        SET @Command += ', MAXDOP = ' + CAST(@MaxDOP AS NVARCHAR)

    /* Start Logging */
    SET @StartTime = SYSDATETIMEOFFSET()

    SET @StartMessage = 'Date and time: ' + CONVERT(NVARCHAR, @StartTime, 120)
    RAISERROR('%s', 10, 1, @StartMessage) WITH NOWAIT

    SET @StartMessage = 'Database context: ' + QUOTENAME(@DatabaseName)
    RAISERROR('%s', 10, 1, @StartMessage) WITH NOWAIT

    SET @StartMessage = 'Command: ' + @Command
    RAISERROR('%s', 10, 1, @StartMessage) WITH NOWAIT

    IF @Comment IS NOT NULL
    BEGIN
        SET @StartMessage = 'Comment: ' + @Comment
        RAISERROR('%s', 10, 1, @StartMessage) WITH NOWAIT
    END

    EXEC dbo.usp_Dba_CommandLog @DatabaseName = @DatabaseName,
                                @Command = @Command,
                                @CommandType = @CheckCommands,
                                @StartTime = @StartTime,
                                @Id = @LogId OUTPUT

    INSERT INTO @DbccResult
    (
        [Error],
        [Level],
        [State],
        MessageText,
        RepairLevel,
        [Status],
        [DbId],
        DbFragId,
        ObjectId,
        IndexId,
        PartitionId,
        AllocUnitId,
        RidDbId,
        RidPruId,
        [File],
        Page,
        Slot,
        RefDbId,
        RefPruId,
        RefFile,
        RefPage,
        RefSlot,
        Allocation
    )
    EXECUTE sp_executesql @stmt = @Command

    SET @EndTime = SYSDATETIMEOFFSET()

    IF @@ROWCOUNT <> 0
    BEGIN
        SELECT TOP 1
               @Error = [Error],
               @ErrorMessage = [MessageText]
        FROM @DbccResult
    END

    SET @ReturnCode = @Error

    /* End Logging */
    SET @EndMessage = 'Outcome: ' + IIF(@Error = 0, 'Succeeded', 'Failed')
    RAISERROR('%s', 10, 1, @EndMessage) WITH NOWAIT

    SET @EndMessage
        = 'Duration: '
          + IIF((DATEDIFF(SECOND, @StartTime, @EndTime) / (24 * 3600)) > 0,
                CAST((DATEDIFF(SECOND, @StartTime, @EndTime) / (24 * 3600)) AS NVARCHAR) + '.',
                '') + CONVERT(NVARCHAR, DATEADD(SECOND, DATEDIFF(SECOND, @StartTime, @EndTime), '1900-01-01'), 108)
    RAISERROR('%s', 10, 1, @EndMessage) WITH NOWAIT

    SET @EndMessage = 'Date and time: ' + CONVERT(NVARCHAR, @EndTime, 120)
    RAISERROR('%s', 10, 1, @EndMessage) WITH NOWAIT

    RAISERROR(@EmptyLine, 10, 1) WITH NOWAIT

    INSERT [DbccLog]
    (
        [DbId],
        [DatabaseName],
        [CommandId],
        [Error],
        [Level],
        [State],
        [MessageText],
        [RepairLevel],
        [TimeStamp]
    )
    SELECT [DbId],
           @DatabaseName,
           @LogId,
           [Error],
           [Level],
           [State],
           [MessageText],
           [RepairLevel],
           @EndTime
    FROM @DbccResult

    UPDATE dbo.CommandLog
    SET EndTime = @EndTime,
        ErrorNumber = @Error,
        ErrorMessage = @ErrorMessage
    WHERE Id = @LogId

    IF @ReturnCode <> 0
    BEGIN
        RETURN @ReturnCode
    END
END
GO
USE [msdb]
GO
IF EXISTS (SELECT 1/0 FROM msdb.dbo.sysjobs WHERE name = 'DBA - DatabaseIntegrity - USER DATABASES')
	EXEC msdb.dbo.sp_delete_job @job_name = N'DBA - DatabaseIntegrity - USER DATABASES', @delete_unused_schedule=1
GO
/****** Object:  Job [DBA - DatabaseIntegrity - USER DATABASES]    Script Date: 6/17/2021 1:29:06 AM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [Database Maintenance]    Script Date: 6/17/2021 1:29:06 AM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'Database Maintenance' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'Database Maintenance'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'DBA - DatabaseIntegrity - USER DATABASES', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'DBCC CHECKDB.', 
		@category_name=N'Database Maintenance', 
		@owner_login_name=N'sa', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [Integrity Check]    Script Date: 6/17/2021 1:29:06 AM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'Integrity Check', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'EXEC	[dbo].[sp_foreachdb]
		@command = N''EXEC [EventMonitoring].[dbo].[usp_Dba_DatabaseIntegrity] @DatabaseName = ''''?'''''',
		@suppress_quotename = 1,
		@print_dbname = 1,
		@user_only = 1,
		@name_pattern = N''KiotViet%''		
', 
		@database_name=N'master', 
		@flags=0
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'01:00 daily', 
		@enabled=1, 
		@freq_type=8, 
		@freq_interval=91, 
		@freq_subday_type=1, 
		@freq_subday_interval=0, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=1, 
		@active_start_date=20210511, 
		@active_end_date=99991231, 
		@active_start_time=10000, 
		@active_end_time=235959, 
		@schedule_uid=N'9c188619-d22c-4b1e-a0a1-3eefe5d28c57'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:
GO
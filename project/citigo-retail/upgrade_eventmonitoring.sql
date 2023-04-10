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
USE [EventMonitoring]
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.tables WHERE name = 'CitigoMailList')
    CREATE TABLE [dbo].[CitigoMailList] (
        [cml_id]    INT            NULL,
        [list_mail] VARCHAR (1000) NULL,
        [type]      INT            NULL,
        [status]    INT            NULL
    );
GO
TRUNCATE TABLE [dbo].[CitigoMailList] 
GO
INSERT [dbo].[CitigoMailList] ([cml_id], [list_mail], [type], [status]) VALUES (1, N'hung.dao@citigo.net;tu.nc@citigo.com.vn;phuc.cv@citigo.com.vn;duong.lm@citigo.com.vn;son.nx@citigo.com.vn;lam.vt@citigo.com.vn', 1, 1)
INSERT [dbo].[CitigoMailList] ([cml_id], [list_mail], [type], [status]) VALUES (2, N'hung.dao@citigo.net;tu.nc@citigo.com.vn;phuc.cv@citigo.com.vn;duong.lm@citigo.com.vn;son.nx@citigo.com.vn;lam.vt@citigo.com.vn', 2, 1)
INSERT [dbo].[CitigoMailList] ([cml_id], [list_mail], [type], [status]) VALUES (3, N'hung.dao@citigo.net;tu.nc@citigo.com.vn;phuc.cv@citigo.com.vn;duong.lm@citigo.com.vn;son.nx@citigo.com.vn;lam.vt@citigo.com.vn', 3, 1)
INSERT [dbo].[CitigoMailList] ([cml_id], [list_mail], [type], [status]) VALUES (4, N'hung.dao@citigo.net;tu.nc@citigo.com.vn;phuc.cv@citigo.com.vn;duong.lm@citigo.com.vn;son.nx@citigo.com.vn;lam.vt@citigo.com.vn', 4, 1)
GO
IF OBJECT_ID('dbo.usp_Dba_HourlySlowQueryReport') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_Dba_HourlySlowQueryReport AS RETURN 0;');
GO
ALTER PROCEDURE [dbo].[usp_Dba_HourlySlowQueryReport]
(
    @Interval INT = 24, --Report from last ? hour
    @EmailTo NVARCHAR(200) = '',
    @DBName NVARCHAR(50) = ''
)
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @subject NVARCHAR(200),
            @body NVARCHAR(MAX),
            @xml NVARCHAR(MAX),
            @isSessionOn NVARCHAR(200) = '',
            @receipt_db NVARCHAR(MAX);
    SELECT @receipt_db = list_mail
    FROM CitigoMailList
    WHERE type = 1
          AND status = 1; -- type : 1-> slow, 2-->block, 3--> deadlock || status: 0-->invalid, 1-->valid
    DECLARE @error NVARCHAR(MAX) = ''
    BEGIN TRY
        --Get report
        ;WITH cte
         AS (SELECT COUNT(ID) AS [EventsCount],
                    CAST(AVG([Duration]) AS NUMERIC(32, 2)) AS [AVGDuration],
                    CAST(AVG([CPUTime]) AS NUMERIC(32, 2)) AS [AVGCPUTime],
                    AVG([PhysicalReads]) AS AVGPhysicalReads,
                    AVG([LogicalReads]) AS AVGLogicalReads,
                    AVG([Writes]) AS AVGWrites,
                    CASE --filter SQL text for grouping
                        WHEN [STMT_Batch_Text] LIKE N'%prClearRetailerAndSendMail%' THEN
                            'prClearRetailerAndSendMail'
                        WHEN [STMT_Batch_Text] LIKE N'%pr_Product_Group%' THEN
                            'exec [dbo].[pr_Product_Group]'
                        WHEN [STMT_Batch_Text] LIKE N'%ImportProduct%' THEN
                            'ImportProduct'
                        --if UPDATE then get all SQL text before SET
                        WHEN [STMT_Batch_Text] LIKE N'%UPDATE%' THEN
                            SUBSTRING(   [STMT_Batch_Text],
                                         1,
                                         CASE
                                             WHEN CHARINDEX('SET', [STMT_Batch_Text]) = 0 THEN
                                                 300
                                             ELSE
                                                 CHARINDEX('SET', [STMT_Batch_Text]) - 1
                                         END
                                     )
                        --if INSERT then get all SQL text untill table name or ]([
                        WHEN [STMT_Batch_Text] LIKE N'%INSERT%' THEN
                            SUBSTRING(   [STMT_Batch_Text],
                                         1,
                                         CASE
                                             WHEN CHARINDEX(']([', [STMT_Batch_Text]) = 0 THEN
                                                 300
                                             ELSE
                                                 CHARINDEX(']([', [STMT_Batch_Text])
                                         END
                                     )
                        --if DELETE then get all SQL text before WHERE
                        WHEN [STMT_Batch_Text] LIKE N'%DELETE%' THEN
                            SUBSTRING(   [STMT_Batch_Text],
                                         1,
                                         CASE
                                             WHEN CHARINDEX('WHERE', [STMT_Batch_Text]) = 0 THEN
                                                 300
                                             ELSE
                                                 CHARINDEX('WHERE', [STMT_Batch_Text]) - 1
                                         END
                                     )
                        --get all exec stored procedure untill @ where param are set
                        WHEN CHARINDEX('exec [dbo]', [STMT_Batch_Text]) = 1 THEN
                            REPLACE(SUBSTRING([STMT_Batch_Text], 1, CHARINDEX('@', [STMT_Batch_Text])), '@', '')
                        WHEN [STMT_Batch_Text] = '' THEN
                            CAST([SQLText] AS NVARCHAR(300))
                        ELSE
                            CAST([STMT_Batch_Text] AS NVARCHAR(300))
                    END AS [ShortedSQLText]
             FROM SlowQueryLog WITH (NOLOCK)
             WHERE [Time]
                   BETWEEN DATEADD(HOUR, - (@Interval), GETDATE()) AND GETDATE()
                   --Eliminate system queries
                   AND CHARINDEX('.sql', [STMT_Batch_Text]) = 0
                   AND CHARINDEX('@profile_name', [STMT_Batch_Text]) = 0
                   AND CHARINDEX('@fromDate', [STMT_Batch_Text]) = 0
             GROUP BY CASE --filter SQL text for grouping
                          WHEN [STMT_Batch_Text] LIKE N'%prClearRetailerAndSendMail%' THEN
                              'prClearRetailerAndSendMail'
                          WHEN [STMT_Batch_Text] LIKE N'%pr_Product_Group%' THEN
                              'exec [dbo].[pr_Product_Group]'
                          WHEN [STMT_Batch_Text] LIKE N'%ImportProduct%' THEN
                              'ImportProduct'
                          --if UPDATE then get all SQL text before SET
                          WHEN [STMT_Batch_Text] LIKE N'%UPDATE%' THEN
                              SUBSTRING(   [STMT_Batch_Text],
                                           1,
                                           CASE
                                               WHEN CHARINDEX('SET', [STMT_Batch_Text]) = 0 THEN
                                                   300
                                               ELSE
                                                   CHARINDEX('SET', [STMT_Batch_Text]) - 1
                                           END
                                       )
                          --if INSERT then get all SQL text untill table name or ]([
                          WHEN [STMT_Batch_Text] LIKE N'%INSERT%' THEN
                              SUBSTRING(   [STMT_Batch_Text],
                                           1,
                                           CASE
                                               WHEN CHARINDEX(']([', [STMT_Batch_Text]) = 0 THEN
                                                   300
                                               ELSE
                                                   CHARINDEX(']([', [STMT_Batch_Text])
                                           END
                                       )
                          --if DELETE then get all SQL text before WHERE
                          WHEN [STMT_Batch_Text] LIKE N'%DELETE%' THEN
                              SUBSTRING(
                                           [STMT_Batch_Text],
                                           1,
                                           CASE
                                               WHEN CHARINDEX('WHERE', [STMT_Batch_Text]) = 0 THEN
                                                   300
                                               ELSE
                                                   CHARINDEX('WHERE', [STMT_Batch_Text]) - 1
                                           END
                                       )
                          --get all exec stored procedure untill @ where param are set
                          WHEN CHARINDEX('exec [dbo]', [STMT_Batch_Text]) = 1 THEN
                              REPLACE(SUBSTRING([STMT_Batch_Text], 1, CHARINDEX('@', [STMT_Batch_Text])), '@', '')
                          WHEN [STMT_Batch_Text] = '' THEN
                              CAST([SQLText] AS NVARCHAR(300))
                          ELSE
                              CAST([STMT_Batch_Text] AS NVARCHAR(300))
                      END)

        --Format HTML table email body
        SELECT @xml = CAST(
             (
                 SELECT [EventsCount] AS 'td',
                        '',
                        [AVGDuration] AS 'td',
                        '',
                        [AVGCPUTime] AS 'td',
                        '',
                        [AVGPhysicalReads] AS 'td',
                        '',
                        [AVGLogicalReads] AS 'td',
                        '',
                        [AVGWrites] AS 'td',
                        '',
                        CAST([ShortedSQLText] AS NVARCHAR(200)) AS 'td'
                 FROM cte
                 ORDER BY [EventsCount] DESC,
                          [AVGDuration] DESC
                 FOR XML PATH('tr'), ELEMENTS
             ) AS NVARCHAR(MAX))
    END TRY
    BEGIN CATCH
        SELECT @error = ERROR_MESSAGE()
    END CATCH

    IF NOT EXISTS
    (
        SELECT 1
        FROM sys.dm_xe_sessions
        WHERE name = 'KV_SlowQueryLog'
    ) --Check if extended events is running
        SET @isSessionOn = '    Warning!!! Extended Events session is not running.'

    IF (@xml IS NOT NULL OR LEN(@xml) != 0) --Send email if there are blocks
    BEGIN
        SET @subject
            = @DBName + ' - Slow Query Report. Between ' + CAST(DATEADD(HOUR, - (@Interval), GETDATE()) AS NVARCHAR)
              + ' -> ' + CAST(GETDATE() AS NVARCHAR);
        SET @body
            = '<html><body><H3>' + @subject + @isSessionOn + @error
              + '</H3>
						<table border = 1> 
						<tr>
						<th> EventsCount </th> <th> AVGDuration(s) </th> <th> AVGCPUTime(s) </th> 
						<th> AVGPhysicalReads </th> <th> AVGLogicalReads </th> <th> AVGWrites </th> <th> ShortedSQLText </th> </tr>';
        SET @body = @body + @xml + '</table></body></html>';

        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                     @body_format = 'HTML',
                                     @recipients = @receipt_db, -- @EmailTo,
                                     @subject = @subject,
                                     @body = @body;
    END
    ELSE --Send email no slow found
    BEGIN
        SET @subject
            = @DBName + ' - Slow Query Report. Between ' + CAST(DATEADD(HOUR, - (@Interval), GETDATE()) AS NVARCHAR)
              + ' -> ' + CAST(GETDATE() AS NVARCHAR);
        SET @body = 'No slow queries found. ' + @isSessionOn + @error;

        EXEC msdb.dbo.sp_send_dbmail @profile_name = 'KiotViet',
                                     @body_format = 'HTML',
                                     @recipients = @receipt_db, -- @EmailTo,
                                     @subject = @subject,
                                     @body = @body;
    END
END
IF OBJECT_ID('dbo.usp_Dba_DeadLockLog') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_Dba_DeadLockLog AS RETURN 0;');
GO
ALTER PROCEDURE [dbo].[usp_Dba_DeadLockLog]	
AS
BEGIN
    -- Query ring buffer data
    IF OBJECT_ID('tempdb..#tempDeadlockRingBuffer') IS NOT NULL
        DROP TABLE #tempDeadlockRingBuffer;   

    -- Query ring buffer into temp table
    SELECT  CAST(dt.target_data AS XML) AS xmlDeadlockData
    INTO    #tempDeadlockRingBuffer
    FROM    sys.dm_xe_session_targets dt
            JOIN sys.dm_xe_sessions ds ON ds.address = dt.event_session_address
            JOIN sys.server_event_sessions ss ON ds.name = ss.name
    WHERE   dt.target_name = 'ring_buffer'
            AND ds.name = 'KV_DeadlockLog';

    ;WITH cte
    AS (
        SELECT  CASE WHEN xevents.event_data.query('(data[@name="blocked_process"]/value/blocked-process-report)[1]').value('(blocked-process-report[@monitorLoop])[1]', 'NVARCHAR(MAX)') IS NULL THEN xevents.event_data.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(100)') 
                ELSE xevents.event_data.value('(data[@name="database_name"]/value)[1]', 'NVARCHAR(100)') 
                END AS [DatabaseName],
                DATEADD(mi, DATEDIFF(mi, GETUTCDATE(), CURRENT_TIMESTAMP), xevents.event_data.value('(@timestamp)[1]', 'datetime2')) AS [Time],
                xevents.event_data.value('(data[@name="lock_mode"]/text)[1]', 'NVARCHAR(5)') AS [LockMode],
                xevents.event_data.query('(data[@name="xml_report"]/value/deadlock)[1]') AS [DeadlockGraph]
        FROM    #tempDeadlockRingBuffer
                CROSS APPLY xmlDeadlockData.nodes('//RingBufferTarget/event') AS xevents (event_data)
    )

    INSERT INTO DeadlockLog
    SELECT 
        [DatabaseName],
        [Time],
        --BlockedXactid, BlockingXactid
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[1]/@xactid', 'bigint') AS [BlockedXactid],
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[2]/@xactid', 'bigint') AS [BlockingXactid],

        --BlockedQuery, BlockingQuery
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[1]/inputbuf[1]', 'nvarchar(max)') AS [BlockedQuery],
        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[2]/inputbuf[1]', 'nvarchar(max)') AS [BlockingQuery],

        CAST([DeadlockGraph] AS XML).value('(deadlock[1])/process-list[1]/process[2]/@lockMode', 'nvarchar(5)') AS [LockMode],
        [DeadlockGraph] AS [XMLReport]
    FROM cte
END;
GO
IF OBJECT_ID('dbo.usp_Dba_SlowQueryLog') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_Dba_SlowQueryLog AS RETURN 0;');
GO
ALTER PROCEDURE [dbo].[usp_Dba_SlowQueryLog]	
AS
BEGIN
    -- Query ring buffer into temp table
    SELECT CAST(dt.target_data AS XML) AS xmlSlowData
    INTO #tempSlowQueryRingBuffer
    FROM sys.dm_xe_session_targets dt
        JOIN sys.dm_xe_sessions ds ON ds.Address = dt.event_session_address
        JOIN sys.server_event_sessions ss ON ds.Name = ss.Name
    WHERE dt.target_name = 'ring_buffer'
        AND ds.Name = 'KV_SlowQueryLog'

    -- Insert into table
    INSERT INTO [dbo].[SlowQueryLog]
    SELECT
        DATEADD(hh, 7, xed.event_data.value('(@timestamp)[1]', 'datetime')) AS [Time] --Add 7h because ext events takes UTC time
        , CONVERT (FLOAT, xed.event_data.value ('(data[@name=''duration'']/value)[1]', 'BIGINT')) / 1000000 AS [Duration(s)]
        , CONVERT (FLOAT, xed.event_data.value ('(data[@name=''cpu_time'']/value)[1]', 'BIGINT')) / 1000000 AS [CPUTime(s)]
        , xed.event_data.value ('(data[@name=''physical_reads'']/value)[1]', 'BIGINT') AS [PhysicalReads]
        , xed.event_data.value ('(data[@name=''logical_reads'']/value)[1]', 'BIGINT') AS [LogicalReads]
        , xed.event_data.value ('(data[@name=''writes'']/value)[1]', 'BIGINT') AS [Writes]
        , xed.event_data.value ('(action[@name=''username'']/value)[1]', 'NVARCHAR(100)') AS [User]
        , xed.event_data.value ('(action[@name=''client_app_name'']/value)[1]', 'NVARCHAR(100)') AS [AppName]
        , xed.event_data.value ('(action[@name=''database_name'']/value)[1]', 'NVARCHAR(100)') AS [Database]
        , ISNULL(xed.event_data.value('(data[@name=''statement'']/value)[1]', 'NVARCHAR(MAX)'),
                    xed.event_data.value('(data[@name=''batch_text'']/value)[1]', 'NVARCHAR(MAX)')) AS [STMT_Batch_Text] --sql statement text depending on rpc or stmt
        , xed.event_data.value('(action[@name=''sql_text'']/value)[1]', 'NVARCHAR(MAX)') AS [SQLText]
    FROM #tempSlowQueryRingBuffer
        CROSS APPLY xmlSlowData.nodes('//RingBufferTarget/event') AS xed (event_data)
    WHERE xed.event_data.value ('(action[@name=''database_name'']/value)[1]', 'NVARCHAR(100)') LIKE 'KiotViet%'
END
GO
IF OBJECT_ID('dbo.usp_Dba_WaitStats') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_Dba_WaitStats AS RETURN 0;');
GO
ALTER PROCEDURE [dbo].[usp_Dba_WaitStats] @ServerName sysname = @@SERVERNAME
AS
BEGIN
	DELETE FROM dbo.WaitStats
    WHERE pass = 1;

    UPDATE dbo.WaitStats
    SET pass = 1
    WHERE pass = 2;

    IF NOT EXISTS (SELECT 1 / 0 FROM dbo.WaitStats WHERE pass = 1)
    BEGIN
        PRINT 1;
        WITH cte_WaitStats
        AS (SELECT x.wait_type,
                   SUM(x.sum_wait_time_ms) AS sum_wait_time_ms,
                   SUM(x.sum_signal_wait_time_ms) AS sum_signal_wait_time_ms,
                   SUM(x.sum_waiting_tasks) AS sum_waiting_tasks
            FROM
            (
                SELECT owt.wait_type,
                       SUM(owt.wait_duration_ms) OVER (PARTITION BY owt.wait_type, owt.session_id) AS sum_wait_time_ms,
                       0 AS sum_signal_wait_time_ms,
                       0 AS sum_waiting_tasks
                FROM sys.dm_os_waiting_tasks owt
                WHERE owt.session_id > 50
                      AND owt.wait_duration_ms >= 0
                UNION ALL
                SELECT os.wait_type,
                       SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
                       SUM(os.signal_wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_signal_wait_time_ms,
                       SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
                FROM sys.dm_os_wait_stats os
            ) x
            GROUP BY x.wait_type)
        INSERT dbo.WaitStats
        (
            [pass],
            [sample_time],
            [server_name],
            [wait_type],
            [wait_time_s],
            [wait_time_per_core_s],
            [signal_wait_time_s],
            [signal_wait_percent],
            [wait_count]
        )
        SELECT 1,
               SYSDATETIMEOFFSET(),
               @@SERVERNAME,
               wc.wait_type,
               COALESCE(c.wait_time_s, 0),
               COALESCE(CAST((CAST(ws.sum_wait_time_ms AS MONEY)) / 1000.0 / cores.cpu_count AS DECIMAL(18, 1)), 0),
               COALESCE(c.signal_wait_time_s, 0),
               COALESCE(   CASE
                               WHEN c.wait_time_s > 0 THEN
                                   CAST(100. * (c.signal_wait_time_s / c.wait_time_s) AS NUMERIC(4, 1))
                               ELSE
                                   0
                           END,
                           0
                       ),
               COALESCE(ws.sum_waiting_tasks, 0)
        FROM dbo.WaitCategories wc
            LEFT JOIN cte_WaitStats ws
                ON wc.wait_type = ws.wait_type
                   AND ws.sum_waiting_tasks > 0
            CROSS APPLY
        (
            SELECT SUM(1) AS cpu_count
            FROM sys.dm_os_schedulers
            WHERE status = 'VISIBLE ONLINE'
                  AND is_online = 1
        ) AS cores
            CROSS APPLY
        (
            SELECT CAST(ws.sum_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS wait_time_s,
                   CAST(ws.sum_signal_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS signal_wait_time_s
        ) AS c;

        WAITFOR DELAY '00:00:05';
    END;

    WITH cte_WaitStats
    AS (SELECT x.wait_type,
               SUM(x.sum_wait_time_ms) AS sum_wait_time_ms,
               SUM(x.sum_signal_wait_time_ms) AS sum_signal_wait_time_ms,
               SUM(x.sum_waiting_tasks) AS sum_waiting_tasks
        FROM
        (
            SELECT owt.wait_type,
                   SUM(owt.wait_duration_ms) OVER (PARTITION BY owt.wait_type, owt.session_id) AS sum_wait_time_ms,
                   0 AS sum_signal_wait_time_ms,
                   0 AS sum_waiting_tasks
            FROM sys.dm_os_waiting_tasks owt
            WHERE owt.session_id > 50
                  AND owt.wait_duration_ms >= 0
            UNION ALL
            SELECT os.wait_type,
                   SUM(os.wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_wait_time_ms,
                   SUM(os.signal_wait_time_ms) OVER (PARTITION BY os.wait_type) AS sum_signal_wait_time_ms,
                   SUM(os.waiting_tasks_count) OVER (PARTITION BY os.wait_type) AS sum_waiting_tasks
            FROM sys.dm_os_wait_stats os
        ) x
        GROUP BY x.wait_type)
    INSERT dbo.WaitStats
    (
        [pass],
        [sample_time],
        [server_name],
        [wait_type],
        [wait_time_s],
        [wait_time_per_core_s],
        [signal_wait_time_s],
        [signal_wait_percent],
        [wait_count]
    )
    SELECT 2,
           SYSDATETIMEOFFSET(),
           @@SERVERNAME,
           wc.wait_type,
           COALESCE(c.wait_time_s, 0),
           COALESCE(CAST((CAST(ws.sum_wait_time_ms AS MONEY)) / 1000.0 / cores.cpu_count AS DECIMAL(18, 1)), 0),
           COALESCE(c.signal_wait_time_s, 0),
           COALESCE(   CASE
                           WHEN c.wait_time_s > 0 THEN
                               CAST(100. * (c.signal_wait_time_s / c.wait_time_s) AS NUMERIC(4, 1))
                           ELSE
                               0
                       END,
                       0
                   ),
           COALESCE(ws.sum_waiting_tasks, 0)
    FROM dbo.WaitCategories wc
        LEFT JOIN cte_WaitStats ws
            ON wc.wait_type = ws.wait_type
               AND ws.sum_waiting_tasks > 0
        CROSS APPLY
    (
        SELECT SUM(1) AS cpu_count
        FROM sys.dm_os_schedulers
        WHERE status = 'VISIBLE ONLINE'
              AND is_online = 1
    ) AS cores
        CROSS APPLY
    (
        SELECT CAST(ws.sum_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS wait_time_s,
               CAST(ws.sum_signal_wait_time_ms / 1000. AS NUMERIC(12, 1)) AS signal_wait_time_s
    ) AS c;

    SELECT ws2.server_name,
           ws2.sample_time,
           DATEDIFF(ss, ws1.sample_time, ws2.sample_time) time_range,
           COALESCE(wc.wait_type, 'Other') wait_type,
           COALESCE(wc.wait_category, 'Other') wait_category,
           CASE WHEN ws2.wait_time_s > ws1.wait_time_s THEN COALESCE(ws2.wait_time_s - ws1.wait_time_s, 0) ELSE 0 END wait_time_s,
           COALESCE(ws2.wait_time_per_core_s - ws1.wait_time_per_core_s, 0) wait_time_per_core_s,
           COALESCE(ws2.signal_wait_time_s - ws1.signal_wait_time_s, 0) signal_wait_time_s,
           COALESCE(ws2.signal_wait_percent - ws1.signal_wait_percent, 0) signal_wait_percent,
           COALESCE(ws2.wait_count - ws1.wait_count, 0) wait_count,
           CASE
               WHEN ws2.wait_count > ws1.wait_count THEN
                   COALESCE(
                               CAST((ws2.wait_time_s - ws1.wait_time_s) * 1000.
                                    / (1.0 * (ws2.wait_count - ws1.wait_count)) AS NUMERIC(12, 1)),
                               0
                           )
               ELSE
                   0
           END avg_wait_per_ms,
           wc.ignorable
    FROM dbo.WaitStats ws2
        LEFT OUTER JOIN dbo.WaitStats ws1
            ON ws2.wait_type = ws1.wait_type
        LEFT JOIN dbo.WaitCategories wc
            ON ws2.wait_type = wc.wait_type
    WHERE ws1.pass = 1
          AND ws2.pass = 2;
END
GO
IF OBJECT_ID('dbo.usp_Dba_IndexStats') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_Dba_IndexStats AS RETURN 0;');
GO
ALTER PROCEDURE [dbo].[usp_Dba_IndexStats]
AS
BEGIN
    DELETE FROM dbo.IndexStats
    WHERE pass = 1;

    UPDATE dbo.IndexStats
    SET pass = 1
    WHERE pass = 2;

    DECLARE @DatabaseName VARCHAR(50),
            @DatabaseId INT
    DECLARE @SampleTime DATETIMEOFFSET = SYSDATETIMEOFFSET();
    DECLARE @ServerName VARCHAR(50) = @@SERVERNAME;
    DECLARE @Sql NVARCHAR(4000);

    DECLARE c CURSOR FAST_FORWARD FOR
    SELECT database_id,
           name
    FROM sys.databases
    WHERE name LIKE 'KiotViet%'

    OPEN c
    FETCH NEXT FROM c
    INTO @DatabaseId,
         @DatabaseName

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @Sql
            = N'SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
                SELECT  2 AS pass,
                        @SampleTime,
                        ''' + @ServerName + ''' AS server_name,
						' + CAST(@DatabaseId AS NVARCHAR(10)) + N' AS database_id,
						''' + @DatabaseName + ''' AS database_name, 
                        so.object_id, 
                        si.index_id, 
                        si.type,                        
                        COALESCE(sc.NAME, ''Unknown'') AS [schema_name],
                        COALESCE(so.name, ''Unknown'') AS [object_name], 
                        COALESCE(si.name, ''Unknown'') AS [index_name],
                        CASE WHEN so.[type] = CAST(''V'' AS CHAR(2)) THEN ''View'' ELSE ''Table'' END, 
                        si.is_unique, 
                        si.is_primary_key, 
                        CASE when si.type = 3 THEN 1 ELSE 0 END AS is_XML,
                        CASE when si.type = 4 THEN 1 ELSE 0 END AS is_spatial,
                        CASE when si.type = 6 THEN 1 ELSE 0 END AS is_NC_columnstore,
                        CASE when si.type = 5 then 1 else 0 end as is_CX_columnstore,
                        CASE when si.data_space_id = 0 then 1 else 0 end as is_in_memory_oltp,
                        si.is_disabled,
                        si.is_hypothetical, 
                        si.is_padded, 
                        si.fill_factor,                       
                        CASE WHEN si.filter_definition IS NOT NULL THEN si.filter_definition
                             ELSE N''''
                        END AS filter_definition,
                        ISNULL(us.user_seeks, 0),
                        ISNULL(us.user_scans, 0),
                        ISNULL(us.user_lookups, 0),
                        ISNULL(us.user_updates, 0),
                        us.last_user_seek,
                        us.last_user_scan,
                        us.last_user_lookup,
                        us.last_user_update,
                        so.create_date,
                        so.modify_date
                FROM    ' + QUOTENAME(@DatabaseName)
              + N'.sys.indexes AS si WITH (NOLOCK)
                        JOIN ' + QUOTENAME(@DatabaseName)
              + N'.sys.objects AS so WITH (NOLOCK) ON si.object_id = so.object_id
                                               AND so.is_ms_shipped = 0 /*Exclude objects shipped by Microsoft*/
                                               AND so.type <> ''TF'' /*Exclude table valued functions*/
                        JOIN ' + QUOTENAME(@DatabaseName)
              + N'.sys.schemas sc ON so.schema_id = sc.schema_id
                        LEFT JOIN sys.dm_db_index_usage_stats AS us WITH (NOLOCK) ON si.[object_id] = us.[object_id]
                                                                       AND si.index_id = us.index_id
                                                                       AND us.database_id = '
              + CAST(@DatabaseId AS NVARCHAR(10))
              + N'
                WHERE    si.[type] IN ( 0, 1, 2, 3, 4, 5, 6 ) 
                /* Heaps, clustered, nonclustered, XML, spatial, Cluster Columnstore, NC Columnstore */ 
				OPTION    ( RECOMPILE );
        ';
        PRINT @Sql
        INSERT dbo.IndexStats
        EXECUTE sp_executesql @Sql, N'@SampleTime DATETIMEOFFSET', @SampleTime;

        FETCH NEXT FROM c
        INTO @DatabaseId,
             @DatabaseName
    END

    CLOSE c
    DEALLOCATE c

    SELECT i2.[sample_time]
          ,i2.[server_name]
          ,i2.[database_id]
          ,i2.[database_name]
          ,i2.[object_id]
          ,i2.[index_id]
          ,i2.[index_type]
          ,i2.[schema_name]
          ,i2.[object_name]
          ,i2.[index_name]
          ,i2.[object_type]
          ,i2.[is_unique]
          ,i2.[is_primary_key]
          ,i2.[is_XML]
          ,i2.[is_spatial]
          ,i2.[is_NC_columnstore]
          ,i2.[is_CX_columnstore]
          ,i2.[is_in_memory_oltp]
          ,i2.[is_disabled]
          ,i2.[is_hypothetical]
          ,i2.[is_padded]
          ,i2.[fill_factor]
          ,i2.[filter_definition]
          ,i2.[user_seeks] - ISNULL(i1.[user_seeks], 0) AS [user_seeks]
          ,i2.[user_scans] - ISNULL(i1.[user_scans], 0) AS [user_scans]
          ,i2.[user_lookups] - ISNULL(i1.[user_lookups], 0) AS [user_lookups]
          ,i2.[user_updates] - ISNULL(i1.[user_updates], 0) AS [user_updates]
          ,i2.[last_user_seek]
          ,i2.[last_user_scan]
          ,i2.[last_user_lookup]
          ,i2.[last_user_update]
          ,i2.[create_date]
          ,i2.[modify_date]
    FROM dbo.IndexStats i2
        LEFT OUTER JOIN dbo.IndexStats i1
            ON i1.database_name = i2.database_name AND i1.schema_name = i2.schema_name AND i1.object_name = i2.object_name AND i1.index_name = i2.index_name
    WHERE i1.pass = 1
          AND i2.pass = 2;
END
GO
IF OBJECT_ID('dbo.usp_Dba_ActiveTransaction') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_Dba_ActiveTransaction AS RETURN 0;');
GO
ALTER PROCEDURE dbo.usp_Dba_ActiveTransaction
AS
BEGIN
    SELECT DISTINCT @@SERVERNAME server_name
		, ToDateTimeOffset(GETDATE(),DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) [Time]
		, FORMAT(GETDATE(),'HH') hour_check
		, s.session_id
		, a.transaction_id
		, a.name
		, STUFF(
			(SELECT ', ' + DB_NAME(database_id) FROM sys.dm_tran_database_transactions WHERE transaction_id = a.transaction_id ORDER BY database_id DESC FOR XML PATH ('')), 1, 1, ''
			) database_name
		, (SELECT TOP 1 client_net_address FROM sys.[dm_exec_connections] c WHERE s.session_id  = c.session_id) client_net_address
		, se.login_name
		, se.host_name
		, se.program_name
		, duration = DATEDIFF(SECOND,a.transaction_begin_time,GETDATE())
		, ToDateTimeOffset(a.transaction_begin_time,DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) transaction_begin_time 
		, transaction_type = CASE a.transaction_type
					WHEN 1 THEN 'Read/write transaction'
					WHEN 2 THEN 'Read-only transaction'
					WHEN 3 THEN 'System transaction'
					WHEN 4 THEN 'Distributed transaction'
			 END
		, transaction_state = CASE a.transaction_state
					WHEN 0 THEN 'The transaction has not been completely initialized yet.'
					WHEN 1 THEN 'The transaction has been initialized but has not started.'
					WHEN 2 THEN 'transaction is active.'
					WHEN 3 THEN 'The transaction has ended. This is used for read-only transactions.'
					WHEN 4 THEN 'The commit process has been initiated on the distributed transaction. The distributed transaction is still active but further processing cannot take place.'
					WHEN 5 THEN 'The transaction is in a prepared state and waiting resolution.'
					WHEN 6 THEN 'The transaction has been committed.'
					WHEN 7 THEN 'The transaction is being rolled back.'
					WHEN 8 THEN 'The transaction has been rolled back.'
			 END
		, dtc_state = CASE a.dtc_state WHEN 1 THEN 'ACTIVE' WHEN 2 THEN 'PREPARED' WHEN 3 THEN 'COMMITTED' WHEN 4 THEN 'ABORTED' WHEN 5 THEN 'RECOVERED' END
		, [Initiator] = CASE s.is_user_transaction WHEN 0 THEN 'System' ELSE 'User' END
		, [Is_Local] = CASE s.is_local WHEN 0 THEN 'No' ELSE 'Yes' END
		, [Transaction_Text] = IsNull((SELECT text FROM sys.dm_exec_sql_text(sp.[sql_handle])),'')
	FROM sys.dm_tran_active_transactions a
		LEFT JOIN sys.dm_tran_session_transactions s ON a.transaction_id=s.transaction_id
		LEFT JOIN sys.dm_exec_sessions se on s.session_id = se.session_id
		OUTER APPLY (SELECT TOP 1 [sql_handle] FROM sys.sysprocesses WHERE spid = s.session_id AND [sql_handle] <> 0x0000000000000000000000000000000000000000) sp
	WHERE s.session_id is Not Null
		AND DATEDIFF(SECOND,a.transaction_begin_time,GETDATE()) > 60
		AND se.[program_name] NOT LIKE 'Repl%' 
		AND se.[program_name] NOT LIKE 'VM-KV%'
		AND se.[program_name] NOT LIKE 'VM-DB%'
		AND a.[name] NOT IN ('CheckDb')
	ORDER BY s.session_id, transaction_begin_time
	OPTION (RECOMPILE);
END
GO
IF OBJECT_ID('dbo.usp_Dba_PushData_ELK') IS NULL
    EXEC ('CREATE PROCEDURE dbo.usp_Dba_PushData_ELK AS RETURN 0;');
GO
ALTER PROCEDURE [dbo].[usp_Dba_PushData_ELK]
    @ServerName VARCHAR(50) = @@SERVERNAME,
    @Type TINYINT = 0 -- 1: slow query, 2: blocking report, 3: Replication Log,  4: Fragment Index
AS
BEGIN
    SET @Type = ISNULL(@Type, 0)
    DECLARE @ReportName NVARCHAR(150)
    DECLARE @FilteredDate DATETIME = CAST(DATEADD(d,-30,GETDATE()) AS DATE)
    DECLARE @TraceId BIGINT,
            @MaxId BIGINT

    IF @Type = 1
        GOTO slow_query
    IF @Type = 2
        GOTO blocking_report
    --IF @Type = 3
    --    GOTO finally_sp
    --IF @Type = 4
    --    GOTO finally_sp
	IF @Type = 5
		GOTO agent_job
	IF @Type = 6
		GOTO performance_counter
	IF @Type = 7
		GOTO deadlock_log
	IF @Type = 8
		GOTO active_transaction
    IF @Type = 9
		GOTO wait_stats
    IF @Type = 10
		GOTO index_stats
	IF @Type = 101
		GOTO repl_latency
    GOTO finally_sp

    slow_query:
    SET @ReportName = 'SLOW_QUERY'
    SELECT @TraceId = trace_id
    FROM dbo.DatabaseReportTraceId
    WHERE report_name = @ReportName
    SELECT TOP 1
           @MaxId = ID
    FROM dbo.SlowQueryLog WITH (NOLOCK)
    ORDER BY Id DESC

    UPDATE dbo.DatabaseReportTraceId
    SET trace_id = ISNULL(@MaxId, 0)
    WHERE report_name = @ReportName

    SELECT @ServerName AS server_name,
           [ID]
		  ,ToDateTimeOffset([Time],DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) [Time]
		  ,[Duration]
		  ,[CPUTime]
		  ,[PhysicalReads]
		  ,[LogicalReads]
		  ,[Writes]
		  ,[User]
		  ,[AppName]
		  ,[Database]
		  ,[STMT_Batch_Text]
		  ,[SQLText]
    FROM dbo.SlowQueryLog WITH (NOLOCK)
    WHERE ID > @TraceId
          AND ID <= @MaxId
          AND [Time] >= @FilteredDate

    GOTO finally_sp

    blocking_report:
    SET @ReportName = 'BLOCKING_REPORT'
    SELECT @TraceId = trace_id
    FROM dbo.DatabaseReportTraceId
    WHERE report_name = @ReportName
    SELECT TOP 1
           @MaxId = ID
    FROM dbo.BlockedProcessReports WITH (NOLOCK)
    ORDER BY Id DESC

    UPDATE dbo.DatabaseReportTraceId
    SET trace_id = ISNULL(@MaxId, 0)
    WHERE report_name = @ReportName

    SELECT @ServerName AS server_name,
			[id]
			,[database_name]
			,ToDateTimeOffset([post_time],DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) [post_time]
			,[insert_time]
			,[wait_time]
			,[blocked_xactid]
			,[blocking_xactid]
			,[is_blocking_source]
			,[blocked_inputbuf]
			,[blocking_inputbuf]
			,[blocked_process_report]
    FROM dbo.BlockedProcessReports WITH (NOLOCK)
    WHERE ID > @TraceId
          AND ID <= @MaxId
          AND post_time >= @FilteredDate

    GOTO finally_sp

    replication_log:
    --SET @ReportName = 'REPLICATION_LOG'
    --SELECT @TraceId = trace_id
    --FROM dbo.DatabaseReportTraceId
    --WHERE report_name = @ReportName
    --SELECT TOP 1
    --       @MaxId = ID
    --FROM dbo.Log_Replicator WITH (NOLOCK)
    --ORDER BY Id DESC

    --UPDATE dbo.DatabaseReportTraceId
    --SET trace_id = ISNULL(@MaxId, 0)
    --WHERE report_name = @ReportName

    --SELECT @ServerName AS server_name,
    --       *
    --FROM dbo.Log_Replicator WITH (NOLOCK)
    --WHERE ID > @TraceId
    --      AND ID <= @MaxId

    GOTO finally_sp

    fragment_index:
    --SET @ReportName = 'FRAGMENT_INDEX'
    --SELECT @TraceId = trace_id
    --FROM dbo.DatabaseReportTraceId
    --WHERE report_name = @ReportName
    --SELECT TOP 1
    --       @MaxId = ID
    --FROM dbo.fragment_indexes WITH (NOLOCK)
    --ORDER BY Id DESC

    --UPDATE dbo.DatabaseReportTraceId
    --SET trace_id = ISNULL(@MaxId, 0)
    --WHERE report_name = @ReportName

    --SELECT @ServerName AS server_name,
    --       *
    --FROM dbo.fragment_indexes WITH (NOLOCK)
    --WHERE ID > @TraceId
    --      AND ID <= @MaxId
    GOTO finally_sp

	agent_job:
	IF FORMAT(GETDATE(),'HH') BETWEEN 3 AND 8
	    SELECT 
            @@SERVERNAME server_name,
		    FORMAT(GETDATE(),'HH') hour_check,
            c.name job_category,
		    job.name,
		    job.job_id,
		    job.originating_server,
		    ToDateTimeOffset(activity.run_requested_date, DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) run_requested_date,
		    DATEDIFF(SECOND, activity.run_requested_date, GETDATE()) AS Elapsed,
		    CASE 
		        WHEN run_requested_date IS NOT NULL AND stop_execution_date IS NULL THEN 'RUNNING'
			    ELSE 'IDLE' END job_status,
            CASE 
                WHEN js.last_run_outcome = 0 THEN 'FAIL'
                WHEN js.last_run_outcome = 1 THEN 'SUCCESS'
                WHEN js.last_run_outcome = 3 THEN 'CANCEL' END last_run_result,
            DATEDIFF(d, jc.last_run_date, GETDATE()) last_run_days,
            js.last_outcome_message outcome_message,
            ToDateTimeOffset(jc.last_run_date, DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) last_run_date
	    FROM msdb.dbo.sysjobs_view job
		    JOIN msdb.dbo.sysjobactivity activity
			    ON job.job_id = activity.job_id
		    JOIN msdb.dbo.syssessions sess
			    ON sess.session_id = activity.session_id
		    JOIN
		    (
			    SELECT MAX(agent_start_date) AS max_agent_start_date
			    FROM msdb.dbo.syssessions
		    ) sess_max
			    ON sess.agent_start_date = sess_max.max_agent_start_date
		    JOIN msdb.dbo.syscategories c 
			    ON job.category_id = c.category_id
		    JOIN msdb.dbo.sysjobservers js
			    ON job.job_id = js.job_id
            CROSS APPLY (
                SELECT 
                    CASE WHEN js.last_run_date > 0
		                THEN DATETIMEFROMPARTS(js.last_run_date/10000,js.last_run_date/100%100,
		                                        js.last_run_date%100, js.last_run_time/10000,js.last_run_time/100%100, 
		                                        js.last_run_time%100,0)
                        ELSE '1970-01-01'
                    END last_run_date
            ) jc
	    WHERE c.name IN ('DBA')
    GOTO finally_sp

	performance_counter:	
	SELECT @@SERVERNAME server_name,
		   ToDateTimeOffset(GETDATE(),DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) sample_time,
		   *
	FROM sys.dm_os_performance_counters WITH (NOLOCK)
	
    GOTO finally_sp
	
	deadlock_log:
    SET @ReportName = 'DEADLOCK_LOG'
    SELECT @TraceId = trace_id
    FROM dbo.DatabaseReportTraceId
    WHERE report_name = @ReportName
    SELECT TOP 1
           @MaxId = ID
    FROM dbo.DeadlockLog WITH (NOLOCK)
    ORDER BY Id DESC

    UPDATE dbo.DatabaseReportTraceId
    SET trace_id = ISNULL(@MaxId, 0)
    WHERE report_name = @ReportName

    SELECT @ServerName AS server_name
		  ,[Id]
		  ,[DatabaseName]
		  ,ToDateTimeOffset([Time],DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) [Time]
		  ,[BlockedXactid]
		  ,[BlockingXactid]
		  ,[BlockedQuery]
		  ,[BlockingQuery]
		  ,[LockMode]
		  ,[XMLReport]
    FROM dbo.[DeadlockLog] WITH (NOLOCK)
    WHERE ID > @TraceId
          AND ID <= @MaxId
          AND [Time] >= @FilteredDate
    GOTO finally_sp
	
	active_transaction:
	EXEC dbo.usp_Dba_ActiveTransaction
	GOTO finally_sp	

    wait_stats:
	EXEC dbo.usp_Dba_WaitStats
	GOTO finally_sp	

    index_stats:
	EXEC dbo.usp_Dba_IndexStats
	GOTO finally_sp

	repl_latency:
	-- SELECT [Id]
    --     ,ServerName
    --     ,[DatabaseName]
    --     ,[Latency]
    --     ,0 AS TimeCheck
    --     ,ToDateTimeOffset([Time],DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) [Time]
    --     ,ToDateTimeOffset(GETDATE(),DATEPART(TZOFFSET, SYSDATETIMEOFFSET())) [SampleTime]
	-- FROM
	-- (
	-- 	SELECT [Id]
    --         ,ServerName
    --         ,[DatabaseName]
    --         ,[Latency]
    --         ,[Time]
    --         ,ROW_NUMBER() OVER (PARTITION BY DatabaseName ORDER BY Id DESC) rn
    --     FROM [EventMonitoring].[dbo].[ReplLatency]
	-- ) t
	-- WHERE t.rn = 1
	GOTO finally_sp	
	
    finally_sp:
    PRINT 'Done'
END
GO
/* Create Metricbeat */
USE [master]
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.sql_logins WHERE name = 'metricbeat')
    CREATE LOGIN [metricbeat]
    WITH PASSWORD = 0x02007a6872c15ae30433427ee590a25bd93102000709b8e520cb4256e80362dec392575fc7622bdf4a74a9ae959ec456d3ed109c0aee39dd6d9deae035f575f5a6915847fb2a HASHED  
        , DEFAULT_DATABASE = [master]
        , DEFAULT_LANGUAGE = us_english
        , CHECK_POLICY = OFF
        , CHECK_EXPIRATION = OFF
GO
GRANT VIEW SERVER STATE, VIEW ANY DEFINITION TO [metricbeat]
GO
USE [msdb]
GO
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'metricbeat')
    DROP USER [metricbeat]
GO
CREATE USER [metricbeat] FOR LOGIN [metricbeat]
ALTER ROLE [SQLAgentReaderRole] ADD MEMBER [metricbeat]
GRANT SELECT on dbo.sysjobactivity TO [metricbeat]
GRANT SELECT on dbo.syscategories TO [metricbeat]
GRANT SELECT on dbo.syssessions TO [metricbeat]
GRANT SELECT on dbo.sysjobs_view TO [metricbeat]
GRANT SELECT on dbo.sysjobservers TO [metricbeat]
GRANT SELECT on dbo.sysjobhistory TO [metricbeat]
GO
USE [EventMonitoring]
GO
IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = 'metricbeat')
    DROP USER [metricbeat]
GO
CREATE USER [metricbeat] FOR LOGIN [metricbeat]
GRANT CONNECT TO [metricbeat]
GRANT EXECUTE ON dbo.usp_Dba_PushData_ELK TO [metricbeat] 
GO
DECLARE @cmd NVARCHAR(4000) = N'
    USE [?]
    IF EXISTS (SELECT 1/0 FROM sys.database_principals WHERE name = ''metricbeat'')
        DROP USER [metricbeat]
    GO
    CREATE USER [metricbeat] FOR LOGIN [metricbeat]
    GO
'
EXEC master..sp_foreachdb
    @comand = @cmd,
    @name_pattern = 'KiotViet'
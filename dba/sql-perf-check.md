### Get current connections

```sql
SELECT 
		DB_NAME(database_id) as [DB],
      s.host_name, 
	  s.original_login_name,
      c.client_net_address
  FROM sys.dm_exec_connections AS c
  JOIN sys.dm_exec_sessions AS s
    ON c.session_id = s.session_id
GROUP BY DB_NAME(database_id),
      s.host_name, 
	  s.original_login_name,
      c.client_net_address
```

```sql
SELECT  spid,
        sp.[status],
        loginame [Login],
        hostname, 
        blocked BlkBy,
        sd.name DBName, 
        cmd Command,
        cpu CPUTime,
        physical_io DiskIO,
        last_batch LastBatch,
        [program_name] ProgramName     
FROM master.sys.sysprocesses sp 
INNER JOIN master.sys.sysdatabases sd ON sp.dbid = sd.dbid
WHERE spid > 50 -- Filtering System spid
ORDER BY spid
```

### Find most expensive queries

```sql
SELECT TOP (50)
	convert(xml,'<xml><![CDATA[' + cast(t.TEXT as varchar(max)) + ']]></xml>') [Query XML],
	qp.query_plan AS [Query Plan],
    qs.execution_count AS [Execution Count],
    --(qs.total_logical_reads) / 1000000.0 AS [Total Logical Reads in s],
    (qs.total_logical_reads / qs.execution_count) AS [Avg Logical Reads],
	qs.last_logical_reads [Last Logical Reads],
    --CAST((qs.total_worker_time) / 1000000. AS DECIMAL(20,3)) [Total Worker Time],
    CAST((qs.total_worker_time / qs.execution_count) / 1000000. AS DECIMAL(20,3)) [Avg Worker Time],
	qs.last_worker_time / 1000000. [Last Worker Time],
    CAST((qs.total_elapsed_time) / 1000000. AS DECIMAL(20,3)) [Total Elapsed Time],
    CAST((qs.total_elapsed_time / qs.execution_count) / 1000000. AS DECIMAL(20,3)) [Avg Elapsed Time],
	qs.last_elapsed_time / 1000000. [Last Eslaped Time],
    qs.creation_time AS [Creation Time],
    last_execution_time
FROM sys.dm_exec_query_stats AS qs WITH (NOLOCK)
    CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS t
    CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS qp
WHERE qs.last_execution_time > '2021-04-28 15:45:00'
ORDER BY qs.last_worker_time DESC OPTION (RECOMPILE); -- for frequently ran query
-- ORDER BY [Avg Logical Reads in ms] DESC OPTION (RECOMPILE);-- for High Disk Reading query
-- ORDER BY [Avg Worker Time in ms] DESC OPTION (RECOMPILE);-- for High CPU query
-- ORDER BY [Avg Elapsed Time in ms] DESC OPTION (RECOMPILE);-- for Long Running query

SELECT s.session_id
    ,r.STATUS
    ,r.blocking_session_id AS 'blocked_by'
    ,r.wait_type
    ,r.wait_resource
	,r.wait_time
    ,CONVERT(VARCHAR, DATEADD(ms, r.wait_time, 0), 114) AS 'wait_time'
    ,r.cpu_time
    ,r.logical_reads
    ,r.reads
    ,r.writes
    ,CONVERT(VARCHAR, DATEADD(ms, r.total_elapsed_time, 0), 114)   AS 'elapsed_time'
    ,TRY_CAST((
            '<?query --  ' + CHAR(13) + CHAR(13) + Substring(st.TEXT, (r.statement_start_offset / 2) + 1, (
                    (
                        CASE r.statement_end_offset
                            WHEN - 1
                                THEN Datalength(st.TEXT)
                            ELSE r.statement_end_offset
                            END - r.statement_start_offset
                        ) / 2
                    ) + 1) + CHAR(13) + CHAR(13) + '--?>'
            ) AS XML) AS 'query_text'
    ,COALESCE(QUOTENAME(DB_NAME(st.dbid)) + N'.' + QUOTENAME(OBJECT_SCHEMA_NAME(st.objectid, st.dbid)) + N'.' + 
     QUOTENAME(OBJECT_NAME(st.objectid, st.dbid)), '') AS 'stored_proc'
    ,qp.query_plan AS 'xml_plan'  -- uncomment (1) if you want to see plan
    ,r.command
    ,s.original_login_name
    ,s.host_name
    ,s.program_name
    ,s.host_process_id
    ,s.last_request_end_time
    ,s.login_time
    ,r.open_transaction_count
FROM sys.dm_exec_sessions AS s
INNER JOIN sys.dm_exec_requests AS r ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
OUTER APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp -- uncomment (2) if you want to see plan
WHERE r.wait_type NOT LIKE 'SP_SERVER_DIAGNOSTICS%'
    OR r.session_id != @@SPID
ORDER BY r.cpu_time DESC
    ,r.STATUS
    ,r.blocking_session_id
    ,s.session_id
```

### Find Oldest Updated Statistics – Outdated Statistics

```sql
SELECT DISTINCT
       OBJECT_SCHEMA_NAME(s.[object_id]) AS SchemaName,
       OBJECT_NAME(s.[object_id]) AS TableName,
       c.name AS ColumnName,
       s.name AS StatName,
       STATS_DATE(s.[object_id], s.stats_id) AS LastUpdated,
       DATEDIFF(d, STATS_DATE(s.[object_id], s.stats_id), GETDATE()) DaysOld,
       dsp.modification_counter,
       s.auto_created,
       s.user_created,
       s.no_recompute,
       s.[object_id],
       s.stats_id,
       sc.stats_column_id,
       sc.column_id
FROM sys.stats s
    JOIN sys.stats_columns sc
        ON sc.[object_id] = s.[object_id]
           AND sc.stats_id = s.stats_id
    JOIN sys.columns c
        ON c.[object_id] = sc.[object_id]
           AND c.column_id = sc.column_id
    JOIN sys.partitions par
        ON par.[object_id] = s.[object_id]
    JOIN sys.objects obj
        ON par.[object_id] = obj.[object_id]
    CROSS APPLY sys.dm_db_stats_properties(sc.[object_id], s.stats_id) AS dsp
WHERE OBJECTPROPERTY(s.OBJECT_ID, 'IsUserTable') = 1
-- AND (s.auto_created = 1 OR s.user_created = 1) -- filter out stats for indexes
ORDER BY DaysOld;
```
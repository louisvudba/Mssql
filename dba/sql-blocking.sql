SET NOCOUNT ON
GO
SELECT SPID, BLOCKED, REPLACE (REPLACE (T.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS BATCH
INTO #T
FROM sys.sysprocesses R CROSS APPLY sys.dm_exec_sql_text(R.SQL_HANDLE) T
GO
WITH BLOCKERS (SPID, BLOCKED, LEVEL, BATCH)
AS
(
SELECT SPID,
BLOCKED,
CAST (REPLICATE ('0', 4-LEN (CAST (SPID AS VARCHAR))) + CAST (SPID AS VARCHAR) AS VARCHAR (1000)) AS LEVEL,
BATCH FROM #T R
WHERE (BLOCKED = 0 OR BLOCKED = SPID)
AND EXISTS (SELECT * FROM #T R2 WHERE R2.BLOCKED = R.SPID AND R2.BLOCKED <> R2.SPID)
UNION ALL
SELECT R.SPID,
R.BLOCKED,
CAST (BLOCKERS.LEVEL + RIGHT (CAST ((1000 + R.SPID) AS VARCHAR (100)), 4) AS VARCHAR (1000)) AS LEVEL,
R.BATCH FROM #T AS R
INNER JOIN BLOCKERS ON R.BLOCKED = BLOCKERS.SPID WHERE R.BLOCKED > 0 AND R.BLOCKED <> R.SPID
)
SELECT N' ' + REPLICATE (N'| ', LEN (LEVEL)/4 - 1) +
CASE WHEN (LEN(LEVEL)/4 - 1) = 0
THEN 'HEAD - '
ELSE '|------ ' END
+ CAST (SPID AS NVARCHAR (10)) + N' ' + BATCH AS BLOCKING_TREE
FROM BLOCKERS ORDER BY LEVEL ASC
GO
DROP TABLE #T
GO



IF OBJECT_ID('tempdb..#Blocks') IS NOT NULL
    DROP TABLE #Blocks
SELECT   spid
        ,blocked
        ,REPLACE (REPLACE (st.TEXT, CHAR(10), ' '), CHAR (13), ' ' ) AS batch
INTO     #Blocks
FROM     sys.sysprocesses spr
    CROSS APPLY sys.dm_exec_sql_text(spr.SQL_HANDLE) st
GO
  
WITH BlockingTree (spid, blocking_spid, [level], batch)
AS
(
    SELECT   blc.spid
            ,blc.blocked
            ,CAST (REPLICATE ('0', 4-LEN (CAST (blc.spid AS VARCHAR))) + CAST (blc.spid AS VARCHAR) AS VARCHAR (1000)) AS [level]
            ,blc.batch
    FROM    #Blocks blc
    WHERE   (blc.blocked = 0 OR blc.blocked = SPID) AND
            EXISTS (SELECT * FROM #Blocks blc2 WHERE blc2.BLOCKED = blc.SPID AND blc2.BLOCKED <> blc2.SPID)
    UNION ALL
    SELECT   blc.spid
            ,blc.blocked
            ,CAST(bt.[level] + RIGHT (CAST ((1000 + blc.SPID) AS VARCHAR (100)), 4) AS VARCHAR (1000)) AS [level]
            ,blc.batch
    FROM     #Blocks AS blc
        INNER JOIN BlockingTree bt 
            ON  blc.blocked = bt.SPID
    WHERE   blc.blocked > 0 AND
            blc.blocked <> blc.SPID
)
SELECT  N'' + ISNULL(REPLICATE (N'|         ', LEN (LEVEL)/4 - 2),'')
        + CASE WHEN (LEN(LEVEL)/4 - 1) = 0 THEN '' ELSE '|------  ' END
        + CAST (bt.SPID AS NVARCHAR (10)) AS BlockingTree
        ,spr.lastwaittype   AS [Type]
        ,spr.loginame       AS [Login Name]
        ,DB_NAME(spr.dbid)  AS [Source database]
        ,st.text            AS [SQL Text]
        ,CASE WHEN cur.sql_handle IS NULL THEN '' ELSE (SELECT [TEXT] FROM sys.dm_exec_sql_text (cur.sql_handle)) END  AS [Cursor SQL Text]
        ,DB_NAME(sli.rsc_dbid)  AS [Database]
        ,OBJECT_SCHEMA_NAME(sli.rsc_objid,sli.rsc_dbid) AS [Schema]
        ,OBJECT_NAME(sli.rsc_objid, sli.rsc_dbid) AS [Table]
        ,spr.waitresource   AS [Wait Resource]
        ,spr.cmd            AS [Command]
        ,spr.program_name   AS [Application]
        ,spr.hostname       AS [HostName]
        ,spr.last_batch     AS [Last Batch Time]
FROM BlockingTree bt
    LEFT OUTER JOIN sys.sysprocesses spr 
        ON  spr.spid = bt.spid
    CROSS APPLY sys.dm_exec_sql_text(spr.SQL_HANDLE) st
    LEFT JOIN sys.dm_exec_cursors(0) cur
        ON  cur.session_id = spr.spid AND
            cur.fetch_status != 0
    JOIN sys.syslockinfo sli
        ON  sli.req_spid = spr.spid AND
            sli.rsc_type = 5 AND
            OBJECT_NAME(sli.rsc_objid, sli.rsc_dbid) IS NOT NULL
ORDER BY LEVEL ASC


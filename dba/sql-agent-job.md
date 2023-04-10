### Update Job Owner

```sql
SELECT 
	CONCAT('EXEC msdb.dbo.sp_update_job @job_id = ''',A.job_id,''', @owner_login_name = ''sa'''),
    A.job_id,
    A.[name] AS job_name,
    B.[name] AS [user_name],
    B.[sid]
FROM
    msdb.dbo.sysjobs A
    LEFT JOIN sys.server_principals B ON A.owner_sid = B.[sid]
```
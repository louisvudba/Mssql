DECLARE @TableName VARCHAR(100);
DECLARE @Cmd NVARCHAR(1000);
DECLARE @MaxId INT, @CurrentIdent INT

DECLARE reseed_cursor CURSOR FOR
    SELECT t.name
    FROM sys.schemas AS s
        INNER JOIN sys.tables AS t
            ON s.[schema_id] = t.[schema_id]
    WHERE EXISTS
    (
        SELECT 1 FROM sys.identity_columns WHERE [object_id] = t.[object_id]
    )
      AND t.name NOT LIKE 'sys%'
      AND t.name NOT LIKE 'MS%'
	  AND t.name NOT LIKE '%Back%'
	  AND s.name = 'dbo'
	ORDER BY t.name

OPEN reseed_cursor;
	FETCH NEXT FROM reseed_cursor INTO @TableName;
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Cmd = CONCAT('SELECT @MaxId = MAX(Id), @CurrentIdent = IDENT_CURRENT(''',@TableName,''') FROM [', @TableName, '] WITH(NOLOCK);');
    EXECUTE sp_executesql @Cmd,
                          N'@MaxId int OUTPUT, @CurrentIdent INT OUTPUT',
                          @MaxId = @MaxId OUTPUT,
						  @CurrentIdent = @CurrentIdent OUTPUT	
	
    PRINT CONCAT('/* ',@TableName, ': { MaxId: ',ISNULL(@MaxId,0),', CurrentIdent: ',@CurrentIdent, ' } */')
    SET @Cmd = CONCAT('DBCC CHECKIDENT([',@TableName,'], RESEED, ', ISNULL(@MaxId,1) + 1000,')')
    PRINT @Cmd
    --EXEC (@Cmd)
    
    FETCH NEXT FROM reseed_cursor INTO @TableName;
END;
CLOSE reseed_cursor;
DEALLOCATE reseed_cursor;


-----------------------------------SEQUENCE  – áp dụng với TIMESHEET
DECLARE @TableName VARCHAR(100)
DECLARE @Cmd NVARCHAR(1000)
DECLARE @JumpSize INT = 100000
DECLARE @CurrentSeq BIGINT = 0

DECLARE resetSequence_cursor CURSOR FOR
	SELECT t.name,
		   cast(t.current_value AS BIGINT)
	FROM sys.sequences AS t

OPEN resetSequence_cursor
	FETCH NEXT FROM resetSequence_cursor INTO @TableName, @CurrentSeq;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Cmd = CONCAT('ALTER SEQUENCE [', @TableName, ']', ' RESTART WITH ', @CurrentSeq + @JumpSize,';');
	PRINT CONCAT('/* ',@TableName, ': { CurrentSeq: ',@CurrentSeq,', NextValue: ',@CurrentSeq + @JumpSize, ' } */')
    PRINT @Cmd;
	--EXEC (@Cmd)

    FETCH NEXT FROM resetSequence_cursor INTO @TableName, @CurrentSeq;
END;
CLOSE resetSequence_cursor;
DEALLOCATE resetSequence_cursor;
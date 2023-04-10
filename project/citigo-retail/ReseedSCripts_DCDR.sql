DECLARE @DC INT = 2 -- 1: DC1, 2: DC2
DECLARE @TableName VARCHAR(100), @IdentityColName VARCHAR(100)
DECLARE @Cmd NVARCHAR(1000);
DECLARE @MaxIdentity INT, @CurrentIdent INT
DECLARE @Jump INT = IIF(@DC = 1, 100, 1000000000)

DECLARE reseed_cursor CURSOR FOR
    SELECT t.name, identity_col.name colname
    FROM sys.schemas AS s
        INNER JOIN sys.tables AS t
            ON s.[schema_id] = t.[schema_id]
		CROSS APPLY (
			SELECT c.name FROM sys.columns c JOIN sys.identity_columns ic ON c.column_id = ic.column_id AND c.object_id = ic.object_id
			WHERE c.object_id = t.object_id
			AND ic.is_identity = 1
		) identity_col
    WHERE t.name NOT LIKE 'sys%'
      AND t.name NOT LIKE 'MS%'
	  AND t.name NOT LIKE '%Back%'
	  AND s.name = 'dbo'
	ORDER BY t.name

OPEN reseed_cursor;
	FETCH NEXT FROM reseed_cursor INTO @TableName, @IdentityColName
WHILE @@FETCH_STATUS = 0
BEGIN
    SET @Cmd = CONCAT('SELECT @MaxIdentity = MAX(',@IdentityColName,'), @CurrentIdent = IDENT_CURRENT(''',@TableName,''') FROM [', @TableName, '] WITH(NOLOCK) WHERE ',@IdentityColName,IIF(@DC = 1, '< 1000000000', '> 1000000000'));
    EXECUTE sp_executesql @Cmd,
                          N'@MaxIdentity int OUTPUT, @CurrentIdent INT OUTPUT',
                          @MaxIdentity = @MaxIdentity OUTPUT,
						  @CurrentIdent = @CurrentIdent OUTPUT

	PRINT CONCAT('/* ',@TableName, ': { Max ',@IdentityColName,': ',ISNULL(@MaxIdentity,0),', CurrentIdent: ',@CurrentIdent, ' } */')
	IF (@DC = 1 AND @CurrentIdent > 1000000000)
		BEGIN 			
			SET @Cmd = CONCAT('DBCC CHECKIDENT([',@TableName,'], RESEED, ', ISNULL(@MaxIdentity,1) + @Jump,')')
            PRINT @Cmd
		END
    ELSE IF(@DC = 2 AND @CurrentIdent < 1000000000)
        BEGIN            
			SET @Cmd = CONCAT('DBCC CHECKIDENT([',@TableName,'], RESEED, ', ISNULL(@MaxIdentity,1) + @Jump,')')
            PRINT @Cmd
        END
	
    IF (ISNULL(@MaxIdentity,1) > @CurrentIdent)
    BEGIN
		PRINT '/* Need to reseed */'		
		SET @Cmd = CONCAT('DBCC CHECKIDENT([',@TableName,'], RESEED, ', ISNULL(@MaxIdentity,1) + @Jump,')')		
		PRINT @Cmd
	END
    
    FETCH NEXT FROM reseed_cursor INTO @TableName, @IdentityColName
END;
CLOSE reseed_cursor;
DEALLOCATE reseed_cursor;

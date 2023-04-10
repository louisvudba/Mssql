SET NOCOUNT ON
/*
DROP TABLE IF EXISTS TmpSync
SELECT * INTO TmpSync FROM DB14.EventMonitoring.Ref17._Tmp_SyncRetailerId
*/
DECLARE @Sql NVARCHAR(4000)
DECLARE @Id INT = 1
		,@MaxId INT = (SELECT TOP(1) Id FROM TmpSync ORDER BY Id DESC)		
		,@Table VARCHAR(150) = ''
		,@SourceTable VARCHAR(150)
		,@RetailerIdColumn VARCHAR(100)
		,@PKColumn VARCHAR(100)

WHILE @Id <= @MaxId
BEGIN
	SELECT @Table = TableName,
		@SourceTable = BackupTableName,
		@RetailerIdColumn = RetailerIdColumn,
		@PKColumn = PKColumn
	FROM TmpSync WHERE Id = @Id
	
	PRINT 'Processing: ' + @Table

	SET @sql = N'
	DROP TABLE IF EXISTS TmpData
	SELECT * INTO TmpData FROM DB14.EventMonitoring.' + @SourceTable + '
	CREATE CLUSTERED INDEX IX_Id ON dbo.TmpData(Id)
'
	EXEC sp_executesql @sql

	DECLARE @Total INT = 0
	SET @sql = N'SET @Total = (SELECT COUNT(*) FROM TmpData)'
	EXEC sp_executesql @sql,N'@Total INT OUT',@Total OUTPUT

	PRINT 'Total : ' + cast(@Total as varchar(10))

	DECLARE @RowsAffected INT = 0,
			@Completed INT = 0,
			@BatchSize INT = 1000000,
			@Diff INT = 0
	--IF (@Total < 1000000) SET @BatchSize = 1000

	WHILE @Completed < @Total
	BEGIN
		SET @sql = N'
CREATE TABLE #RowsAffected (Id INT); 

	WITH RowsToUpdate AS (SELECT TOP (@BatchSize) * FROM TmpData
	)
	UPDATE u
		SET u.RetailerId = us.' + @RetailerIdColumn + '
	OUTPUT INSERTED.' + @PKColumn + ' INTO #RowsAffected
	FROM RowsToUpdate us
	INNER JOIN dbo.' + @Table + ' u ON u.' + @PKColumn + ' = us.Id 
	WHERE u.RetailerId = -1
 
	DELETE TOP (@BatchSize) TmpData;	

SELECT @RowsAffected = COUNT(*) FROM #RowsAffected;	
DROP TABLE #RowsAffected; '
		EXEC sp_executesql @sql,N'@BatchSize INT, @RowsAffected INT OUT', @BatchSize, @RowsAffected OUTPUT

		SET @Completed = @Completed + @BatchSize
		SET @Diff = @Diff + @RowsAffected
		PRINT '# ' + @Table + ' # Affected Rows ' + CAST(@RowsAffected AS VARCHAR(10)) + ' # Completed ' + cast(@Completed as varchar(10)) + '/' + cast(@Total as varchar(10))
				
	END
	PRINT '# Diff: ' + CAST(@Diff AS VARCHAR(10))
	UPDATE TmpSync
	SET [Status] = 1
	WHERE Id = @Id
	SET @Id = @Id + 1
END



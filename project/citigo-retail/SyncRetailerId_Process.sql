SET NOCOUNT ON

USE KiotVietShard20
GO

DECLARE @Sql NVARCHAR(4000)

DECLARE @Id INT = 1
		,@MaxId INT = (SELECT TOP(1) Id FROM EventMonitoring.Ref20._Tmp_SyncRetailerId ORDER BY Id DESC)		
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
	FROM EventMonitoring.Ref20._Tmp_SyncRetailerId WHERE Id = @Id
	
	PRINT 'Processing: ' + @Table

	SET @sql = N'
USE EventMonitoring

IF NOT EXISTS (SELECT 1/0 FROM sys.tables WHERE SCHEMA_NAME(schema_id) + ''.'' + name = ''' + @SourceTable + '_Clone'')
BEGIN
	SELECT * INTO EventMonitoring.' + @SourceTable + '_Clone FROM EventMonitoring.' + @SourceTable + '
	ALTER TABLE EventMonitoring.' + @SourceTable + '_Clone ADD CONSTRAINT PK_' + REPLACE(@SourceTable,'.','_') + '_clone_Id PRIMARY KEY CLUSTERED (Id)
END'
	EXEC sp_executesql @sql

	DECLARE @Total INT = 0
	SET @sql = N'SET @Total = (SELECT COUNT(*) FROM EventMonitoring.' + @SourceTable + '_Clone)'
	EXEC sp_executesql @sql,N'@Total INT OUT',@Total OUTPUT

	PRINT 'Total : ' + cast(@Total as varchar(10))

	DECLARE @RowsAffected INT = 0,
			@Completed INT = 0,
			@BatchSize INT = 1000,
			@Diff INT = 0
	--IF (@Total < 1000000) SET @BatchSize = 1000

	WHILE @Completed < @Total
	BEGIN
		SET @sql = N'USE KiotVietShard20;
CREATE TABLE #RowsAffected (Id INT); 

	WITH RowsToUpdate AS (SELECT TOP (@BatchSize) * FROM EventMonitoring.' + @SourceTable + '_Clone
	)
	UPDATE u
		SET u.RetailerId = us.' + @RetailerIdColumn + '
	OUTPUT INSERTED.' + @PKColumn + ' INTO #RowsAffected
	FROM RowsToUpdate us
	INNER JOIN dbo.' + @Table + ' u ON u.' + @PKColumn + ' = us.Id 
	WHERE u.RetailerId = -1
 
	DELETE TOP (@BatchSize) EventMonitoring.' + @SourceTable + '_Clone;	

SELECT @RowsAffected = COUNT(*) FROM #RowsAffected;	
DROP TABLE #RowsAffected; '
		EXEC sp_executesql @sql,N'@BatchSize INT, @RowsAffected INT OUT', @BatchSize, @RowsAffected OUTPUT

		SET @Completed = @Completed + @BatchSize
		SET @Diff = @Diff + @RowsAffected
		PRINT '# ' + @Table + ' # Affected Rows ' + CAST(@RowsAffected AS VARCHAR(10)) + ' # Completed ' + cast(@Completed as varchar(10)) + '/' + cast(@Total as varchar(10))

		IF (FORMAT(GETDATE(),'HH') BETWEEN 1 AND 5)
		BEGIN
			SET @BatchSize = 4000
			WAITFOR DELAY '00:00:04'
		END
		ELSE
		BEGIN
			SET @BatchSize = 1000
			WAITFOR DELAY '00:00:04'
		END
	END
	PRINT '# Diff: ' + CAST(@Diff AS VARCHAR(10))
	UPDATE EventMonitoring.Ref20._Tmp_SyncRetailerId
	SET [Status] = 1
	WHERE Id = @Id
	SET @Id = @Id + 1
END

--ROLLBACK

SET NOCOUNT ON
/*
DROP TABLE IF EXISTS TmpData
SELECT * INTO TmpData FROM DB12VZ7.EventMonitoring.Ref12._Tmp_SyncRetailerId_TransferDetail_Backup
CREATE CLUSTERED INDEX IX_Id ON dbo.TmpData(Id)
SELECT TOP 100 * FROM TmpData
*/
DECLARE @Total INT = (SELECT COUNT(*) FROM TmpData)
PRINT 'Total : ' + cast(@Total as varchar(10))

DECLARE @RowsAffected INT = 0,
		@Completed INT = 0,
		@BatchSize INT = 100000,
		@Diff INT = 0

WHILE @Completed < @Total
BEGIN		
	CREATE TABLE #RowsAffected (Id INT); 


	WITH RowsToUpdate AS (SELECT TOP (@BatchSize) * FROM TmpData
	)
	UPDATE u
		SET u.RetailerId = us.TransferRetailerId
	OUTPUT INSERTED.Id INTO #RowsAffected
	FROM RowsToUpdate us
	INNER JOIN dbo.TransferDetail u ON u.Id = us.Id 
	WHERE u.RetailerId = -1
 
	DELETE TOP (@BatchSize) TmpData

	SELECT @RowsAffected = COUNT(*) FROM #RowsAffected;	
	DROP TABLE #RowsAffected;
	SET @Completed = @Completed + @BatchSize
	SET @Diff = @Diff + @RowsAffected
	PRINT '# TransferDetail # Affected Rows ' + CAST(@RowsAffected AS VARCHAR(10)) + ' # Completed ' + cast(@Completed as varchar(10)) + '/' + cast(@Total as varchar(10))
END
PRINT '# Diff: ' + CAST(@Diff AS VARCHAR(10))
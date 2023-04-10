SET NOCOUNT ON
DECLARE @MinId INT = (SELECT MAX(RecId) FROM [KiotVietYC14].dbo.Customer)
		,@MaxId INT = 0
		,@Total INT = 0
		,@BatchSize INT = 1000
		,@CurrentId INT = 0
		,@RowsAffected INT = 0
		,@Diff INT = 0

SELECT @MaxId = MAX(RecId), @Total = COUNT(*) FROM [DB8].[KiotVietYC14].dbo.Customer
SET @CurrentId = ISNULL(@MinId,0)

PRINT 'Total: ' + CAST(@Total AS VARCHAR)
PRINT 'Min/Max: ' + CAST(@CurrentId AS VARCHAR) + '/' + CAST(@MaxId AS VARCHAR)

SET IDENTITY_INSERT [KiotVietYC14].dbo.Customer ON
WHILE @CurrentId <= @MaxId
BEGIN
	INSERT [KiotVietYC14].dbo.Customer WITH (TABLOCKX)
	(
		RecId,[RetailerId]
           ,[Id]
           ,[ContactNumber]
           ,[SearchNumber]
           ,[AlternativeNumber]
           ,[Email]
           ,[Address]
           ,[ModifiedDate]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[CreatedBy]
           ,[IsActive]
           ,[isDeleted]
           ,[BranchId]
           ,[Uuid]
		)
	SELECT
		RecId,[RetailerId]
           ,[Id]
           ,[ContactNumber]
           ,[SearchNumber]
           ,[AlternativeNumber]
           ,[Email]
           ,[Address]
           ,[ModifiedDate]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[CreatedBy]
           ,[IsActive]
           ,[isDeleted]
           ,[BranchId]
           ,[Uuid]
	FROM [DB8].[KiotVietYC14].dbo.Customer WITH(NOLOCK)
	WHERE RecId >= @CurrentId AND RecId < @CurrentId + @BatchSize AND RecId <= @MaxId
	AND RecId NOT IN (SELECT RecId FROM [KiotVietYC14].dbo.Customer WHERE RecId >= @CurrentId AND RecId < @CurrentId + @BatchSize)

	SET @RowsAffected = @@ROWCOUNT
	SET @CurrentId = @CurrentId + @BatchSize
	SET @Diff = @Diff + @RowsAffected
	PRINT '# ' + CAST(@RowsAffected AS VARCHAR) + ' rows affected # Trace ' + CAST(@CurrentId AS VARCHAR) + '/' + cast(@MaxId AS VARCHAR)
END
SET IDENTITY_INSERT [KiotVietYC14].dbo.Customer OFF

PRINT 'Total: ' + CAST(@Diff AS VARCHAR) + ' rows affected'

-------------------------------------------------------------

/*
USE EventMonitoring
DROP TABLE IF EXISTS KYC_MigrateCustomer_14 
SELECT
	[Id]
	,[ContactNumber]
	,[Email]
	,[Address]
	,[RetailerId]
	,[ModifiedDate]
	,[CreatedDate]
	,[ModifiedBy]
	,[CreatedBy]
	,[IsActive]
	,[BranchId]
	,[isDeleted]
INTO KYC_MigrateCustomer_14
FROM [KiotVietShard14].[dbo].[Customer] WITH(NOLOCK)

CREATE CLUSTERED INDEX IX_Id ON dbo.KYC_MigrateCustomer_14(Id)
*/
SET NOCOUNT ON
USE EventMonitoring	

DECLARE @MinId INT = (SELECT MAX(Id) FROM [KiotVietYC14].dbo.Customer)
		,@MaxId INT = 0
		,@Total INT = 0
		,@BatchSize INT = 1000000
		,@CurrentId INT = 0
		,@RowsAffected INT = 0
		,@Diff INT = 0

SELECT @MaxId = MAX(Id), @Total = COUNT(*) FROM KYC_MigrateCustomer_14
SET @CurrentId = ISNULL(@MinId,0)

PRINT 'Total: ' + CAST(@Total AS VARCHAR)
PRINT 'Min/Max: ' + CAST(@MinId AS VARCHAR) + '/' + CAST(@MaxId AS VARCHAR)

WHILE @CurrentId <= @MaxId
BEGIN
	SET @RowsAffected = 0
	INSERT [KiotVietYC14].dbo.Customer WITH (TABLOCKX)
	(
		[Id]
		,[ContactNumber]
		,[Email]
		,[Address]
		,[RetailerId]
		,[ModifiedDate]
		,[CreatedDate]
		,[ModifiedBy]
		,[CreatedBy]
		,[IsActive]
		,[BranchId]
		,[isDeleted]
		)
	SELECT
		[Id]
		,[ContactNumber]
		,[Email]
		,[Address]
		,[RetailerId]
		,[ModifiedDate]
		,[CreatedDate]
		,[ModifiedBy]
		,[CreatedBy]
		,[IsActive]
		,[BranchId]
		,[isDeleted]
	FROM KYC_MigrateCustomer_14
	WHERE Id >= @CurrentId AND Id < @CurrentId + @BatchSize

	SET @RowsAffected = @@ROWCOUNT
	SET @Diff = @Diff + @RowsAffected
	SET @CurrentId = @CurrentId + @BatchSize
	PRINT '# ' + CAST(@RowsAffected AS VARCHAR) + ' rows affected # Trace ' + CAST(@CurrentId AS VARCHAR) + '/' + cast(@MaxId AS VARCHAR)
END

PRINT 'Total: ' + CAST(@Diff AS VARCHAR) + ' rows affected'


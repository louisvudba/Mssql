/* Step 1 DROP ALL INDEXES */
/* Step 2 OBJECT PREPARATION */
IF NOT EXISTS (SELECT 1/0 FROM sys.schemas WHERE name = 'dba')
    EXEC('CREATE SCHEMA dba')
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dba].[RetailerExpired](
	[Id] [INT] NOT NULL,
	[TotalRow] [BIGINT] NULL,
	[Duration] [INT] NULL,
	[ErrorCode] [INT] NULL,
	[ErrorMessage] [NVARCHAR](1000) NULL,
    [ExpiryDate] DATETIME NULL,
    [ModifiedDate] DATETIME NULL,
	[StartTime] [DATETIME] NULL,
	[EndTime] [DATETIME] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE TABLE [dba].[TableList](
	[TableName] [VARCHAR](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[TableName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE OR ALTER PROCEDURE [dba].[usp_Dba_DeleteExpiredRetailer]
    @RetailerId INT = 0,
    @SrcDB VARCHAR(100) = '',
	@TotalRowDeleted INT = 0 OUTPUT,
	@Duration INT = 0 OUTPUT,
	@Error INT = 0 OUTPUT,
	@ErrorMessage NVARCHAR(2000) = '' OUTPUT
AS
BEGIN
    SET NOCOUNT ON
    DECLARE @StartTime DATETIMEOFFSET = SYSDATETIMEOFFSET();   
 
    /* Create Schema */
    IF NOT EXISTS (SELECT 1/0 FROM sys.schemas WHERE name = 'dba')
        EXEC('CREATE SCHEMA [dba]')
 
    /* Create #TmpData */
    DROP TABLE IF EXISTS #TmpTable
    CREATE TABLE #TmpTable(TableName VARCHAR(50), PkCols NVARCHAR(1000))
 
    /* Get Table List from Archiving System */
    INSERT #TmpTable(TableName, PKCols)
    SELECT TableName,
        STUFF((SELECT ',' + QUOTENAME(column_name)
                FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC
                INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU
                    ON TC.CONSTRAINT_TYPE = 'PRIMARY KEY'
                    AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME
                    AND KU.table_name= c.TableName
                ORDER BY
                     KU.ORDINAL_POSITION FOR XML PATH('')), 1, 1, '')          
    FROM [dba].TableList c
	JOIN sys.tables t ON c.TableName = t.name
    WHERE TableName NOT IN ('Retailer', 'Location', 'Wards')

	IF OBJECT_ID('[dba].TableError', 'U') IS NULL 
		SELECT TableName, PkCols INTO [dba].TableError FROM #TmpTable WHERE PkCols IS NULL
 
    DECLARE @TableName VARCHAR(50),
            @TmpTableName VARCHAR(100),
            @PkCols NVARCHAR(1000)
    DECLARE @Cmd NVARCHAR(MAX)
    DECLARE @TotalDeletedRows BIGINT = 0,
            @TotalRows BIGINT = 0,
            @Total BIGINT = 0,
            @BatchSize INT = 1000,
            @LargestKeyProcessed INT = -1,
            @NextBatchMax INT,
            @RC INT = 1,
            @RL INT = -1
	PRINT '############## RetailerId: ' + CAST(@RetailerId AS VARCHAR(10)) + ' ##############'

	BEGIN TRY
        BEGIN TRANSACTION
			DECLARE c CURSOR FAST_FORWARD
				FOR SELECT TableName, PkCols FROM #TmpTable WHERE PkCols IS NOT NULL
 
			OPEN c
				FETCH NEXT FROM c INTO @TableName, @PkCols     
    
            WHILE @@FETCH_STATUS = 0
            BEGIN
                SET @TmpTableName = '[dba].' + QUOTENAME(@TableName + '_' + CAST(@RetailerId AS VARCHAR(10)))				

                /* Backup data from Archiving System */
                SET @Cmd = N'
                    DROP TABLE IF EXISTS ' + @TmpTableName + ';
                    SELECT ' + @PkCols + '
                    INTO ' + @TmpTableName + '
                    FROM ' + @SrcDB + '.dbo.' + QUOTENAME(@TableName) + '
                    WHERE RetailerId = ' + CAST(@RetailerId AS VARCHAR) + ';'
                --PRINT @Cmd
                EXEC sp_executesql @Cmd
 
                SET @Cmd = N'ALTER TABLE ' + @TmpTableName + ' ADD CONSTRAINT PK_Tmp' + @TableName + ' PRIMARY KEY (' + @PkCols + ');'
				--PRINT @Cmd
                EXEC sp_executesql @Cmd
 
                /* Delete */
                SET @Cmd = 'SELECT @TotalRows = COUNT(*) FROM ' + @TmpTableName + ';'
                EXEC sp_executesql @Cmd, N'@TotalRows INT OUTPUT', @TotalRows OUTPUT
                PRINT '#### DELETING TABLE: ' + QUOTENAME(@TableName) + ' | Total: ' + CAST(@TotalRows AS VARCHAR)
                SET @LargestKeyProcessed = -1
                SET @TotalDeletedRows = 0
                SET @RC = 1
                SET @RL = 1
             
                WHILE (@RL > 0)
                BEGIN      
                    SET @Cmd = N'
						;WITH cte_Deleted AS (SELECT TOP (' + CAST(@BatchSize AS VARCHAR) + ') * FROM ' + @TmpTableName + ' ORDER BY 1 ASC)
						DELETE t
						FROM ' + QUOTENAME(@TableName) + ' t JOIN cte_Deleted tmp
							ON ' + STUFF((select ' AND ' + 't.' + value + ' = tmp.' + value from string_split(@PkCols,',') for xml path ('')),1,5,'') + ';
						SET @RC = @@ROWCOUNT
						DELETE TOP (' + CAST(@BatchSize AS VARCHAR) + ') ' + @TmpTableName + ';
						SELECT @RL = COUNT(*) FROM ' + @TmpTableName + ';'
                    --PRINT @Cmd
                    EXEC sp_executesql @Cmd, N'@RC INT OUTPUT, @RL INT OUTPUT', @RC OUTPUT, @RL OUTPUT
 
                    SET @TotalDeletedRows = @TotalDeletedRows + @RC
                    IF @RC > 0
                        PRINT '>>> Trace: ' + CAST(@TotalDeletedRows AS VARCHAR) + ' / ' + CAST(@TotalRows AS VARCHAR) + ' | Rows Affected: ' + CAST(@RC AS VARCHAR) + ' | Row left: ' + CAST(@RL AS VARCHAR)
                END
 
                SET @Cmd = N'DROP TABLE ' + @TmpTableName + ';'
                EXEC sp_executesql @Cmd
                 
                --SET @Total = @Total + @TotalDeletedRows
				SET @Total = @Total + @TotalRows
                FETCH NEXT FROM c INTO @TableName, @PkCols
            END

			CLOSE c
			DEALLOCATE c

			DELETE FROM dbo.Retailer WHERE Id = @RetailerId
			SET @Error = 0
			SELECT @ErrorMessage = '', @Error = 0	
        COMMIT TRANSACTION        
    END TRY
    BEGIN CATCH
		--DECLARE @Var VARCHAR(100)  
        --SELECT @Var = 'Exception: ' + ERROR_MESSAGE()
        --RAISERROR(@Var, 16,1) WITH LOG
		SELECT @ErrorMessage = ERROR_MESSAGE(), @Error = 1		
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN
        CLOSE c
        DEALLOCATE c
    END CATCH

	DECLARE @EndTime DATETIMEOFFSET = SYSDATETIMEOFFSET()
	IF @Error = 0
		PRINT 'Total: ' + CAST(@Total AS VARCHAR) + ' | Duration: ' + CAST(DATEDIFF(s,@StartTime,@EndTime) AS VARCHAR)
    ELSE
		PRINT 'Error: ' + @ErrorMessage

	SET @TotalRowDeleted = @Total
	SET @Duration = DATEDIFF(s,@StartTime,@EndTime)
END
GO
CREATE OR ALTER PROCEDURE [dba].[usp_Dba_UpdateForeignKeyState]
    @DatabaseName NVARCHAR(50),
    @Enable BIT = 1
AS
BEGIN
    SET NOCOUNT ON;
 
    DECLARE @Sql NVARCHAR(4000)
    DECLARE @cmd NVARCHAR(20) = IIF(@Enable = 1, 'CHECK', 'NOCHECK')
 
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPaymentAllocation] ' + @cmd + ' CONSTRAINT [FK_PayslipPaymentAllocation_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookCustomerGroup] ' + @cmd + ' CONSTRAINT [FK_PriceBookCustomerGroup_CustomerGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryPackage] ' + @cmd + ' CONSTRAINT [FK_DeliveryPackage_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplier] ' + @cmd + ' CONSTRAINT [FK_OrderSuppliers_Supplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookDependency] ' + @cmd + ' CONSTRAINT [FK_PriceBookDependency_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookCustomerGroup] ' + @cmd + ' CONSTRAINT [FK_PriceBookCustomerGroup_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplier] ' + @cmd + ' CONSTRAINT [FK_OrderSuppliers_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPaymentAllocation] ' + @cmd + ' CONSTRAINT [FK_PayslipPaymentAllocation_BankAccount]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookDetail] ' + @cmd + ' CONSTRAINT [FK_PriceBookDetail_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryPackage] ' + @cmd + ' CONSTRAINT [FK_DeliveryPackage_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplier] ' + @cmd + ' CONSTRAINT [FK_OrderSuppliers_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookDetail] ' + @cmd + ' CONSTRAINT [FK_PriceBookDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPayment] ' + @cmd + ' CONSTRAINT [FK_PayslipPayment_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplier] ' + @cmd + ' CONSTRAINT [FK_OrderSuppliers_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryPayment] ' + @cmd + ' CONSTRAINT [FK_DeliveryPayment_PartnerDelivery]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookUser] ' + @cmd + ' CONSTRAINT [FK_PriceBookUser_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_CreatedUser]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplier] ' + @cmd + ' CONSTRAINT [FK_OrderSupplier_UserCreatedBy]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPayment] ' + @cmd + ' CONSTRAINT [FK_PayslipPayment_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookUser] ' + @cmd + ' CONSTRAINT [FK_PriceBookUser_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryPayment] ' + @cmd + ' CONSTRAINT [FK_DeliveryPayment_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Product] ' + @cmd + ' CONSTRAINT [FK_Product_Category]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_TableAndRoom]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Clinic] ' + @cmd + ' CONSTRAINT [FK_Clinic_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPayment] ' + @cmd + ' CONSTRAINT [FK_PayslipPayment_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Product] ' + @cmd + ' CONSTRAINT [FK_Product_Master]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryPayment] ' + @cmd + ' CONSTRAINT [FK_DeliveryPayment_DeliveryInfo]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Product] ' + @cmd + ' CONSTRAINT [FK_Product_MasterUnit]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_New_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductAttribute] ' + @cmd + ' CONSTRAINT [FK_ProductAttribute_Attribute]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPayment] ' + @cmd + ' CONSTRAINT [FK_PayslipPayment_BankAccount]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductAttribute] ' + @cmd + ' CONSTRAINT [FK_ProductAttribute_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryPayment] ' + @cmd + ' CONSTRAINT [FK_DeliveryPayment_Payment]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DoctorQualification] ' + @cmd + ' CONSTRAINT [FK_DoctorQualification_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_SaleChannel]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductBatchExpire] ' + @cmd + ' CONSTRAINT [FK_ProductBatchExpire_BatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryPayment] ' + @cmd + ' CONSTRAINT [FK_DeliveryPayment_PurchasePayment]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductBatchExpireBranch] ' + @cmd + ' CONSTRAINT [FK_ProductBatchExpireBranch_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ReturnDetail] ' + @cmd + ' CONSTRAINT [FK_RefundDetails_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DoctorSpeciality] ' + @cmd + ' CONSTRAINT [FK_DoctorSpeciality_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Device] ' + @cmd + ' CONSTRAINT [FK_Device_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductBranch] ' + @cmd + ' CONSTRAINT [FK__ProductBr__Produ__6478B84A]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ReturnDetail] ' + @cmd + ' CONSTRAINT [FK_RefundDetails_Refund]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Doctor] ' + @cmd + ' CONSTRAINT [FK_Doctor_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Device] ' + @cmd + ' CONSTRAINT [FK_Device_CreatedUser]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductFormula] ' + @cmd + ' CONSTRAINT [FK_ProductFormula_Material]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ReturnDetail] ' + @cmd + ' CONSTRAINT [FK_RefundDetails_ProductFormulaHistory]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Doctor] ' + @cmd + ' CONSTRAINT [FK_Doctor_Clinic]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[EmailMarketing] ' + @cmd + ' CONSTRAINT [FK_EmailMarketing_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductFormula] ' + @cmd + ' CONSTRAINT [FK_ProductFormula_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ReturnDetail] ' + @cmd + ' CONSTRAINT [FK_RefundDetail_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceMedicine] ' + @cmd + ' CONSTRAINT [FK_InvoiceMedicine_Prescription]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[EmailTemplate] ' + @cmd + ' CONSTRAINT [FK_EmailTemplate_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductFormulaHistory] ' + @cmd + ' CONSTRAINT [FK_ProductFormulaHistory_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeviceSession] ' + @cmd + ' CONSTRAINT [FK_DeviceSession_UserDevice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceMedicine] ' + @cmd + ' CONSTRAINT [FK_InvoiceMedicine_Patient]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[RewardPointCustomerGroup] ' + @cmd + ' CONSTRAINT [FK_RewardPointCustomerGroup_CustomerGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductImage] ' + @cmd + ' CONSTRAINT [FK_ProductImage_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ExpensesOther] ' + @cmd + ' CONSTRAINT [FK_ExpensesOther_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Patient] ' + @cmd + ' CONSTRAINT [FK_Patient_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[UserDevice] ' + @cmd + ' CONSTRAINT [FK_UserDevice_UserId]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductSerial] ' + @cmd + ' CONSTRAINT [FK_ProductSerial_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[RewardPointCustomerGroup] ' + @cmd + ' CONSTRAINT [FK_RewardPointCustomerGroup_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Patient] ' + @cmd + ' CONSTRAINT [FK_Patient_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ExpensesOtherBranch] ' + @cmd + ' CONSTRAINT [FK_ExpensesOtherBranch_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductSerial] ' + @cmd + ' CONSTRAINT [FK_ProductSerial_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[UserDevice] ' + @cmd + ' CONSTRAINT [FK_UserDevice_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Prescription] ' + @cmd + ' CONSTRAINT [FK_Prescription_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SaleChannel] ' + @cmd + ' CONSTRAINT [FK_SaleChannel_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductShelves] ' + @cmd + ' CONSTRAINT [FK_ProductShelves_Shelves]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SurchargeBranch] ' + @cmd + ' CONSTRAINT [FK_SurchargeBranch_Surcharge]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ExpensesOtherBranch] ' + @cmd + ' CONSTRAINT [FK_ExpensesOtherBranch_ExpensesOther]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Prescription] ' + @cmd + ' CONSTRAINT [FK_Prescription_Doctor]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SmsEmailTemplate] ' + @cmd + ' CONSTRAINT [FK_SmsEmailTemplate_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductShelves] ' + @cmd + ' CONSTRAINT [FK_ProductShelves_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDetail] ' + @cmd + ' CONSTRAINT [FK_InvoiceDetail_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ImportExportFile] ' + @cmd + ' CONSTRAINT [FK_ImportExportFile_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Prescription] ' + @cmd + ' CONSTRAINT [FK_Prescription_Clinic]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CustomerSupplierCombine] ' + @cmd + ' CONSTRAINT [FK_CustomerSupplierCombine_Supplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SmsEmailTemplate] ' + @cmd + ' CONSTRAINT [FK_SmsEmailTemplate_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PropertyAccess] ' + @cmd + ' CONSTRAINT [FK_PropertyAccess_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[TableAndRoom] ' + @cmd + ' CONSTRAINT [FK_TableAndRoom_TableGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PropertyAccess] ' + @cmd + ' CONSTRAINT [FK_PropertyAccess_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDetail] ' + @cmd + ' CONSTRAINT [FK_InvoiceDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[StockTake] ' + @cmd + ' CONSTRAINT [FK_StockTake_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PropertyAccess] ' + @cmd + ' CONSTRAINT [FK_PropertyAccess_Role]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryCrossCheck] ' + @cmd + ' CONSTRAINT [FK_DeliveryCrossCheck_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderDetail] ' + @cmd + ' CONSTRAINT [FK_OrderDetail_ProductFormulaHistory]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[TableAndRoom] ' + @cmd + ' CONSTRAINT [FK_TableAndRoom_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[StockTake] ' + @cmd + ' CONSTRAINT [FK_StockTake_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Clinic] ' + @cmd + ' CONSTRAINT [FK_Clinic_Route]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDetail] ' + @cmd + ' CONSTRAINT [FK_InvoiceDetail_ProductFormulaHistory]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PropertyAccess] ' + @cmd + ' CONSTRAINT [FK_PropertyAccess_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryCrossCheck] ' + @cmd + ' CONSTRAINT [FK_DeliveryCrossCheck_Payment]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[StockTake] ' + @cmd + ' CONSTRAINT [FK_StockTake_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Clinic] ' + @cmd + ' CONSTRAINT [FK_Clinic_Type]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[TokenApi] ' + @cmd + ' CONSTRAINT [FK_TokenApi_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_SoldBy]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrder] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrders_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDetail] ' + @cmd + ' CONSTRAINT [FK_InvoiceDetail_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[StockTake] ' + @cmd + ' CONSTRAINT [FK_StockTake_UserCreate]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Clinic] ' + @cmd + ' CONSTRAINT [FK_Clinic_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryCrossCheck] ' + @cmd + ' CONSTRAINT [FK_DeliveryCrossCheck_PurchasePayment]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_CreatedUser]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrder] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrders_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Transfer] ' + @cmd + ' CONSTRAINT [FK_Transfer_FromBranch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[StockTakeDetail] ' + @cmd + ' CONSTRAINT [FK_StockTakeDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceMedicine] ' + @cmd + ' CONSTRAINT [FK_InvoiceMedicine_Clinic]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceOrderSurcharge] ' + @cmd + ' CONSTRAINT [FK_InvoiceOrderSurcharge_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_TableAndRoom]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrder] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrders_Supplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Transfer] ' + @cmd + ' CONSTRAINT [FK_Transfer_ToBranch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[StockTakeDetail] ' + @cmd + ' CONSTRAINT [FK_StockTakeDetail_StockTake]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceMedicine] ' + @cmd + ' CONSTRAINT [FK_InvoiceMedicine_Doctor]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceOrderSurcharge] ' + @cmd + ' CONSTRAINT [FK_InvoiceOrderSurcharge_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryInfo] ' + @cmd + ' CONSTRAINT [FK_DeliveryInfo_BranchTakingAddress]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Transfer] ' + @cmd + ' CONSTRAINT [FK_Transfer_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Supplier] ' + @cmd + ' CONSTRAINT [FK_Supplier_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrder] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrder_UserCreatedBy]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceOrderSurcharge] ' + @cmd + ' CONSTRAINT [FK_InvoiceOrderSurcharge_Return]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Invoice] ' + @cmd + ' CONSTRAINT [FK_Invoice_SaleChannel]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceMedicine] ' + @cmd + ' CONSTRAINT [FK_InvoiceMedicine_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Transfer] ' + @cmd + ' CONSTRAINT [FK_Transfer_User1]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Supplier] ' + @cmd + ' CONSTRAINT [FK_Supplier_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[AdrApplication] ' + @cmd + ' CONSTRAINT [FK_AdrApplocation_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceOrderSurcharge] ' + @cmd + ' CONSTRAINT [FK_InvoiceOrderSurcharge_Surcharge]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDelivery] ' + @cmd + ' CONSTRAINT [FK_InvoiceDelivery_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrder] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrders_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[TransferDetail] ' + @cmd + ' CONSTRAINT [FK_TransferDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SupplierGroupDetail] ' + @cmd + ' CONSTRAINT [FK_SupplierGroupDetail_Supplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Doctor] ' + @cmd + ' CONSTRAINT [FK_Doctor_Office]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoicePromotion] ' + @cmd + ' CONSTRAINT [FK_InvoicePromotion_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDelivery] ' + @cmd + ' CONSTRAINT [FK_InvoiceDelivery_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[AdrApplication] ' + @cmd + ' CONSTRAINT [FK_AdrApplocation_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[TransferDetail] ' + @cmd + ' CONSTRAINT [FK_TransferDetail_Transfer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SupplierGroupDetail] ' + @cmd + ' CONSTRAINT [FK_SupplierGroupDetail_SupplierGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrderDetail] ' + @cmd + ' CONSTRAINT [FK_PurchaseDetails_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceVoucher] ' + @cmd + ' CONSTRAINT [FK_InvoiceVoucher_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDelivery] ' + @cmd + ' CONSTRAINT [FK_InvoiceDelivery_PartnerDelivery]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Doctor] ' + @cmd + ' CONSTRAINT [FK_Doctor_Qualification]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[TransferDetail] ' + @cmd + ' CONSTRAINT [FK_TransferDetail_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Surcharge] ' + @cmd + ' CONSTRAINT [FK_Surcharge_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[AdrApplication] ' + @cmd + ' CONSTRAINT [FK_AdrApplocation_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Manufacturing] ' + @cmd + ' CONSTRAINT [FK_Manufacturing_ProductFormulaHistory]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDelivery] ' + @cmd + ' CONSTRAINT [FK_InvoiceDelivery_Location]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrderDetail] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrderDetail_PurchaseOrder]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Voucher] ' + @cmd + ' CONSTRAINT [FK_Voucher_VoucherCampaign]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CustomerDetail] ' + @cmd + ' CONSTRAINT [FK_CustomerDetail_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Doctor] ' + @cmd + ' CONSTRAINT [FK_Doctor_Speciality]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Manufacturing] ' + @cmd + ' CONSTRAINT [FK_Manufacturing_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SurchargeBranch] ' + @cmd + ' CONSTRAINT [FK_SurchargeBranch_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[App] ' + @cmd + ' CONSTRAINT [FK_App_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[VoucherBranch] ' + @cmd + ' CONSTRAINT [FK_Branch_VoucherCampaign]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceDeliveryTracking] ' + @cmd + ' CONSTRAINT [FK_InvoiceDeliveryTracking_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrderDetail] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrderDetail_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Manufacturing] ' + @cmd + ' CONSTRAINT [FK_Manufacturing_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CustomerSupplierCombine] ' + @cmd + ' CONSTRAINT [FK_CustomerSupplierCombine_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Doctor] ' + @cmd + ' CONSTRAINT [FK_Doctor_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[VoucherCustomerGroup] ' + @cmd + ' CONSTRAINT [FK_CG_VoucherCampaign]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[BalanceAdjustment] ' + @cmd + ' CONSTRAINT [FK_BalanceAdjustment_AdjustmentUser]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ManufacturingDetail] ' + @cmd + ' CONSTRAINT [FK_ManufacturingDetail_Manufacturing]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrderExpensesOther] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrderExpensesOther_PurchaseOrder]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskItem] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskItem_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DoctorOffice] ' + @cmd + ' CONSTRAINT [FK_DoctorOffice_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[VoucherCustomerGroup] ' + @cmd + ' CONSTRAINT [FK_CG_CustomerGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[BalanceAdjustment] ' + @cmd + ' CONSTRAINT [FK_BalanceAdjustment_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ManufacturingDetail] ' + @cmd + ' CONSTRAINT [FK_ManufacturingDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrderExpensesOther] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrderExpensesOther_ExpensesOther]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Customer] ' + @cmd + ' CONSTRAINT [FK_Customer_Location]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DoctorQualification] ' + @cmd + ' CONSTRAINT [FK_DoctorQualification_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskItem] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskItem_ShippingTask]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[BankAccount] ' + @cmd + ' CONSTRAINT [FK_BankAccount_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[VoucherUser] ' + @cmd + ' CONSTRAINT [FK_User_VoucherCampaign]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskDetail_ShippingTask]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DoctorSpeciality] ' + @cmd + ' CONSTRAINT [FK_DoctorSpeciality_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ManufacturingMaterialTracking] ' + @cmd + ' CONSTRAINT [FK_ManufacturingMaterialTracking_Manufacturing]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[BatchExpire] ' + @cmd + ' CONSTRAINT [FK_BatchExpire_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Customer] ' + @cmd + ' CONSTRAINT [FK_Customer_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_PurchaseOrder]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Wards] ' + @cmd + ' CONSTRAINT [FK_Location]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ProductMedicine] ' + @cmd + ' CONSTRAINT [FK_ProductMedicine_MedicineManufacturer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskDetail_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Branch] ' + @cmd + ' CONSTRAINT [FK_Branch_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[NotificationSetting] ' + @cmd + ' CONSTRAINT [FK_NotificationSetting_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_PurchaseReturn]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskDetail_SenderLocation]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[MedicineManufacturer] ' + @cmd + ' CONSTRAINT [FK_MedicineManufacturer_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SamplePrescriptionDetail] ' + @cmd + ' CONSTRAINT [FK_SamplePrescriptionDetail_SamplePrescription]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CashFlow] ' + @cmd + ' CONSTRAINT [FK_CashFlow_CashFlowGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[NotificationSetting] ' + @cmd + ' CONSTRAINT [FK_NotificationSetting_CreatedUser]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskDetail_SenderWard]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PrescriptionDetail] ' + @cmd + ' CONSTRAINT [FK_PrescriptionDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SamplePrescriptionDetail] ' + @cmd + ' CONSTRAINT [FK_SamplePrescriptionDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CashFlow] ' + @cmd + ' CONSTRAINT [FK_CashFlow_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ObjectAccess] ' + @cmd + ' CONSTRAINT [FK_ObjectAccess_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_Supplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskOrderDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskOrderDetail_ShippingTask]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Prescription] ' + @cmd + ' CONSTRAINT [FK_Prescription_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[SamplePrescription] ' + @cmd + ' CONSTRAINT [FK_SamplePrescription_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Category] ' + @cmd + ' CONSTRAINT [FK_Parent]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ObjectAccess] ' + @cmd + ' CONSTRAINT [FK_ObjectAccess_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_PartnerDelivery]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskOrderDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskOrderDetail_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CostAdjustment] ' + @cmd + ' CONSTRAINT [FK_CostAdjustment_AdjustmentUser]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ObjectAccess] ' + @cmd + ' CONSTRAINT [FK_ObjectAccess_Role]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskOrderDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskOrderDetail_DeliveryInfo]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_BankAccount]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ObjectAccess] ' + @cmd + ' CONSTRAINT [FK_ObjectAccess_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Customer] ' + @cmd + ' CONSTRAINT [FK_Customer_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTaskOrderDetail] ' + @cmd + ' CONSTRAINT [FK_ShippingTaskOrderDetail_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturn] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturn_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Order] ' + @cmd + ' CONSTRAINT [FK_Order_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturn] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturn_PurchaseOrder]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[BranchTakingAddress] ' + @cmd + ' CONSTRAINT [FK_BranchTakingAddress_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CustomerGroupDetail] ' + @cmd + ' CONSTRAINT [FK_CustomerGroupDetail_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Order] ' + @cmd + ' CONSTRAINT [FK_Order_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturn] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturn_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[BranchTakingAddress] ' + @cmd + ' CONSTRAINT [FK_BranchTakingAddress_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[RetailerRouteOfAdministration] ' + @cmd + ' CONSTRAINT [FK_RetailerRouteOfAdministration_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Order] ' + @cmd + ' CONSTRAINT [FK_Order_Soldby]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CustomerGroupDetail] ' + @cmd + ' CONSTRAINT [FK_CustomerGroupDetail_CustomerGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Order] ' + @cmd + ' CONSTRAINT [FK_Order_TableAndRoom]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturn] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturn_Supplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Order] ' + @cmd + ' CONSTRAINT [FK_Order_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[CustomerSocial] ' + @cmd + ' CONSTRAINT [FK_CustomerSocial_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceVoucher] ' + @cmd + ' CONSTRAINT [FK_InvoiceVoucher_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturn] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturn_UserCreatedBy]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Order] ' + @cmd + ' CONSTRAINT [FK_Order_SaleChannel]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DamageDetail] ' + @cmd + ' CONSTRAINT [FK_DamageDetail_DamageItem]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderDetail] ' + @cmd + ' CONSTRAINT [FK_OrderDetail_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderDetail] ' + @cmd + ' CONSTRAINT [FK_OrderDetail_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderDetail] ' + @cmd + ' CONSTRAINT [FK_OrderDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturn] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturn_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PartnerDelivery] ' + @cmd + ' CONSTRAINT [FK_PartnerDelivery_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DamageDetail] ' + @cmd + ' CONSTRAINT [FK_DamageDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceExtraData] ' + @cmd + ' CONSTRAINT [FK_InvoiceExtraData_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderPromotion] ' + @cmd + ' CONSTRAINT [FK_OrderPromotion_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PartnerDeliveryGroupDetail] ' + @cmd + ' CONSTRAINT [FK_PartnerDeliveryGroupDetail_PartnerDelivery]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturnDetail] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturnDetail_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceExtraData] ' + @cmd + ' CONSTRAINT [FK_InvoiceExtraData_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DamageDetail] ' + @cmd + ' CONSTRAINT [FK_DamageDetail_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PartnerDeliveryGroupDetail] ' + @cmd + ' CONSTRAINT [FK_PartnerDeliveryGroupDetail_PartnerDeliveryGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturnDetail] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturnDetail_PurchaseReturn]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Payment] ' + @cmd + ' CONSTRAINT [FK_Payment_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DamageItem] ' + @cmd + ' CONSTRAINT [FK_DamageItem_UserCreatedBy]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Product] ' + @cmd + ' CONSTRAINT [FK_Product_TradeMark]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[AddressBook] ' + @cmd + ' CONSTRAINT [FK_AddressBook_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Payment] ' + @cmd + ' CONSTRAINT [FK_Payment_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturnDetail] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturnDetail_ProductBatchExpire]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[ShippingTask] ' + @cmd + ' CONSTRAINT [FK_ShippingTask_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DamageItem] ' + @cmd + ' CONSTRAINT [FK_DamageItem_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Payment] ' + @cmd + ' CONSTRAINT [FK_Payment_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[AddressBook] ' + @cmd + ' CONSTRAINT [FK_AddressBook_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Payment] ' + @cmd + ' CONSTRAINT [FK_Payment_Return]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturnExpensesOther] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturnExpensesOther_PurchaseReturn]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Payment] ' + @cmd + ' CONSTRAINT [FK_Payment_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DamageItem] ' + @cmd + ' CONSTRAINT [FK_DamageItem_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Payment] ' + @cmd + ' CONSTRAINT [FK_Payment_BankAccount]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceWarranty] ' + @cmd + ' CONSTRAINT [FK_InvoiceWarranty_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Payment] ' + @cmd + ' CONSTRAINT [FK_Payment_Voucher]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseReturnExpensesOther] ' + @cmd + ' CONSTRAINT [FK_PurchaseReturnExpensesOther_ExpensesOther]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Permission] ' + @cmd + ' CONSTRAINT [FK_Permission_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryInfo] ' + @cmd + ' CONSTRAINT [FK_DeliveryInfo_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Permission] ' + @cmd + ' CONSTRAINT [FK_Permission_Role]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[InvoiceWarranty] ' + @cmd + ' CONSTRAINT [FK_InvoiceWarranty_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Permission] ' + @cmd + ' CONSTRAINT [FK_Permission_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Retailer] ' + @cmd + ' CONSTRAINT [FK_Retailer_Group]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplierDetail] ' + @cmd + ' CONSTRAINT [FK_OrderSupplierDetail_OrderSupplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryInfo] ' + @cmd + ' CONSTRAINT [FK_DeliveryInfo_Order]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PointAdjustment] ' + @cmd + ' CONSTRAINT [FK_PointAdjustment_AdjustmentUser]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[WarrantyBranchGroup] ' + @cmd + ' CONSTRAINT [FK_WarrantyBranchGroup_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplierDetail] ' + @cmd + ' CONSTRAINT [FK_OrderSupplierDetails_Product]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PointAdjustment] ' + @cmd + ' CONSTRAINT [FK_PointAdjustment_User]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPaymentAllocation] ' + @cmd + ' CONSTRAINT [FK_PayslipPaymentAllocation_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[AuditTerm] ' + @cmd + ' CONSTRAINT [FK_AuditTerm_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryInfo] ' + @cmd + ' CONSTRAINT [FK_DeliveryInfo_DeliveryPackage]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplierExpensesOther] ' + @cmd + ' CONSTRAINT [FK_OrderSupplierExpensesOther_PurchaseOrder]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[WarrantyBranchGroup] ' + @cmd + ' CONSTRAINT [FK_WarrantyBranchGroup_BranchGroup]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBook] ' + @cmd + ' CONSTRAINT [FK_PriceBook_Retailer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_Customer]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[OrderSupplierExpensesOther] ' + @cmd + ' CONSTRAINT [FK_OrderSupplierExpensesOther_ExpensesOther]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PayslipPaymentAllocation] ' + @cmd + ' CONSTRAINT [FK_PayslipPaymentAllocation_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookBranch] ' + @cmd + ' CONSTRAINT [FK_PriceBookBranch_Branch]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[DeliveryInfo] ' + @cmd + ' CONSTRAINT [FK_DeliveryInfo_PartnerDelivery]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchaseOrder] ' + @cmd + ' CONSTRAINT [FK_PurchaseOrders_OrderSupplier]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookDependency] ' + @cmd + ' CONSTRAINT [FK_PriceBookDependency_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PriceBookBranch] ' + @cmd + ' CONSTRAINT [FK_PriceBookBranch_PriceBook]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[Return] ' + @cmd + ' CONSTRAINT [FK_Return_Invoice]');
    EXEC('ALTER TABLE [' + @DatabaseName + ']. [dbo].[PurchasePayment] ' + @cmd + ' CONSTRAINT [FK_PurchasePayment_OrderSupplier]');
END
GO
/* Step 3: Init Data */
BEGIN TRAN
INSERT [dba].[TableList] SELECT 'AccountDebt'
INSERT [dba].[TableList] SELECT 'AddressBook'
INSERT [dba].[TableList] SELECT 'AdrApplication'
INSERT [dba].[TableList] SELECT 'App'
INSERT [dba].[TableList] SELECT 'Attribute'
INSERT [dba].[TableList] SELECT 'AuditLogTrack'
INSERT [dba].[TableList] SELECT 'AuditTerm'
INSERT [dba].[TableList] SELECT 'AutoGeneratedCode'
INSERT [dba].[TableList] SELECT 'BalanceAdjustment'
INSERT [dba].[TableList] SELECT 'BalanceCustomerSupplierTracking'
INSERT [dba].[TableList] SELECT 'BalanceTracking'
INSERT [dba].[TableList] SELECT 'BankAccount'
INSERT [dba].[TableList] SELECT 'BatchExpire'
INSERT [dba].[TableList] SELECT 'BatchExpireTracking'
INSERT [dba].[TableList] SELECT 'BatchShadow'
INSERT [dba].[TableList] SELECT 'Branch'
INSERT [dba].[TableList] SELECT 'BranchTakingAddress'
INSERT [dba].[TableList] SELECT 'CashFlow'
INSERT [dba].[TableList] SELECT 'CashFlowGroup'
INSERT [dba].[TableList] SELECT 'Category'
INSERT [dba].[TableList] SELECT 'ClearRetailerHistory'
INSERT [dba].[TableList] SELECT 'Clinic'
INSERT [dba].[TableList] SELECT 'CloneObject'
INSERT [dba].[TableList] SELECT 'CostAdjustment'
INSERT [dba].[TableList] SELECT 'Customer'
INSERT [dba].[TableList] SELECT 'CustomerBranch'
INSERT [dba].[TableList] SELECT 'CustomerDetail'
INSERT [dba].[TableList] SELECT 'CustomerGroup'
INSERT [dba].[TableList] SELECT 'CustomerGroupDetail'
INSERT [dba].[TableList] SELECT 'CustomerSocial'
INSERT [dba].[TableList] SELECT 'CustomerSupplierCombine'
INSERT [dba].[TableList] SELECT 'CustomerZalo'
INSERT [dba].[TableList] SELECT 'DamageDetail'
INSERT [dba].[TableList] SELECT 'DamageItem'
INSERT [dba].[TableList] SELECT 'DeliveryCrossCheck'
INSERT [dba].[TableList] SELECT 'DeliveryInfo'
INSERT [dba].[TableList] SELECT 'DeliveryPackage'
INSERT [dba].[TableList] SELECT 'DeliveryPayment'
INSERT [dba].[TableList] SELECT 'Device'
INSERT [dba].[TableList] SELECT 'DeviceSession'
INSERT [dba].[TableList] SELECT 'Doctor'
INSERT [dba].[TableList] SELECT 'DoctorOffice'
INSERT [dba].[TableList] SELECT 'DoctorQualification'
INSERT [dba].[TableList] SELECT 'DoctorSpeciality'
INSERT [dba].[TableList] SELECT 'EmailMarketing'
INSERT [dba].[TableList] SELECT 'EmailTemplate'
INSERT [dba].[TableList] SELECT 'EventTracking'
INSERT [dba].[TableList] SELECT 'EventTrackingDetail'
INSERT [dba].[TableList] SELECT 'ExpensesOther'
INSERT [dba].[TableList] SELECT 'ExpensesOtherBranch'
INSERT [dba].[TableList] SELECT 'ImeiTracking'
INSERT [dba].[TableList] SELECT 'ImportExportFile'
INSERT [dba].[TableList] SELECT 'InventoryTracking'
INSERT [dba].[TableList] SELECT 'Invoice'
INSERT [dba].[TableList] SELECT 'InvoiceDelivery'
INSERT [dba].[TableList] SELECT 'InvoiceDeliveryTracking'
INSERT [dba].[TableList] SELECT 'InvoiceDetail'
INSERT [dba].[TableList] SELECT 'InvoiceExtraData'
INSERT [dba].[TableList] SELECT 'InvoiceMedicine'
INSERT [dba].[TableList] SELECT 'InvoiceOrderSurcharge'
INSERT [dba].[TableList] SELECT 'InvoicePromotion'
INSERT [dba].[TableList] SELECT 'InvoiceVoucher'
INSERT [dba].[TableList] SELECT 'InvoiceWarranty'
INSERT [dba].[TableList] SELECT 'LocalStorage'
INSERT [dba].[TableList] SELECT 'Manufacturing'
INSERT [dba].[TableList] SELECT 'ManufacturingDetail'
INSERT [dba].[TableList] SELECT 'ManufacturingMaterialTracking'
INSERT [dba].[TableList] SELECT 'MedicineManufacturer'
INSERT [dba].[TableList] SELECT 'NotificationSetting'
INSERT [dba].[TableList] SELECT 'ObjectAccess'
INSERT [dba].[TableList] SELECT 'Order'
INSERT [dba].[TableList] SELECT 'OrderDetail'
INSERT [dba].[TableList] SELECT 'OrderPromotion'
INSERT [dba].[TableList] SELECT 'OrderSupplier'
INSERT [dba].[TableList] SELECT 'OrderSupplierDetail'
INSERT [dba].[TableList] SELECT 'OrderSupplierExpensesOther'
INSERT [dba].[TableList] SELECT 'OrderSupplierTracking'
INSERT [dba].[TableList] SELECT 'OrderTracking'
INSERT [dba].[TableList] SELECT 'Partner'
INSERT [dba].[TableList] SELECT 'PartnerDelivery'
INSERT [dba].[TableList] SELECT 'PartnerDeliveryGroup'
INSERT [dba].[TableList] SELECT 'PartnerDeliveryGroupDetail'
INSERT [dba].[TableList] SELECT 'Patient'
INSERT [dba].[TableList] SELECT 'Payment'
INSERT [dba].[TableList] SELECT 'PaymentAllocation'
INSERT [dba].[TableList] SELECT 'PaymentTrack'
INSERT [dba].[TableList] SELECT 'PayslipPayment'
INSERT [dba].[TableList] SELECT 'PayslipPaymentAllocation'
INSERT [dba].[TableList] SELECT 'PayslipPaymentTracking'
INSERT [dba].[TableList] SELECT 'Permission'
INSERT [dba].[TableList] SELECT 'PointAdjustment'
INSERT [dba].[TableList] SELECT 'PointTracking'
INSERT [dba].[TableList] SELECT 'PosParameter'
INSERT [dba].[TableList] SELECT 'Prescription'
INSERT [dba].[TableList] SELECT 'PrescriptionDetail'
INSERT [dba].[TableList] SELECT 'PriceBook'
INSERT [dba].[TableList] SELECT 'PriceBookBranch'
INSERT [dba].[TableList] SELECT 'PriceBookCustomerGroup'
INSERT [dba].[TableList] SELECT 'PriceBookDependency'
INSERT [dba].[TableList] SELECT 'PriceBookDetail'
INSERT [dba].[TableList] SELECT 'PriceBookUser'
INSERT [dba].[TableList] SELECT 'PrintTemplate'
INSERT [dba].[TableList] SELECT 'Product'
INSERT [dba].[TableList] SELECT 'ProductAttribute'
INSERT [dba].[TableList] SELECT 'ProductBatchExpire'
INSERT [dba].[TableList] SELECT 'ProductBatchExpireBranch'
INSERT [dba].[TableList] SELECT 'ProductBranch'
INSERT [dba].[TableList] SELECT 'ProductFormula'
INSERT [dba].[TableList] SELECT 'ProductFormulaHistory'
INSERT [dba].[TableList] SELECT 'ProductImage'
INSERT [dba].[TableList] SELECT 'ProductMedicine'
INSERT [dba].[TableList] SELECT 'ProductSerial'
INSERT [dba].[TableList] SELECT 'ProductShelves'
INSERT [dba].[TableList] SELECT 'ProductUnitSuggestion'
INSERT [dba].[TableList] SELECT 'PropertyAccess'
INSERT [dba].[TableList] SELECT 'PurchaseOrder'
INSERT [dba].[TableList] SELECT 'PurchaseOrderDetail'
INSERT [dba].[TableList] SELECT 'PurchaseOrderExpensesOther'
INSERT [dba].[TableList] SELECT 'PurchaseOrderHistory'
INSERT [dba].[TableList] SELECT 'PurchasePayment'
INSERT [dba].[TableList] SELECT 'PurchaseReturn'
INSERT [dba].[TableList] SELECT 'PurchaseReturnDetail'
INSERT [dba].[TableList] SELECT 'PurchaseReturnExpensesOther'
INSERT [dba].[TableList] SELECT 'Retailer'
INSERT [dba].[TableList] SELECT 'RetailerOrderSupplier'
INSERT [dba].[TableList] SELECT 'RetailerRouteOfAdministration'
INSERT [dba].[TableList] SELECT 'Return'
INSERT [dba].[TableList] SELECT 'ReturnDetail'
INSERT [dba].[TableList] SELECT 'RewardPointCustomerGroup'
INSERT [dba].[TableList] SELECT 'Role'
INSERT [dba].[TableList] SELECT 'SaleChannel'
INSERT [dba].[TableList] SELECT 'SamplePrescription'
INSERT [dba].[TableList] SELECT 'SamplePrescriptionDetail'
INSERT [dba].[TableList] SELECT 'Shelves'
INSERT [dba].[TableList] SELECT 'ShippingTask'
INSERT [dba].[TableList] SELECT 'ShippingTaskDetail'
INSERT [dba].[TableList] SELECT 'ShippingTaskItem'
INSERT [dba].[TableList] SELECT 'ShippingTaskOrderDetail'
INSERT [dba].[TableList] SELECT 'SmsEmailHistory'
INSERT [dba].[TableList] SELECT 'SmsEmailSetting'
INSERT [dba].[TableList] SELECT 'SmsEmailTemplate'
INSERT [dba].[TableList] SELECT 'StockTake'
INSERT [dba].[TableList] SELECT 'StockTakeDetail'
INSERT [dba].[TableList] SELECT 'StockTakeHistory'
INSERT [dba].[TableList] SELECT 'Supplier'
INSERT [dba].[TableList] SELECT 'SupplierGroup'
INSERT [dba].[TableList] SELECT 'SupplierGroupDetail'
INSERT [dba].[TableList] SELECT 'Surcharge'
INSERT [dba].[TableList] SELECT 'SurchargeBranch'
INSERT [dba].[TableList] SELECT 'SyncNationalPharmacyEvent'
INSERT [dba].[TableList] SELECT 'TableAndRoom'
INSERT [dba].[TableList] SELECT 'TableGroup'
INSERT [dba].[TableList] SELECT 'TimeAccess'
INSERT [dba].[TableList] SELECT 'TimeSheetCommissionSync'
INSERT [dba].[TableList] SELECT 'TokenApi'
INSERT [dba].[TableList] SELECT 'TradeMark'
INSERT [dba].[TableList] SELECT 'TradeMarkHistory'
INSERT [dba].[TableList] SELECT 'Transfer'
INSERT [dba].[TableList] SELECT 'TransferDetail'
INSERT [dba].[TableList] SELECT 'User'
INSERT [dba].[TableList] SELECT 'UserDevice'
INSERT [dba].[TableList] SELECT 'UserSession'
INSERT [dba].[TableList] SELECT 'Voucher'
INSERT [dba].[TableList] SELECT 'VoucherBranch'
INSERT [dba].[TableList] SELECT 'VoucherCampaign'
INSERT [dba].[TableList] SELECT 'VoucherCustomerGroup'
INSERT [dba].[TableList] SELECT 'VoucherUser'
INSERT [dba].[TableList] SELECT 'WarrantyBranchGroup'
COMMIT
GO
DROP TABLE IF EXISTS #TmpRetailer
SELECT * INTO #TmpRetailer FROM DBMASTER.KiotVietMaster.dbo.KvRetailer WHERE GroupId = 18
;WITH cte AS (
SELECT * FROM KiotVietShard18Archived.dbo.Retailer WHERE Id NOT IN (SELECT Id FROM #TmpRetailer) AND Id > 0 -- different groupid
UNION ALL
SELECT * FROM KiotVietShard18Archived.dbo.Retailer WHERE Id NOT IN (SELECT -Id FROM #TmpRetailer) AND Id < 0 -- different groupid & deleted
UNION ALL
SELECT * FROM KiotVietShard18Archived.dbo.Retailer WHERE Id IN (SELECT Id FROM #TmpRetailer WHERE ExpiryDate < '2021-01-01' AND ModifiedDate < '2021-01-01') AND Id > 0 -- expired
UNION ALL
SELECT * FROM KiotVietShard18Archived.dbo.Retailer WHERE Id IN (SELECT -Id FROM #TmpRetailer WHERE ExpiryDate < '2021-01-01' AND ModifiedDate < '2021-01-01') AND Id < 0 -- kvdelete
)
INSERT INTO [dba].[RetailerExpired]
           ([Id]
           ,[TotalRow]
           ,[Duration]
           ,[ErrorCode]
           ,[ErrorMessage]
           ,[ExpiryDate]
           ,[ModifiedDate]
           ,[StartTime]
           ,[EndTime])
SELECT s.Id, 0, 0, NULL, NULL, t.ExpiryDate, t.ModifiedDate, NULL, NULL
FROM cte s
LEFT JOIN #TmpRetailer t ON s.Id = ABS(t.Id)
GO
/* Step 4: Process */
EXEC('ALTER TABLE [SamplePrescription] DISABLE TRIGGER [SamplePrescription.TrackDeleted]');
EXEC('ALTER TABLE [PriceBookDetail] DISABLE TRIGGER [PriceBookDetail.TrackDeleted]');
EXEC('ALTER TABLE [Product] DISABLE TRIGGER [Product.UpdateShortDescription]');
EXEC('ALTER TABLE [Product] DISABLE TRIGGER [Product.TrackDeleted]');
EXEC('ALTER TABLE [SaleChannel] DISABLE TRIGGER [SaleChannel.TrackDeleted]');
EXEC('ALTER TABLE [Attribute] DISABLE TRIGGER [Attribute.TrackDeleted]');
EXEC('ALTER TABLE [BankAccount] DISABLE TRIGGER [BankAccount.TrackDeleted]');
EXEC('ALTER TABLE [BranchTakingAddress] DISABLE TRIGGER [BranchTakingAddress.TrackDeleted]');
EXEC('ALTER TABLE [Clinic] DISABLE TRIGGER [Clinic.TrackDeleted]');
EXEC('ALTER TABLE [Patient] DISABLE TRIGGER [Patient.TrackDeleted]');
EXEC('ALTER TABLE [Category] DISABLE TRIGGER [Category.TrackDeleted]');
EXEC('ALTER TABLE [Doctor] DISABLE TRIGGER [Doctor.TrackDeleted]');
EXEC('ALTER TABLE [DoctorQualification] DISABLE TRIGGER [DoctorQualification.TrackDeleted]');
EXEC('ALTER TABLE [Surcharge] DISABLE TRIGGER [Surcharge.TrackDeleted]');
EXEC('ALTER TABLE [DoctorSpeciality] DISABLE TRIGGER [DoctorSpeciality.TrackDeleted]');
EXEC('ALTER TABLE [TableAndRoom] DISABLE TRIGGER [TableAndRoom.TrackDeleted]');
EXEC('ALTER TABLE [Prescription] DISABLE TRIGGER [Prescription.TrackDeleted]');
EXEC('ALTER TABLE [User] DISABLE TRIGGER [User.TrackDeleted]');
EXEC('ALTER TABLE [Invoice] DISABLE TRIGGER [Update_NewInvoiceId_Return]');
EXEC('ALTER TABLE [Customer] DISABLE TRIGGER [Customer.TrackDeleted]');
EXEC('ALTER TABLE [AddressBook] DISABLE TRIGGER [AddressBook.TrackDeleted]');
EXEC('ALTER TABLE [PartnerDelivery] DISABLE TRIGGER [PartnerDelivery.TrackDeleted]');
GO
EXEC [dba].[usp_Dba_UpdateForeignKeyState]
    @DatabaseName = 'KiotVietShard11',
    @Enable = 0
GO

DECLARE @RetailerId INT = 0,
        @TotalRow INT,
        @Duration INT,
        @ErrorCode INT,
        @ErrorMessage NVARCHAR(1000)

DECLARE c CURSOR FAST_FORWARD FOR
    SELECT Id FROM [dba].[RetailerExpired] WHERE ErrorCode IS NULL OR ErrorCode <> 0

OPEN c
    FETCH NEXT FROM c INTO @RetailerId

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE [dba].[RetailerExpired]
    SET
        StartTime = GETDATE()
    WHERE Id = @RetailerId

    EXEC [dba].[usp_Dba_DeleteExpiredRetailer]
    @RetailerId = @RetailerId,
    @SrcDB = 'KiotVietShard11Archived',
	@TotalRowDeleted = @TotalRow OUTPUT,
	@Duration = @Duration OUTPUT,
	@Error = @ErrorCode OUTPUT,
	@ErrorMessage = @ErrorMessage OUTPUT

    UPDATE [dba].[RetailerExpired]
    SET
        TotalRow = @TotalRow,
        Duration = @Duration,
        ErrorCode = @ErrorCode,
        ErrorMessage = @ErrorMessage,
        EndTime = GETDATE()
    WHERE Id = @RetailerId

    FETCH NEXT FROM c INTO @RetailerId
END

CLOSE c
DEALLOCATE c
GO
EXEC [dba].[usp_Dba_UpdateForeignKeyState]
    @DatabaseName = 'KiotVietShard11',
    @Enable = 1
GO

EXEC('ALTER TABLE [SamplePrescription] ENABLE TRIGGER [SamplePrescription.TrackDeleted]');
EXEC('ALTER TABLE [PriceBookDetail] ENABLE TRIGGER [PriceBookDetail.TrackDeleted]');
EXEC('ALTER TABLE [Product] ENABLE TRIGGER [Product.UpdateShortDescription]');
EXEC('ALTER TABLE [Product] ENABLE TRIGGER [Product.TrackDeleted]');
EXEC('ALTER TABLE [SaleChannel] ENABLE TRIGGER [SaleChannel.TrackDeleted]');
EXEC('ALTER TABLE [Attribute] ENABLE TRIGGER [Attribute.TrackDeleted]');
EXEC('ALTER TABLE [BankAccount] ENABLE TRIGGER [BankAccount.TrackDeleted]');
EXEC('ALTER TABLE [BranchTakingAddress] ENABLE TRIGGER [BranchTakingAddress.TrackDeleted]');
EXEC('ALTER TABLE [Clinic] ENABLE TRIGGER [Clinic.TrackDeleted]');
EXEC('ALTER TABLE [Patient] ENABLE TRIGGER [Patient.TrackDeleted]');
EXEC('ALTER TABLE [Category] ENABLE TRIGGER [Category.TrackDeleted]');
EXEC('ALTER TABLE [Doctor] ENABLE TRIGGER [Doctor.TrackDeleted]');
EXEC('ALTER TABLE [DoctorQualification] ENABLE TRIGGER [DoctorQualification.TrackDeleted]');
EXEC('ALTER TABLE [Surcharge] ENABLE TRIGGER [Surcharge.TrackDeleted]');
EXEC('ALTER TABLE [DoctorSpeciality] ENABLE TRIGGER [DoctorSpeciality.TrackDeleted]');
EXEC('ALTER TABLE [TableAndRoom] ENABLE TRIGGER [TableAndRoom.TrackDeleted]');
EXEC('ALTER TABLE [Prescription] ENABLE TRIGGER [Prescription.TrackDeleted]');
EXEC('ALTER TABLE [User] ENABLE TRIGGER [User.TrackDeleted]');
EXEC('ALTER TABLE [Invoice] ENABLE TRIGGER [Update_NewInvoiceId_Return]');
EXEC('ALTER TABLE [Customer] ENABLE TRIGGER [Customer.TrackDeleted]');
EXEC('ALTER TABLE [AddressBook] ENABLE TRIGGER [AddressBook.TrackDeleted]');
EXEC('ALTER TABLE [PartnerDelivery] ENABLE TRIGGER [PartnerDelivery.TrackDeleted]');
GO
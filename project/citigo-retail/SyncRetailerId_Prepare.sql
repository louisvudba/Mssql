USE EventMonitoring
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.schemas WHERE Name = 'Ref19')
	EXEC ('CREATE SCHEMA [Ref19]')
GO

DROP TABLE IF EXISTS Ref19._Tmp_SyncRetailerId
CREATE TABLE Ref19._Tmp_SyncRetailerId
(
    Id INT IDENTITY(1,1) PRIMARY KEY,
    DatabaseName VARCHAR(150),
    TableName VARCHAR(150),
    BackupTableName VARCHAR(150),
    WrongRetailerIdCount INT,
	RetailerIdColumn VARCHAR(100),
	PKColumn VARCHAR(50),
    Status INT
)
GO

USE KiotVietShard19
GO
DECLARE @Total BIGINT = 0
DECLARE @DatabaseName VARCHAR(50) = DB_NAME()

--1. CustomerGroupDetail
SELECT r.Id, r.GroupId, r.RetailerId CustomerGroupDetailRetailerId, d.RetailerId CustomerGroupRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_CustomerGroupDetail_Backup
--SELECT COUNT(*)
FROM [CustomerGroupDetail] r WITH (NOLOCK)
inner join [CustomerGroup] d WITH (NOLOCK)
on r.GroupId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'CustomerGroupDetail', '_Tmp_SyncRetailerId_CustomerGroupDetail_Backup', COUNT(*), 0, 'CustomerGroupRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_CustomerGroupDetail_Backup

--2. [DamageDetail]
SELECT r.Id, r.DamageId, r.RetailerId DamageDetailRetailerId, d.RetailerId DamageItemRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_DamageDetail_Backup
FROM [DamageDetail] r WITH (NOLOCK)
inner join [DamageItem] d WITH (NOLOCK)
on r.DamageId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'DamageDetail', '_Tmp_SyncRetailerId_DamageDetail_Backup', COUNT(*), 0, 'DamageItemRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_DamageDetail_Backup

--3. [DeliveryPackage]
--3.1 invoice
SELECT r.Id, r.InvoiceId, r.RetailerId DeliveryPackageRetailerId, d.RetailerId InvoiceRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_DeliveryPackage_Invoice_Backup
FROM [DeliveryPackage] r WITH (NOLOCK)
inner join [Invoice] d WITH (NOLOCK)
on r.InvoiceId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'DeliveryPackage', '_Tmp_SyncRetailerId_DeliveryPackage_Invoice_Backup', COUNT(*), 0, 'InvoiceRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_DeliveryPackage_Invoice_Backup

--3.2 Order
SELECT r.Id, r.OrderId, r.RetailerId DeliveryPackageRetailerId, d.RetailerId OrderRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_DeliveryPackage_Order_Backup
FROM [DeliveryPackage] r WITH (NOLOCK)
inner join [Order] d WITH (NOLOCK)
on r.OrderId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'DeliveryPackage', '_Tmp_SyncRetailerId_DeliveryPackage_Order_Backup', COUNT(*), 0, 'OrderRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_DeliveryPackage_Order_Backup

--4. ExpensesOtherBranch
SELECT r.Id, r.ExpensesOtherId, r.RetailerId ExpensesOtherBranchRetailerId, d.RetailerId ExpensesOtherRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ExpensesOtherBranch_Backup
FROM [ExpensesOtherBranch] r WITH (NOLOCK)
inner join [ExpensesOther] d WITH (NOLOCK)
on r.ExpensesOtherId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ExpensesOtherBranch', '_Tmp_SyncRetailerId_ExpensesOtherBranch_Backup', COUNT(*), 0, 'ExpensesOtherRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ExpensesOtherBranch_Backup

--5. [InvoiceDelivery]
SELECT r.Id, r.InvoiceId, r.RetailerId InvoiceDeliveryRetailerId, d.RetailerId InvoiceRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceDelivery_Backup
FROM [InvoiceDelivery] r WITH (NOLOCK)
inner join [Invoice] d WITH (NOLOCK)
on r.InvoiceId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'InvoiceDelivery', '_Tmp_SyncRetailerId_InvoiceDelivery_Backup', COUNT(*), 0, 'InvoiceRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceDelivery_Backup

--6. [InvoiceDeliveryTracking]
SELECT r.Id, r.InvoiceId, r.RetailerId InvoiceDeliveryTrackingRetailerId, d.RetailerId InvoiceRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceDeliveryTracking_Backup
FROM [InvoiceDeliveryTracking] r WITH (NOLOCK)
inner join [Invoice] d WITH (NOLOCK)
on r.InvoiceId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'InvoiceDeliveryTracking', '_Tmp_SyncRetailerId_InvoiceDeliveryTracking_Backup', COUNT(*), 0, 'InvoiceRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceDeliveryTracking_Backup

--7. [InvoiceDetail] // Bảng lớn
-- SELECT r.Id, r.InvoiceId, r.RetailerId InvoiceOrderSurchargeRetailerId, d.RetailerId SurchargeRetailerId
-- INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceOrderSurcharge_Backup
-- FROM [InvoiceDetail] r WITH (NOLOCK)
-- inner join [Invoice] d WITH (NOLOCK)
-- on r.InvoiceId = d.Id
-- where r.RetailerId = -1;

--8. [InvoiceMedicine]
SELECT r.InvoiceId AS Id, r.InvoiceId, r.RetailerId InvoiceMedicineRetailerId, d.RetailerId InvoiceRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceMedicine_Backup
FROM [InvoiceMedicine] r WITH (NOLOCK)
inner join [Invoice] d WITH (NOLOCK)
on r.InvoiceId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'InvoiceMedicine', '_Tmp_SyncRetailerId_InvoiceMedicine_Backup', COUNT(*), 0, 'InvoiceRetailerId', 'InvoiceId'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceMedicine_Backup

--9. [InvoiceOrderSurcharge]
SELECT r.Id, r.SurchargeId, r.RetailerId InvoiceOrderSurchargeRetailerId, d.RetailerId SurchargeRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceOrderSurcharge_Backup
FROM [InvoiceOrderSurcharge] r WITH (NOLOCK)
inner join [Surcharge] d WITH (NOLOCK)
on r.SurchargeId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'InvoiceOrderSurcharge', '_Tmp_SyncRetailerId_InvoiceOrderSurcharge_Backup', COUNT(*), 0, 'SurchargeRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceOrderSurcharge_Backup

--10. [InvoicePromotion]
SELECT r.Id, r.InvoiceId, r.RetailerId InvoicePromotionRetailerId, d.RetailerId InvoiceRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoicePromotion_Backup
FROM [InvoicePromotion] r WITH (NOLOCK)
inner join [Invoice] d WITH (NOLOCK)
on r.InvoiceId = d.Id
WHERE r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'InvoicePromotion', '_Tmp_SyncRetailerId_InvoicePromotion_Backup', COUNT(*), 0, 'InvoiceRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoicePromotion_Backup

--11. [InvoiceVoucher]
SELECT r.Id, r.InvoiceId, r.RetailerId InvoiceVoucherRetailerId, d.RetailerId InvoiceRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceVoucher_Backup
FROM InvoiceVoucher r
inner join [Invoice] d WITH (NOLOCK)
on r.InvoiceId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'InvoiceVoucher', '_Tmp_SyncRetailerId_InvoiceVoucher_Backup', COUNT(*), 0, 'InvoiceRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceVoucher_Backup

--12. [InvoiceWarranty]
SELECT r.Id, r.InvoiceId, r.RetailerId InvoiceWarrantyRetailerId, d.RetailerId InvoiceRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceWarranty_Backup
FROM InvoiceWarranty r
inner join [Invoice] d WITH (NOLOCK)
on r.InvoiceId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'InvoiceWarranty', '_Tmp_SyncRetailerId_InvoiceWarranty_Backup', COUNT(*), 0, 'InvoiceRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_InvoiceWarranty_Backup

--13. [ManufacturingDetail]
SELECT r.Id, r.ManufacturingId, r.RetailerId ManufacturingDetailRetailerId, d.RetailerId ManufacturingRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ManufacturingDetail_Backup
FROM [ManufacturingDetail] r WITH (NOLOCK)
inner join [Manufacturing] d WITH (NOLOCK)
on r.ManufacturingId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ManufacturingDetail', '_Tmp_SyncRetailerId_ManufacturingDetail_Backup', COUNT(*), 0, 'ManufacturingRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ManufacturingDetail_Backup

--14. ManufacturingMaterialTracking
SELECT r.Id, r.ManufacturingId, r.RetailerId ManufacturingMaterialTrackingRetailerId, d.RetailerId ManufacturingRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ManufacturingMaterialTracking_Backup
FROM [ManufacturingMaterialTracking] r WITH (NOLOCK)
inner join [Manufacturing] d WITH (NOLOCK)
on r.ManufacturingId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ManufacturingMaterialTracking', '_Tmp_SyncRetailerId_ManufacturingMaterialTracking_Backup', COUNT(*), 0, 'ManufacturingRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ManufacturingMaterialTracking_Backup

--15 [OrderDetail]
SELECT r.Id, r.OrderId, r.RetailerId OrderDetailRetailerId, d.RetailerId OrderRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderDetail_Backup
FROM [OrderDetail] r WITH (NOLOCK)
inner join [Order] d WITH (NOLOCK)
on r.OrderId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'OrderDetail', '_Tmp_SyncRetailerId_OrderDetail_Backup', COUNT(*), 0, 'OrderRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderDetail_Backup

--16. [OrderPromotion]
SELECT r.Id, r.OrderId, r.RetailerId OrderPromotionRetailerId, d.RetailerId OrderRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderPromotion_Backup
FROM [OrderPromotion] r WITH (NOLOCK)
inner join [Order] d WITH (NOLOCK)
on r.OrderId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'OrderPromotion', '_Tmp_SyncRetailerId_OrderPromotion_Backup', COUNT(*), 0, 'OrderRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderPromotion_Backup

--17. [OrderSupplierDetail]
SELECT r.Id, r.OrderSupplierId, r.RetailerId OrderSupplierDetailRetailerId, d.RetailerId OrderSupplierRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderSupplierDetail_Backup
FROM [OrderSupplierDetail] r WITH (NOLOCK)
inner join [OrderSupplier] d WITH (NOLOCK)
on r.OrderSupplierId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'OrderSupplierDetail', '_Tmp_SyncRetailerId_OrderSupplierDetail_Backup', COUNT(*), 0, 'OrderSupplierRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderSupplierDetail_Backup

--18. [PartnerDeliveryGroupDetail]
SELECT r.Id, r.PartnerDeliveryId, r.RetailerId PartnerDeliveryGroupDetailRetailerId, d.RetailerId PartnerDeliveryRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PartnerDeliveryGroupDetail_Backup
FROM [PartnerDeliveryGroupDetail] r WITH (NOLOCK)
inner join [PartnerDelivery] d WITH (NOLOCK)
on r.PartnerDeliveryId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PartnerDeliveryGroupDetail', '_Tmp_SyncRetailerId_PartnerDeliveryGroupDetail_Backup', COUNT(*), 0, 'PartnerDeliveryRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PartnerDeliveryGroupDetail_Backup

--19. [PrescriptionDetail]
SELECT r.Id, r.ProductId, r.RetailerId PrescriptionDetailRetailerId, d.RetailerId ProductRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PrescriptionDetail_Backup
FROM [PrescriptionDetail] r WITH (NOLOCK)
inner join [Product] d WITH (NOLOCK)
on r.ProductId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PrescriptionDetail', '_Tmp_SyncRetailerId_PrescriptionDetail_Backup', COUNT(*), 0, 'ProductRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PrescriptionDetail_Backup

--20. [PriceBookBranch]
SELECT r.Id, r.BranchId, r.RetailerId PriceBookBranchRetailerId, d.RetailerId BranchRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookBranch_Backup
FROM [PriceBookBranch] r WITH (NOLOCK)
inner join [Branch] d WITH (NOLOCK)
on r.BranchId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PriceBookBranch', '_Tmp_SyncRetailerId_PriceBookBranch_Backup', COUNT(*), 0, 'BranchRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookBranch_Backup

-- Lamvt
--21. [PriceBookCustomerGroup]
SELECT r.Id, r.CustomerGroupId, r.RetailerId PriceBookCustomerGroupRetailerId, d.RetailerId CustomerGroupRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookCustomerGroup_Backup
FROM [PriceBookCustomerGroup] r WITH (NOLOCK)
inner join [CustomerGroup] d WITH (NOLOCK)
on r.CustomerGroupId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PriceBookCustomerGroup', '_Tmp_SyncRetailerId_PriceBookCustomerGroup_Backup', COUNT(*), 0, 'CustomerGroupRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookCustomerGroup_Backup

--22. [PriceBookDetail]
SELECT r.Id, r.PriceBookId, r.RetailerId PriceBookDetailRetailerId, d.RetailerId PriceBookRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookDetail_Backup
FROM [PriceBookDetail] r WITH (NOLOCK)
inner join [PriceBook] d WITH (NOLOCK)
on r.PriceBookId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PriceBookDetail', '_Tmp_SyncRetailerId_PriceBookDetail_Backup', COUNT(*), 0, 'PriceBookRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookDetail_Backup

--23. [PriceBookUser]
SELECT r.Id, r.PriceBookId, r.RetailerId PriceBookUserRetailerId, d.RetailerId PriceBookRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookUser_Backup
FROM [PriceBookUser] r WITH (NOLOCK)
inner join [PriceBook] d WITH (NOLOCK)
on r.PriceBookId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PriceBookUser', '_Tmp_SyncRetailerId_PriceBookUser_Backup', COUNT(*), 0, 'PriceBookRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PriceBookUser_Backup

--24. [ProductAttribute]
SELECT r.Id, r.ProductId, r.RetailerId ProductAttributeRetailerId, d.RetailerId ProductRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductAttribute_Backup
FROM [ProductAttribute] r WITH (NOLOCK)
inner join [Product] d WITH (NOLOCK)
on r.ProductId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ProductAttribute', '_Tmp_SyncRetailerId_ProductAttribute_Backup', COUNT(*), 0, 'ProductRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductAttribute_Backup

--25. [ProductFormula]
SELECT r.Id, r.ProductId, r.RetailerId ProductFormulaRetailerId, d.RetailerId ProductRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductFormula_Backup
FROM [ProductFormula] r WITH (NOLOCK)
inner join [Product] d WITH (NOLOCK)
on r.ProductId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ProductFormula', '_Tmp_SyncRetailerId_ProductFormula_Backup', COUNT(*), 0, 'ProductRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductFormula_Backup

--26. [ProductImage]
SELECT r.Id, r.ProductId, r.RetailerId ProductImageRetailerId, d.RetailerId ProductRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductImage_Backup
FROM [ProductImage] r WITH (NOLOCK)
inner join [Product] d WITH (NOLOCK)
on r.ProductId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ProductImage', '_Tmp_SyncRetailerId_ProductImage_Backup', COUNT(*), 0, 'ProductRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductImage_Backup

--27. [ProductShelves]
SELECT r.Id, r.ProductId, r.RetailerId ProductShelvesRetailerId, d.RetailerId ProductRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductShelves_Backup
FROM [ProductShelves] r WITH (NOLOCK)
inner join [Product] d WITH (NOLOCK)
on r.ProductId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ProductShelves', '_Tmp_SyncRetailerId_ProductShelves_Backup', COUNT(*), 0, 'ProductRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ProductShelves_Backup

--28. [PurchaseOrderDetail]
SELECT r.Id, r.PurchaseId, r.RetailerId PurchaseOrderDetailRetailerId, d.RetailerId PurchaseOrderRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseOrderDetail_Backup
FROM [PurchaseOrderDetail] r WITH (NOLOCK)
inner join [PurchaseOrder] d WITH (NOLOCK)
on r.PurchaseId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PurchaseOrderDetail', '_Tmp_SyncRetailerId_PurchaseOrderDetail_Backup', COUNT(*), 0, 'PurchaseOrderRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseOrderDetail_Backup

--29. PurchaseOrderExpensesOther
SELECT r.Id, r.PurchaseId, r.RetailerId PurchaseOrderExpensesOtherRetailerId, d.RetailerId PurchaseOrderRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseOrderExpensesOther_Backup
FROM [PurchaseOrderExpensesOther] r WITH (NOLOCK)
inner join [PurchaseOrder] d WITH (NOLOCK)
on r.PurchaseId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PurchaseOrderExpensesOther', '_Tmp_SyncRetailerId_PurchaseOrderExpensesOther_Backup', COUNT(*), 0, 'PurchaseOrderRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseOrderExpensesOther_Backup

--19. OrderSupplierExpensesOther
SELECT r.Id, r.OrderSupplierId, r.RetailerId OrderSupplierExpensesOtherRetailerId, d.RetailerId OrderSupplierRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderSupplierExpensesOther_Backup
FROM [OrderSupplierExpensesOther] r WITH (NOLOCK)
inner join [OrderSupplier] d WITH (NOLOCK)
on r.OrderSupplierId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'OrderSupplierExpensesOther', '_Tmp_SyncRetailerId_OrderSupplierExpensesOther_Backup', COUNT(*), 0, 'OrderSupplierRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_OrderSupplierExpensesOther_Backup

----31. [PurchaseReturn]
--SELECT r.Id, r.InvoiceId, r.RetailerId PurchaseReturnRetailerId, d.RetailerId DamageItemRetailerId
--INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseReturn_Backup
--FROM [PurchaseReturn] r WITH (NOLOCK)
--inner join [DamageItem] d WITH (NOLOCK)
--on r.DamageId = d.Id
--where r.RetailerId = -1;

--INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
--SELECT @DatabaseName,'PurchaseReturn', NULL, COUNT(*), 0, 'CustomerGroupRetailerId', 'Id'
--FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseReturn_Backup

--32. [PurchaseReturnDetail]
SELECT r.Id, r.PurchaseReturnId, r.RetailerId PurchaseReturnDetailRetailerId, d.RetailerId PurchaseReturnRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseReturnDetail_Backup
FROM [PurchaseReturnDetail] r WITH (NOLOCK)
inner join [PurchaseReturn] d WITH (NOLOCK)
on r.PurchaseReturnId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PurchaseReturnDetail', '_Tmp_SyncRetailerId_PurchaseReturnDetail_Backup', COUNT(*), 0, 'PurchaseReturnRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseReturnDetail_Backup

--33. PurchaseReturnExpensesOther
SELECT r.Id, r.PurchaseId, r.RetailerId PurchaseReturnExpensesOtherRetailerId, d.RetailerId PurchaseReturnRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseReturnExpensesOther_Backup
FROM [PurchaseReturnExpensesOther] r WITH (NOLOCK)
inner join [PurchaseReturn] d WITH (NOLOCK)
on r.PurchaseId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'PurchaseReturnExpensesOther', '_Tmp_SyncRetailerId_PurchaseReturnExpensesOther_Backup', COUNT(*), 0, 'PurchaseReturnRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_PurchaseReturnExpensesOther_Backup

--34. [ReturnDetail]
SELECT r.Id, r.ReturnId, r.RetailerId ReturnDetailRetailerId, d.RetailerId ReturnRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ReturnDetail_Backup
FROM [ReturnDetail] r WITH (NOLOCK)
inner join [Return] d WITH (NOLOCK)
on r.ReturnId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'ReturnDetail', '_Tmp_SyncRetailerId_ReturnDetail_Backup', COUNT(*), 0, 'ReturnRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_ReturnDetail_Backup

--35. [StockTakeDetail]
SELECT r.Id, r.StockTakeId, r.RetailerId StockTakeDetailRetailerId, d.RetailerId StockTakeRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_StockTakeDetail_Backup
FROM [StockTakeDetail] r WITH (NOLOCK)
inner join [StockTake] d WITH (NOLOCK)
on r.StockTakeId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'StockTakeDetail', '_Tmp_SyncRetailerId_StockTakeDetail_Backup', COUNT(*), 0, 'StockTakeRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_StockTakeDetail_Backup

--36. [SupplierGroupDetail]
SELECT r.Id, r.SupplierId, r.RetailerId SupplierGroupDetailRetailerId, d.RetailerId SupplierRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_SupplierGroupDetail_Backup
FROM [SupplierGroupDetail] r WITH (NOLOCK)
inner join [Supplier] d WITH (NOLOCK)
on r.SupplierId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'SupplierGroupDetail', '_Tmp_SyncRetailerId_SupplierGroupDetail_Backup', COUNT(*), 0, 'SupplierRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_SupplierGroupDetail_Backup

--37. [SurchargeBranch]
SELECT r.Id, r.SurchargeId, r.RetailerId SurchargeBranchRetailerId, d.RetailerId SurchargeRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_SurchargeBranch_Backup
FROM [SurchargeBranch] r WITH (NOLOCK)
inner join [Surcharge] d WITH (NOLOCK)
on r.SurchargeId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'SurchargeBranch', '_Tmp_SyncRetailerId_SurchargeBranch_Backup', COUNT(*), 0, 'SurchargeRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_SurchargeBranch_Backup

--38. [TransferDetail]
SELECT r.Id, r.TransferId, r.RetailerId TransferDetailRetailerId, d.RetailerId TransferRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_TransferDetail_Backup
FROM [TransferDetail] r WITH (NOLOCK)
inner join [Transfer] d WITH (NOLOCK)
on r.TransferId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'TransferDetail', '_Tmp_SyncRetailerId_TransferDetail_Backup', COUNT(*), 0, 'TransferRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_TransferDetail_Backup

--39. [VoucherBranch]
SELECT r.Id, r.VoucherCampaignId, r.RetailerId VoucherBranchRetailerId, d.RetailerId VoucherCampaignRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_VoucherBranch_Backup
FROM [VoucherBranch] r WITH (NOLOCK)
inner join [VoucherCampaign] d WITH (NOLOCK)
on r.VoucherCampaignId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'VoucherBranch', '_Tmp_SyncRetailerId_VoucherBranch_Backup', COUNT(*), 0, 'VoucherCampaignRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_VoucherBranch_Backup

--40. [VoucherCustomerGroup]
SELECT r.Id, r.VoucherCampaignId, r.RetailerId VoucherCustomerGroupRetailerId, d.RetailerId VoucherCampaignRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_VoucherCustomerGroup_Backup
FROM [VoucherCustomerGroup] r WITH (NOLOCK)
inner join [VoucherCampaign] d WITH (NOLOCK)
on r.VoucherCampaignId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'VoucherCustomerGroup', '_Tmp_SyncRetailerId_VoucherCustomerGroup_Backup', COUNT(*), 0, 'VoucherCampaignRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_VoucherCustomerGroup_Backup

--41. [VoucherUser]
SELECT r.Id, r.VoucherCampaignId, r.RetailerId VoucherUserRetailerId, d.RetailerId VoucherCampaignRetailerId
INTO EventMonitoring.[Ref19]._Tmp_SyncRetailerId_VoucherUser_Backup
FROM [VoucherUser] r WITH (NOLOCK)
inner join [VoucherCampaign] d WITH (NOLOCK)
on r.VoucherCampaignId = d.Id
where r.RetailerId = -1;

INSERT EventMonitoring.Ref19._Tmp_SyncRetailerId (DatabaseName, TableName, BackupTableName, WrongRetailerIdCount, Status, RetailerIdColumn, PKColumn)
SELECT @DatabaseName,'VoucherUser', '_Tmp_SyncRetailerId_VoucherUser_Backup', COUNT(*), 0, 'VoucherCampaignRetailerId', 'Id'
FROM EventMonitoring.[Ref19]._Tmp_SyncRetailerId_VoucherUser_Backup
GO

USE EventMonitoring
GO
UPDATE [Ref19].[_Tmp_SyncRetailerId]
SET BackupTableName = 'Ref19.' + BackupTableName
GO
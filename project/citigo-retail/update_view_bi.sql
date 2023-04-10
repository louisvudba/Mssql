/****** Object:  View [dbo].[Customer_Bi]    Script Date: 4/17/2021 11:28:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Customer_Bi') AND type = 'V')
    EXEC ('CREATE VIEW [dbo].[Customer_Bi] AS SELECT 1 Id')
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Retailer_Bi') AND type = 'V')
    EXEC ('CREATE VIEW [dbo].[Retailer_Bi] AS SELECT 1 Id')
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.Supplier_Bi') AND type = 'V')
    EXEC ('CREATE VIEW [dbo].[Supplier_Bi] AS SELECT 1 Id')
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.fnc_cleanphoneBI') AND type = 'FN')
    EXEC ('CREATE FUNCTION [dbo].[fnc_cleanphoneBI] ( ) RETURNS NVARCHAR(100) AS BEGIN RETURN NULL END')
GO
ALTER FUNCTION [dbo].[fnc_cleanphoneBI]
(	
	@str AS NVARCHAR(100),
	@expres AS VARCHAR(100)	 
)
RETURNS NVARCHAR(100)
BEGIN	 
	SET @str =  Lower(@str)
	SET @expres = (--Remove special characters
		CASE WHEN ISNULL(@expres,'') ='' THEN '%[-,~,@,#,$,%,&,*,(,),.,!,^,_,+,=,_, ,|,\,/,;,>,<,`,:,'',",{,},?]%'	ELSE  @expres END)			
	
	WHILE PATINDEX( @expres, @str ) > 0
	SET @str = REPLACE(REPLACE(REPLACE(REPLACE(@str, SUBSTRING(@str, PATINDEX( @expres, @str ), 1 ),''),']',''),'[',''),'{DEL}','')
	SET @str = (--Remove 84 if exists
		CASE WHEN LEFT(@str, 1) != '0' THEN (CASE
                                                WHEN LEFT(@str, 2) = '84' THEN CONCAT('0', SUBSTRING(@str, 3, LEN(@str)))
                                                ELSE (CASE
                                                          WHEN LEN(@str) < 10 THEN CONCAT('0', @str)
                                                          ELSE @str
                                                      END)
                                            END)
			ELSE @str 
		END)
	SET @str = (--Convert to new @str format
		CASE
           WHEN LEFT(@str, 4) ='0162' THEN CONCAT('032', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0163' THEN CONCAT('033', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0164' THEN CONCAT('034', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0165' THEN CONCAT('035', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0166' THEN CONCAT('036', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0167' THEN CONCAT('037', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0168' THEN CONCAT('038', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0169' THEN CONCAT('039', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0120' THEN CONCAT('070', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0121' THEN CONCAT('079', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0122' THEN CONCAT('077', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0126' THEN CONCAT('076', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0128' THEN CONCAT('078', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0123' THEN CONCAT('083', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0124' THEN CONCAT('084', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0125' THEN CONCAT('085', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0127' THEN CONCAT('081', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0129' THEN CONCAT('082', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0186' THEN CONCAT('056', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0188' THEN CONCAT('058', SUBSTRING(@str, 5, LEN(@str)))
           WHEN LEFT(@str, 4) ='0199' THEN CONCAT('059', SUBSTRING(@str, 5, LEN(@str)))
           ELSE @str
       END)
	RETURN @str
END
GO
CREATE OR ALTER VIEW [dbo].[Customer_Bi]  AS 
SELECT  [Id]
      ,[Type]
      ,[Code]
      ,[Name]
      ,[Gender]
      ,[Organization]
      ,[AlternativeNumber]
      ,[Email]      
      ,[Facebook]
      ,[Province]
      ,[District]
      ,[Comments]
      ,[RetailerId]
      ,[Debt]
      ,[RewardPoint]
      ,[ModifiedDate]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[CreatedBy]
      ,[BirthDate]
      ,[TaxCode]
      ,[IsBounceEmail]
      ,[LocationId]     
      ,[WardName]
      ,[Uuid]
      ,[IsActive]
      ,[isDeleted]
      ,[BranchId]
      ,[Avatar]
      ,[LastTradingDate]
      ,[TotalInvoiced]
      ,[TotalPoint]
      ,[TotalReturn]
      ,[PurchaseNumber]
      ,[Revision]   
      ,[IsUglyCustomer]
      ,[UglyCustomerReason]    
  FROM [dbo].[Customer]
GO
ALTER VIEW [dbo].[Supplier_Bi] AS
SELECT   [Id]
      ,[Name]
      ,[Company]
      ,[ContactName]
      ,HASHBYTES('SHA2_256', dbo.fnc_cleanphoneBI([Phone],'') )  phone_bi
      ,[Mobile]
      ,[Fax]
      ,[Email]
      ,[Website]
      ,[Address]
      ,[RetailerId]
      ,[Code]
      ,[CreatedDate]
      ,[CreatedBy]
      ,[ModifiedDate]
      ,[ModifiedBy]
      ,[Debt]
      ,[TaxCode]
      ,[Comment]
      ,[LocationName]
      ,[WardName]
      ,[BranchId]
      ,[isDeleted]
      ,[isActive]
      ,[SearchNumber]
  FROM [dbo].[Supplier]
GO
ALTER VIEW [dbo].[Retailer_Bi] AS 
SELECT  [Id]
      ,[CompanyName]
      ,[CompanyAddress]
      ,[LocationName]
      ,[WardName]
      ,[Website]
      ,HASHBYTES('SHA2_256', dbo.fnc_cleanphoneBI([Phone],'') )  phone_bi
      ,[Fax]
      ,[Code]
      ,[LogoUrl]
      ,[IsActive]
      ,[IsAdminActive]
      ,[GroupId]
      ,[CreatedDate]
      ,[ModifiedDate]
      ,[ExpiryDate]
      ,[Language]
      ,[CurrencyFormat]
      ,[UseCustomLogo]
      ,[Referrer]
      ,[Zone]
      ,[DateTimeNotify]
      ,[CreatedBy]
      ,[ModifiedBy]
      ,[MakeSampleData]
      ,[LatestClearData]
      ,[IndustryId]
      ,[SignUpType]
      ,[MaximumProducts]
      ,[MaximumBranchs]
      ,[LimitAccess]
      ,[NotifyLimitAccess]
      ,[ContractType]
      ,[MaximumUsers]
      ,[ContractStatus]
      ,[LimitKiotMailInMonth]
      ,[ContractDate]
      ,[MaximumFanpages]
      ,[Province]
      ,[District]
      ,[OperationTime]
      ,[BusinessModel]
      ,[MaximumSaleChannels]
  FROM [dbo].[Retailer]
GO
IF NOT EXISTS (SELECT 1/0 FROM sys.database_principals WHERE Name = 'report_read' AND type = 'S' AND authentication_type = 1)
    CREATE USER [report_read] FOR LOGIN [report_read]
GO
ALTER ROLE [db_datareader] ADD MEMBER [report_read]
GO
DENY SELECT ON dbo.Customer TO [report_read]
GO
DENY SELECT ON dbo.Retailer TO [report_read]
GO
DENY SELECT ON dbo.Supplier TO [report_read]
GO